import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stress/Screens/Auth/login.dart';
import 'package:stress/Screens/Auth/welcome.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada con éxito!')),
      );
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error al crear la cuenta')),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.standard().signIn();
      if (googleUser == null) return; // Cancelado por el usuario

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Guardar en Firestore si es nuevo usuario
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'createdAt': FieldValue.serverTimestamp(),
          'provider': 'google',
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada con Google!')),
      );
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error con Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 400;

    final double titleFontSize = isSmallScreen ? 20 : 24;
    final double labelFontSize = isSmallScreen ? 14 : 16;
    final double hintFontSize = isSmallScreen ? 13 : 15;
    final double buttonHeight = isSmallScreen ? 40 : 50;
    final double spacingLarge = isSmallScreen ? 20 : 30;
    final double spacingMedium = isSmallScreen ? 10 : 20;
    final double spacingSmall = isSmallScreen ? 5 : 8;
    final double paddingHorizontal = isSmallScreen ? 15.0 : 20.0;
    final double paddingVertical = isSmallScreen ? 5.0 : 10.0;
    final double checkboxTextFontSize = isSmallScreen ? 12 : 14;

    final Color primaryColor = colorScheme.primary;
    final Color onPrimary = colorScheme.onPrimary;
    final Color onSurface = colorScheme.onSurface;
    final Color outlineColor = theme.dividerColor;
    final Color? textColor = theme.textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isSmallScreen ? 40 : kToolbarHeight,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: isSmallScreen ? 20 : 24, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacingMedium),
              Text(
                'Crear cuenta',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: spacingLarge),

              // Campo de Correo Electrónico
              Text(
                'Correo electrónico',
                style: TextStyle(
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              SizedBox(height: spacingSmall),
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
                      color: theme.dividerColor, // Borde visible en ambos modos
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
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Correo inválido';
                  return null;
                },
              ),
              SizedBox(height: spacingMedium),

              // Campo de Crear Contraseña
              Text(
                'Crear contraseña',
                style: TextStyle(
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              SizedBox(height: spacingSmall),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Mínimo 8 caracteres',
                  hintStyle: TextStyle(fontSize: hintFontSize, color: theme.hintColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: outlineColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: outlineColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: isSmallScreen ? 8 : 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: outlineColor,
                      size: isSmallScreen ? 18 : 24,
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
              SizedBox(height: spacingMedium),

              // Campo de Confirmar Contraseña
              Text(
                'Confirmar contraseña',
                style: TextStyle(
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              SizedBox(height: spacingSmall),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Reingresa tu contraseña',
                  hintStyle: TextStyle(fontSize: hintFontSize, color: theme.hintColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: outlineColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: outlineColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: isSmallScreen ? 8 : 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: outlineColor,
                      size: isSmallScreen ? 18 : 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  if (value != _passwordController.text) return 'Las contraseñas no coinciden';
                  return null;
                },
              ),
              SizedBox(height: spacingSmall),

              // Mensaje de "Campo requerido"
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: outlineColor,
                    size: isSmallScreen ? 16 : 20,
                  ),
                  SizedBox(width: isSmallScreen ? 3 : 5),
                  Text(
                    'Campo requerido',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacingMedium),

              // Checkbox y texto de Términos y Condiciones
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: isSmallScreen ? 20 : 24,
                    height: isSmallScreen ? 20 : 24,
                    child: Checkbox(
                      value: _acceptTerms,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _acceptTerms = newValue ?? false;
                        });
                      },
                      activeColor: primaryColor,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 5 : 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _acceptTerms = !_acceptTerms;
                        });
                        // Aquí puedes abrir los Términos y Condiciones si lo deseas
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Acepto los ',
                          style: TextStyle(fontSize: checkboxTextFontSize, color: textColor),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Términos y condiciones',
                              style: TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                                fontSize: checkboxTextFontSize,
                              ),
                            ),
                            TextSpan(
                              text: ' y la ',
                              style: TextStyle(color: textColor, fontSize: checkboxTextFontSize),
                            ),
                            TextSpan(
                              text: 'Política de privacidad',
                              style: TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                                fontSize: checkboxTextFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacingLarge),

              // Botón "Crear cuenta"
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _acceptTerms ? _registerUser : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Crear cuenta',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: onPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacingMedium),

              // Botón Google
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/icon/google_logo.png',
                    height: 24,
                  ),
                  label: Text(
                    'Crear cuenta con Google',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      color: textColor,
                    ),
                  ),
                  onPressed: _signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacingMedium),

              // Botón "Iniciar sesión"
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: '¿Ya tienes una cuenta? ',
                      style: TextStyle(fontSize: isSmallScreen ? 14 : 16, color: textColor),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Iniciar sesión',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacingMedium),
            ],
          ),
        ),
      ),
    );
  }
}