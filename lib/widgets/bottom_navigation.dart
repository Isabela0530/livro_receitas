
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BottomNavigation extends StatelessWidget {
  final int indiceSelecionado;
  final ValueChanged<int> aoSelecionar;

  const BottomNavigation({
    super.key,
    required this.indiceSelecionado,
    required this.aoSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: indiceSelecionado,
      onDestinationSelected: aoSelecionar,
      backgroundColor: Colors.white,
      indicatorColor: AppTheme.creme,
      elevation: 0,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Início',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border_rounded),
          selectedIcon: Icon(Icons.favorite_rounded),
          label: 'Favoritos',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline_rounded),
          selectedIcon: Icon(Icons.add_circle_rounded),
          label: 'Cadastrar',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Perfil',
        ),
      ],
    );
  }
}
