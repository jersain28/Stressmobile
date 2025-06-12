import 'package:flutter/material.dart';
import 'package:stress/Screens/Auth/create_account.dart';
import 'package:stress/Screens/Auth/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get screen size information.
    // This is crucial for making the UI responsive to different screen dimensions.
    final Size screenSize = MediaQuery.of(context).size;

    // A common approach to determine if the device is a "small screen" (like a smartwatch)
    // is to check its width. Smartwatches typically have very small widths.
    // You might need to adjust this threshold based on specific smartwatch dimensions.
    final bool isSmallScreen =
        screenSize.width < 400; // Example threshold, adjust as needed

    // Determine sizes and spacing based on screen size
    final double imageSize = isSmallScreen ? 120 : 200;
    final double titleFontSize = isSmallScreen ? 20 : 24;
    final double buttonWidth = isSmallScreen ? 200 : 280;
    final double buttonHeight = isSmallScreen ? 40 : 50;
    final double spacingLarge = isSmallScreen ? 20 : 40;
    final double spacingMedium = isSmallScreen ? 15 : 30;
    final double spacingSmall = isSmallScreen ? 10 : 15;
    final double termsFontSize = isSmallScreen ? 10 : 12;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Using SingleChildScrollView to prevent overflow on very small screens
        // if content exceeds the available height.
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16.0 : 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // Ensures content is centered vertically when there's enough space
                // and pushed to the top if it overflows.
                mainAxisSize:
                    MainAxisSize.min, // Use minimum space required by children
                children: [
                  SizedBox(height: spacingMedium), // Add some top padding
                  // Application Icon
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset(
                      'assets/icon/icon.png', // Ensure this asset path is correct
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      // Add an error builder for robustness in case the image fails to load
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.error,
                          size: imageSize,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: spacingMedium),

                  // Title Text
                  Text(
                    'Salud Mental',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: spacingLarge),

                  // "Crear cuenta" Button
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to CreateAccountScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF9CA9DB,
                        ), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Crear cuenta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: spacingSmall),

                  // "Iniciar sesión" Button
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5F5F9),
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      ),
                    ),
                  ),

                  SizedBox(height: spacingLarge),

                  // Terms and Conditions Text
                  // Using FittedBox to ensure the text fits within the available width,
                  // scaling down if necessary, especially for very small screens.
                  FittedBox(
                    fit: BoxFit.scaleDown, // Scales down if needed
                    child: Text(
                      'Términos y condiciones • Política de privacidad',
                      style: TextStyle(
                        fontSize: termsFontSize,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1, // Keep on one line if possible
                      overflow: TextOverflow
                          .ellipsis, // Show ellipsis if it overflows
                    ),
                  ),
                  SizedBox(height: spacingMedium), // Add some bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
