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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Información de la cuenta',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Información Personal
          const Text(
            'Información Personal',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Correo electrónico'),
                  subtitle: const Text('usuario@email.com'),
                  dense: true,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Cambiar contraseña'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // Acción para cambiar contraseña
                  },
                  dense: true,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Nombre (opcional)'),
                  subtitle: const Text('Usuario'),
                  trailing: const Icon(Icons.edit, size: 20),
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
          const Text(
            'Datos y Privacidad',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Política de privacidad'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // Acción para ver política de privacidad
                  },
                  dense: true,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Términos y condiciones'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // Acción para ver términos y condiciones
                  },
                  dense: true,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text(
                    'Eliminar mi cuenta',
                    style: TextStyle(color: Colors.red),
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
          const Text(
            'Acerca de',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Versión de la aplicación: 1.0.0'),
                  dense: true,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Soporte técnico'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
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