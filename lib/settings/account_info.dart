import 'package:flutter/material.dart';

class AccountInfoScreen extends StatefulWidget {
  final int selectedIndex;
  const AccountInfoScreen({super.key, this.selectedIndex = 4});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyMedium?.color;
    final sectionTitleColor = theme.textTheme.bodySmall?.color?.withOpacity(0.7) ?? (isDark ? Colors.white70 : Colors.black54);
    final cardColor = theme.cardColor;
    final backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.appBarTheme.iconTheme?.color ?? textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Información de la cuenta',
          style: theme.appBarTheme.titleTextStyle ??
              TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Información Personal
          Text(
            'Información Personal',
            style: TextStyle(fontWeight: FontWeight.bold, color: sectionTitleColor),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('Correo electrónico', style: TextStyle(color: textColor)),
                  subtitle: Text('usuario@email.com', style: TextStyle(color: sectionTitleColor)),
                  dense: true,
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text('Cambiar contraseña', style: TextStyle(color: textColor)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18, color: sectionTitleColor),
                  onTap: () {
                    // Acción para cambiar contraseña
                  },
                  dense: true,
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text('Nombre (opcional)', style: TextStyle(color: textColor)),
                  subtitle: Text('Usuario', style: TextStyle(color: sectionTitleColor)),
                  trailing: Icon(Icons.edit, size: 20, color: sectionTitleColor),
                  onTap: () {
                    // Acción para editar nombre
                  },
                  dense: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Datos y Privacidad
          Text(
            'Datos y Privacidad',
            style: TextStyle(fontWeight: FontWeight.bold, color: sectionTitleColor),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('Política de privacidad', style: TextStyle(color: textColor)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18, color: sectionTitleColor),
                  onTap: () {
                    // Acción para ver política de privacidad
                  },
                  dense: true,
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text('Términos y condiciones', style: TextStyle(color: textColor)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18, color: sectionTitleColor),
                  onTap: () {
                    // Acción para ver términos y condiciones
                  },
                  dense: true,
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    'Eliminar mi cuenta',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  onTap: () {
                    // Acción para eliminar cuenta
                  },
                  dense: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Acerca de
          Text(
            'Acerca de',
            style: TextStyle(fontWeight: FontWeight.bold, color: sectionTitleColor),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('Versión de la aplicación: 1.0.0', style: TextStyle(color: textColor)),
                  dense: true,
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text('Soporte técnico', style: TextStyle(color: textColor)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18, color: sectionTitleColor),
                  onTap: () {
                    // Acción para soporte técnico
                  },
                  dense: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}