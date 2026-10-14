
import 'package:flutter/material.dart';

import '../models/receita.dart';
import '../theme/app_theme.dart';

class ReceitaCard extends StatelessWidget {
  final Receita receita;
  final VoidCallback aoClicar;

  const ReceitaCard({
    super.key,
    required this.receita,
    required this.aoClicar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shadowColor: AppTheme.marrom.withValues(alpha: 0.08),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Color(0xFFF0E5DA),
        ),
      ),
      child: InkWell(
        onTap: aoClicar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: receita.img.trim().isNotEmpty
                    ? Image.network(
                        receita.img,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _imagemAlternativa();
                        },
                      )
                    : _imagemAlternativa(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.creme,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      receita.tipo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.terracota,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    receita.nome,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.marrom,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'R\$ ${receita.custoAproximado.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      color: AppTheme.terracota,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagemAlternativa() {
    return Container(
      color: AppTheme.creme,
      alignment: Alignment.center,
      child: const Icon(
        Icons.restaurant_rounded,
        size: 42,
        color: AppTheme.terracota,
      ),
    );
  }
}
