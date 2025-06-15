import 'package:flutter/material.dart';
import 'package:stress/home/stress_history.dart';
import 'package:stress/home/stress_monitor.dart';
import 'package:stress/resources/tips_resources.dart';
import 'package:stress/settings/account_info.dart';

class SettingsScreen extends StatefulWidget {
  final int selectedIndex;
  const SettingsScreen({super.key, this.selectedIndex = 3});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  int _selectedColor = 0; // 0: azul, 1: rojo, 2: verde
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StressMonitorScreen(selectedIndex: 0),
        ),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StressHistoryScreen(selectedIndex: 1),
        ),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TipsResourcesScreen(selectedIndex: 2),
        ),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(selectedIndex: 3),
        ),
      );
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AccountInfoScreen(selectedIndex: 4),
        ),
      );
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
    Color borderColor = theme.dividerColor;
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
                  Icon(Icons.circle, color: Colors.green, size: 12),
                  const SizedBox(width: 4),
                  Text('Conectado', style: theme.textTheme.bodySmall?.copyWith(fontSize: 13)),
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
            child: ListTile(
              leading: Icon(Icons.color_lens, color: iconColor),
              title: Text('Colores del tema', style: theme.textTheme.bodyMedium),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _colorCircle(0, Colors.blue, selectedBorderColor),
                  const SizedBox(width: 8),
                  _colorCircle(1, Colors.red, selectedBorderColor),
                  const SizedBox(width: 8),
                  _colorCircle(2, Colors.green, selectedBorderColor),
                ],
              ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Consejos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Cuenta',
          ),
        ],
        backgroundColor: backgroundColor,
      ),
    );
  }

  Widget _colorCircle(int index, Color color, Color selectedBorderColor) {
    final theme = Theme.of(context);
    final isSelected = _selectedColor == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = index;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? selectedBorderColor : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
