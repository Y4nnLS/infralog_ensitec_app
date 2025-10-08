import 'package:flutter/material.dart';

/// Exemplo de COMPONENTE REUTILIZÁVEL (design consistente).
/// - aceita rótulo, ícone, “loading” e callback.
/// - se torna seu padrão para botões no app.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, size: 18),
              if (icon != null) const SizedBox(width: 8),
              Text(label),
            ],
          );

    return FilledButton(
      onPressed: loading ? null : onPressed,
      child: child,
    );
  }
}
