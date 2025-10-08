import 'package:flutter/material.dart';
import 'auth/keycloak_auth.dart'; // ajuste o import pro seu caminho

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: AuthProbe()));
}

class AuthProbe extends StatefulWidget {
  const AuthProbe({super.key});
  @override
  State<AuthProbe> createState() => _AuthProbeState();
}

class _AuthProbeState extends State<AuthProbe> {
  final kc = KeycloakAuth();
  String status = 'Aguardando...';

  Future<void> _login() async {
    setState(() => status = 'Abrindo navegador...');
    try {
      await kc.signIn();
      final info = await kc.getUserInfo();
      setState(() => status = 'OK: ${info['preferred_username']}');
    } catch (e, s) {
      setState(() => status = 'ERRO: $e');
      // ignore: avoid_print
      print(s);
    }
  }

  Future<void> _callApi() async {
    try {
      await kc.ensureFreshToken();
      setState(() => status = 'Token: ${kc.accessToken?.substring(0, 16)}...');
    } catch (e) {
      setState(() => status = 'ERRO API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keycloak Auth Probe')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(status),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: const Text('LOGIN')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _callApi, child: const Text('ensureFreshToken + print token')),
          ],
        ),
      ),
    );
  }
}
