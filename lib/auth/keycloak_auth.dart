import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // para kDebugMode (opcional)

class KeycloakAuth {
  final _appAuth = const FlutterAppAuth();

  // Ajuste conforme seu ambiente:
  // Emulador Android → 10.0.2.2; iOS simulador/desktop → localhost
  static const String _host = String.fromEnvironment('KC_HOST', defaultValue: '10.0.2.2:8080');
  static const String _realm = 'infralog';
  static const String _clientId = 'flutter-app';
  static const String _redirectUrl = 'com.infralog.app://login-callback';

  static String get _issuer => 'http://$_host/realms/$_realm';
  static String get _discoveryUrl => '$_issuer/.well-known/openid-configuration';
  static final bool _allowInsecure = kDebugMode;
  static const List<String> _scopes = [
    'openid',
    'profile',
    'email',
    'offline_access', // necessário para refresh token longo
  ];

  String? _accessToken;
  String? _refreshToken;
  DateTime? _accessTokenExp;

  String? get accessToken => _accessToken;

  Future<void> signIn() async {
    final result = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        _clientId,
        _redirectUrl,
        discoveryUrl: _discoveryUrl,
        scopes: _scopes,
        promptValues: const ['login'], // força tela de login
        allowInsecureConnections: _allowInsecure,
      ),
    );

    if (result == null) {
      throw Exception('Login cancelado ou sem resposta do provedor.');
    }
    if (result.accessToken == null) {
      throw Exception('Provedor não retornou access_token.');
    }

    _accessToken = result.accessToken!;
    _refreshToken = result.refreshToken; // pode ser null
    _accessTokenExp = result.accessTokenExpirationDateTime;
  }

  Future<void> ensureFreshToken() async {
    final now = DateTime.now().toUtc();

    // Se temos token válido por >60s, segue.
    if (_accessToken != null && _accessTokenExp != null) {
      if (_accessTokenExp!.toUtc().isAfter(now.add(const Duration(seconds: 60)))) {
        return;
      }
    }

    // Sem refresh token? Refaça login.
    if (_refreshToken == null) {
      await signIn();
      return;
    }

    final refresh = await _appAuth.token(
      TokenRequest(
        _clientId,
        _redirectUrl,
        discoveryUrl: _discoveryUrl,
        refreshToken: _refreshToken,
        scopes: _scopes,
        allowInsecureConnections: _allowInsecure,
      ),
    );

    if (refresh == null) {
      // refresh falhou (talvez revogado/expirado) → força novo login
      await signIn();
      return;
    }
    if (refresh.accessToken == null) {
      throw Exception('Falha no refresh: access_token ausente.');
    }

    _accessToken = refresh.accessToken!;
    _refreshToken = refresh.refreshToken ?? _refreshToken; // mantém antiga se vier null
    _accessTokenExp = refresh.accessTokenExpirationDateTime;
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    await ensureFreshToken();
    final token = _accessToken;
    if (token == null) {
      throw Exception('Sem access_token após refresh; usuário precisa autenticar.');
    }

    final url = Uri.parse('$_issuer/protocol/openid-connect/userinfo');
    final resp = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (resp.statusCode != 200) {
      throw Exception('Falha ao obter userinfo: ${resp.statusCode} ${resp.body}');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Map<String, dynamic> get realmRoles {
    final token = _accessToken;
    if (token == null) return {};
    final payload = Jwt.parseJwt(token);
    final roles = (payload['realm_access']?['roles'] as List?)?.cast<String>() ?? const <String>[];
    return {'roles': roles};
  }

  Future<void> signOut() async {
    final endSessionRequest = EndSessionRequest(
      idTokenHint: _accessToken, // opcional para KC
      postLogoutRedirectUrl: _redirectUrl,
      discoveryUrl: _discoveryUrl,
      allowInsecureConnections: _allowInsecure,
    );
    try {
      await _appAuth.endSession(endSessionRequest);
    } catch (_) {
      // Em DEV pode falhar silenciosamente; ok.
    } finally {
      _accessToken = null;
      _refreshToken = null;
      _accessTokenExp = null;
    }
  }
}
