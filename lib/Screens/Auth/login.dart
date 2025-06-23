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

  Future<void> _loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
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
    try {
      // Forzar selector de cuentas
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Verifica si el usuario ya existe en Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: googleUser.email)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        // Usuario no existe, mostrar mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Primero debes crear tu cuenta con Google.')),
        );
        await GoogleSignIn().signOut(); // Opcional: cerrar sesión de Google
        return;
      }

      // Si existe, permite el login
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyMedium?.color;
    final hintColor = theme.hintColor;
    final inputFillColor = theme.inputDecorationTheme.fillColor ?? (theme.brightness == Brightness.dark ? colorScheme.surface : const Color(0xFFE9E9E9));
    final errorColor = theme.colorScheme.error;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido de nuevo!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingresa tus credenciales para continuar',
                  style: TextStyle(fontSize: 15, color: hintColor),
                ),
                const SizedBox(height: 24),
                Text(
                  'Correo electrónico',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.cardColor,
                    hintText: 'ejemplo@correo.com',
                    hintStyle: TextStyle(color: theme.hintColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: theme.dividerColor, // Color del borde en estado normal
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary, // Color del borde enfocado
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: theme.dividerColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Contraseña',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: theme.dividerColor, // Borde visible en modo claro y oscuro
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary, // Borde enfocado
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: theme.dividerColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: theme.dividerColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
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
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: colorScheme.primary,
                        ),
                        Text('Recordarme', style: TextStyle(color: textColor)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgot_password');
                      },
                      child: Text(
                        '¿Olvidé mi contraseña?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_showError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: errorColor, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'Correo electrónico o contraseña incorrectos',
                          style: TextStyle(color: errorColor),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _loginUser,
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Image.asset(
                      'assets/icon/google_logo.png',
                      height: 24,
                    ),
                    label: Text(
                      'Iniciar sesión con Google',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: _signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¿No tienes una cuenta? ', style: TextStyle(color: textColor)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ));
                        },
                        child: Text(
                          'Crear cuenta',
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
