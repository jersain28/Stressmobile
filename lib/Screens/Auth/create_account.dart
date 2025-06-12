import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState(); // Renombrado el estado para consistencia
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla para ajustar los elementos
    final Size screenSize = MediaQuery.of(context).size;
    // Definir si la pantalla es considerada "pequeña" (ej. smartwatch)
    final bool isSmallScreen = screenSize.width < 400; // Umbral ajustable

    // Ajustar los tamaños de fuentes y espaciado según el tamaño de la pantalla
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

    return Scaffold(
      appBar: AppBar(
        // El AppBar se mantiene, pero la altura puede ser mínima para pantallas pequeñas
        toolbarHeight: isSmallScreen ? 40 : kToolbarHeight, // kToolbarHeight es la altura por defecto
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: isSmallScreen ? 20 : 24),
          onPressed: () {
            // Acción para regresar a la pantalla anterior
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView( // Envuelve el Column para evitar desbordamiento en pantallas pequeñas
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: spacingMedium),
            Text(
              'Crear cuenta',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: spacingLarge),

            // Campo de Correo Electrónico
            Text(
              'Correo electrónico',
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: spacingSmall),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'ejemplo@correo.com',
                hintStyle: TextStyle(fontSize: hintFontSize),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF9CA9DB)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: isSmallScreen ? 8 : 12),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: spacingMedium),

            // Campo de Crear Contraseña
            Text(
              'Crear contraseña',
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: spacingSmall),
            TextFormField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Mínimo 8 caracteres',
                hintStyle: TextStyle(fontSize: hintFontSize),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF9CA9DB)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: isSmallScreen ? 8 : 12),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: isSmallScreen ? 18 : 24, // Ajustar tamaño del icono
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: spacingMedium),

            // Campo de Confirmar Contraseña
            Text(
              'Confirmar contraseña',
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: spacingSmall),
            TextFormField(
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                hintText: 'Reingresa tu contraseña',
                hintStyle: TextStyle(fontSize: hintFontSize),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF9CA9DB)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: isSmallScreen ? 8 : 12),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: isSmallScreen ? 18 : 24, // Ajustar tamaño del icono
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: spacingSmall),

            // Mensaje de "Campo requerido"
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: isSmallScreen ? 16 : 20, // Ajustar tamaño del icono
                ),
                SizedBox(width: isSmallScreen ? 3 : 5),
                Text(
                  'Campo requerido',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacingMedium),

            // Checkbox y texto de Términos y Condiciones
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinea el checkbox arriba del texto
              children: [
                SizedBox(
                  width: isSmallScreen ? 20 : 24, // Ajustar tamaño del checkbox
                  height: isSmallScreen ? 20 : 24,
                  child: Checkbox(
                    value: _acceptTerms,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _acceptTerms = newValue ?? false;
                      });
                    },
                    activeColor: const Color(0xFF9CA9DB),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 5 : 8),
                Expanded(
                  child: GestureDetector( // Permite que todo el texto sea clickeable
                    onTap: () {
                      setState(() {
                        _acceptTerms = !_acceptTerms; // También cambia el checkbox al tocar el texto
                      });
                      // Puedes agregar aquí la lógica para abrir los Términos y Condiciones
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Acepto los ',
                        style: TextStyle(fontSize: checkboxTextFontSize, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Términos y condiciones',
                            style: TextStyle(
                              color: const Color(0xFF9CA9DB),
                              decoration: TextDecoration.underline,
                              fontSize: checkboxTextFontSize,
                            ),
                          ),
                          TextSpan(
                            text: ' y la ',
                            style: TextStyle(color: Colors.black, fontSize: checkboxTextFontSize),
                          ),
                          TextSpan(
                            text: 'Política de privacidad',
                            style: TextStyle(
                              color: const Color(0xFF9CA9DB),
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
                onPressed: _acceptTerms
                    ? () {
                        // Implementa la lógica para crear la cuenta aquí
                        // Por ejemplo:
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Cuenta creada con éxito!')),
                        // );
                      }
                    : null, // El botón está deshabilitado si no se aceptan los términos
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9CA9DB),
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
                    color: Colors.white,
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
                  // Implementa la navegación a la pantalla de inicio de sesión
                  // Por ejemplo:
                  // Navigator.pop(context); // O pushReplacement para ir a la pantalla de login
                },
                child: RichText(
                  text: TextSpan(
                    text: '¿Ya tienes una cuenta? ',
                    style: TextStyle(fontSize: isSmallScreen ? 14 : 16, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Iniciar sesión',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF9CA9DB),
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: spacingMedium), // Espacio al final
          ],
        ),
      ),
    );
  }
}