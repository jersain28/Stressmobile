import 'package:flutter/material.dart';

class TipDetailScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final String details; // Nuevo campo

  const TipDetailScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.details, // Nuevo campo requerido
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = theme.iconTheme.color ?? (isDark ? Colors.white70 : Colors.black54);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 60, color: iconColor),
              const SizedBox(height: 24),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                desc,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text(
                details,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}