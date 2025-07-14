import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stress/Screens/Auth/create_account.dart';
import 'package:stress/onboarding/smartwatch_connection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _showError = false;
  bool _obscurePassword = true;

  // --- LÓGICA DE AUTENTICACIÓN (Sin cambios) ---
  Future<void> _loginUser() async {
    // ... (Tu código original de _loginUser se mantiene igual)
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final firestoreName = doc.data()?['displayName'];
        if (firestoreName != null && firestoreName != user.displayName) {
          await user.updateDisplayName(firestoreName);
          await user.reload();
        }
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SmartwatchConnectionScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error al iniciar sesión')),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    // ... (Tu código original de _signInWithGoogle se mantiene igual)
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: googleUser.email)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Primero debes crear tu cuenta con Google.')),
        );
        await GoogleSignIn().signOut();
        return;
      }

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SmartwatchConnectionScreen(),
        ),
      );
    } catch (e) {
      setState(() {
        _showError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error con Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos LayoutBuilder para decidir qué UI mostrar
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Un ancho típico para relojes es menor a 300.
          // Puedes ajustar este valor si es necesario.
          if (constraints.maxWidth < 300) {
            // PANTALLA PEQUEÑA (SMARTWATCH)
            return _buildWatchLayout(context);
          } else {
            // PANTALLA GRANDE (MÓVIL)
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  /// UI para Smartwatch: Simple y directa ⌚
  Widget _buildWatchLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyMedium?.color;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Bienvenido',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            icon: Image.asset(
              'assets/icon/google_logo.png', // Asegúrate que este asset exista
              height: 24,
            ),
            label: Text(
              'Ingresar',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            onPressed: _signInWithGoogle,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Más redondeado para reloj
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// UI para Móvil: Tu código original sin cambios 📱
  Widget _buildMobileLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyMedium?.color;
    final hintColor = theme.hintColor;
    final errorColor = theme.colorScheme.error;

    // Simplemente retorna tu layout original
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Todo tu Column original va aquí ---
              Text('¡Bienvenido de nuevo!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 8),
              Text('Ingresa tus credenciales para continuar', style: TextStyle(fontSize: 15, color: hintColor)),
              const SizedBox(height: 24),
              Text('Correo electrónico', style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.cardColor,
                  hintText: 'ejemplo@correo.com',
                  // ... el resto de tu decoración
                   hintStyle: TextStyle(color: theme.hintColor),
                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.dividerColor, width: 1.5)),
                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.colorScheme.primary, width: 2)),
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.dividerColor, width: 1.5)),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.cardColor,
                    hintText: 'Mínimo 8 caracteres',
                    hintStyle: TextStyle(color: theme.hintColor),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.dividerColor, width: 1.5)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.colorScheme.primary, width: 2)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.dividerColor, width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: theme.dividerColor),
                      onPressed: () { setState(() { _obscurePassword = !_obscurePassword; }); },
                    ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  if (value.length < 8) return 'Mínimo 8 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [ Checkbox(value: _rememberMe, onChanged: (value) { setState(() { _rememberMe = value ?? false; }); }, activeColor: colorScheme.primary), Text('Recordarme', style: TextStyle(color: textColor)),]),
                  GestureDetector(onTap: () { Navigator.pushNamed(context, '/forgot_password'); }, child: Text('¿Olvidé mi contraseña?', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary))),
                ],
              ),
              if (_showError) Padding(padding: const EdgeInsets.only(top: 8.0, bottom: 8.0), child: Row(children: [Icon(Icons.error, color: errorColor, size: 20), const SizedBox(width: 6), Text('Correo electrónico o contraseña incorrectos', style: TextStyle(color: errorColor))])),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: _loginUser, child: const Text('Iniciar sesión', style: TextStyle(fontSize: 16)))),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(icon: Image.asset('assets/icon/google_logo.png', height: 24), label: Text('Iniciar sesión con Google', style: TextStyle(color: textColor, fontSize: 16)), onPressed: _signInWithGoogle, style: OutlinedButton.styleFrom(side: BorderSide(color: colorScheme.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
              const SizedBox(height: 16),
              Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('¿No tienes una cuenta? ', style: TextStyle(color: textColor)), GestureDetector(onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccountScreen()));}, child: Text('Crear cuenta', style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.bold)))])),
            ],
          ),
        ),
      ),
    );
  }
}