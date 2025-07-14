import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stress/home/stress_history.dart';
import 'package:stress/home/stress_monitor.dart';
import 'package:stress/resources/tips_resources.dart';
import 'package:stress/settings/account_info.dart';

import '../main.dart'; // Importa para usar darkModeNotifier

class SettingsScreen extends StatefulWidget {
  final int selectedIndex;
  const SettingsScreen({super.key, this.selectedIndex = 3});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  late int _selectedIndex;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _isDarkMode = darkModeNotifier.value;
  }

  Future<void> _onDarkModeChanged(bool value) async {
    setState(() {
      _isDarkMode = value;
      darkModeNotifier.value = value; // Esto actualiza el ValueNotifier global
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value); // Esto guarda la preferencia
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const StressMonitorScreen(selectedIndex: 0)));
    }
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const StressHistoryScreen(selectedIndex: 1)));
    }
    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const TipsResourcesScreen(selectedIndex: 2)));
    }
    if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen(selectedIndex: 3)));
    }
    if (index == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountInfoScreen(selectedIndex: 4)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color cardColor = theme.cardColor;
    Color sectionTitleColor = theme.textTheme.bodySmall?.color?.withOpacity(0.7) ?? (isDark ? Colors.white70 : Colors.black54);
    Color iconColor = theme.iconTheme.color ?? (isDark ? Colors.white70 : Colors.black54);
    Color backgroundColor = theme.scaffoldBackgroundColor;
    Color selectedBorderColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.appBarTheme.iconTheme?.color ?? theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Configuración',
          style: theme.appBarTheme.titleTextStyle ??
              TextStyle(
                color: theme.textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black),
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
          // Smartwatch
          Text(
            'Smartwatch',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: sectionTitleColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: Icon(Icons.watch, color: iconColor),
              title: Text('Smartwatch conectado:', style: theme.textTheme.bodyMedium),
              subtitle: Row(
                children: [
                  Icon(Icons.circle, color: const Color.fromARGB(255, 175, 84, 76), size: 12),
                  const SizedBox(width: 4),
                  Text('Desconectado', style: theme.textTheme.bodySmall?.copyWith(fontSize: 13)),
                ],
              ),
              trailing: TextButton(
                onPressed: () {
                  // Acción para desconectar
                },
                child: Text(
                  'Desconectar',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Notificaciones
          Text(
            'Notificaciones',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: sectionTitleColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SwitchListTile(
              secondary: Icon(Icons.notifications, color: iconColor),
              title: Text('Activar notificaciones', style: theme.textTheme.bodyMedium),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          // Personalización
          Text(
            'Personalización',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: sectionTitleColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SwitchListTile(
              secondary: Icon(Icons.dark_mode, color: iconColor),
              title: Text('Modo oscuro', style: theme.textTheme.bodyMedium),
              value: _isDarkMode,
              onChanged: _onDarkModeChanged,
            ),
          ),
          const SizedBox(height: 24),
          // Cuenta
          Text(
            'Cuenta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: sectionTitleColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: Icon(Icons.person_outline, color: iconColor),
              title: Text('Información de la cuenta', style: theme.textTheme.bodyMedium),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AccountInfoScreen(selectedIndex: 4),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: 'Monitor'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Consejos'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Cuenta'),
        ],
        backgroundColor: backgroundColor,
      ),
    );
  }
}
