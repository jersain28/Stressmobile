import 'package:flutter/material.dart';
import 'package:stress/Screens/Auth/create_account.dart';
import 'package:stress/Screens/Auth/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyMedium?.color;
    final backgroundColor = theme.scaffoldBackgroundColor;

    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 400;

    final double imageSize = isSmallScreen ? 120 : 200;
    final double titleFontSize = isSmallScreen ? 20 : 24;
    final double buttonWidth = isSmallScreen ? 200 : 280;
    final double buttonHeight = isSmallScreen ? 40 : 50;
    final double spacingLarge = isSmallScreen ? 20 : 40;
    final double spacingMedium = isSmallScreen ? 15 : 30;
    final double spacingSmall = isSmallScreen ? 10 : 15;
    final double termsFontSize = isSmallScreen ? 10 : 12;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16.0 : 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: spacingMedium),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset(
                      'assets/icon/icon.png',
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.error,
                          size: imageSize,
                          color: colorScheme.error,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: spacingMedium),
                  Text(
                    'Salud Mental',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: spacingLarge),
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Crear cuenta',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: spacingSmall),
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
                        backgroundColor: colorScheme.surface,
                        foregroundColor: textColor,
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
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Términos y condiciones • Política de privacidad',
                      style: TextStyle(
                        fontSize: termsFontSize,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7) ?? Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: spacingMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
