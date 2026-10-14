
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _abrirHome();
  }

  Future<void> _abrirHome() async {
    await Future<void>.delayed(
      const Duration(seconds: 3),
    );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fundo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppTheme.creme,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 58,
                color: AppTheme.terracota,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Livro de Receitas',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.marrom,
                fontSize: 29,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Receitas feitas com carinho ♡',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.marrom.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppTheme.terracota,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
