
import 'package:flutter/material.dart';

import '../models/receita.dart';

class DetalhesReceitaScreen extends StatelessWidget {
  final Receita receita;

  const DetalhesReceitaScreen({
    super.key,
    required this.receita,
  });

  static const Color terracota = Color(0xFFB85C38);
  static const Color marrom = Color(0xFF462B20);
  static const Color fundo = Color(0xFFFFF9F2);

  List<String> _separarItens(String texto) {
    return texto
        .split(RegExp(r'\r?\n|;'))
        .expand((linha) => linha.split(','))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ingredientes = _separarItens(receita.ingredientes);

    final etapas = receita.modoFazer
        .split(RegExp(r'\r?\n'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: fundo,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: fundo,
            foregroundColor: marrom,
            surfaceTintColor: fundo,
            flexibleSpace: FlexibleSpaceBar(
              background: receita.img.isNotEmpty
                  ? Image.network(
                      receita.img,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _imagemVazia(),
                    )
                  : _imagemVazia(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4E2D2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      receita.tipo,
                      style: const TextStyle(
                        color: terracota,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    receita.nome,
                    style: const TextStyle(
                      color: marrom,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cartão de custo
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFF0E5DA),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5F2E5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.payments_outlined,
                            color: Color(0xFF39804A),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Custo aproximado',
                                style: TextStyle(
                                  color: Colors.brown.shade400,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'R\$ ${receita.custoAproximado.toStringAsFixed(2).replaceAll('.', ',')}',
                                style: const TextStyle(
                                  color: marrom,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  _tituloSecao(
                    icone: Icons.shopping_basket_outlined,
                    titulo: 'Ingredientes',
                    complemento: '${ingredientes.length} itens',
                  ),
                  const SizedBox(height: 14),

                  if (ingredientes.isEmpty)
                    _textoVazio('Nenhum ingrediente informado.')
                  else
                    ...ingredientes.asMap().entries.map((entrada) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: terracota,
                              size: 21,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entrada.value,
                                style: const TextStyle(
                                  color: marrom,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 26),

                  _tituloSecao(
                    icone: Icons.menu_book_outlined,
                    titulo: 'Modo de preparo',
                  ),
                  const SizedBox(height: 16),

                  if (etapas.isEmpty)
                    _textoVazio('Nenhum modo de preparo informado.')
                  else
                    ...etapas.asMap().entries.map((entrada) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: terracota,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${entrada.key + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  entrada.value,
                                  style: const TextStyle(
                                    color: marrom,
                                    fontSize: 14,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 18),

                  Center(
                    child: Text(
                      'Feito com carinho e um toque de sabor ♡',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.brown.shade400,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tituloSecao({
    required IconData icone,
    required String titulo,
    String? complemento,
  }) {
    return Row(
      children: [
        Icon(icone, color: terracota, size: 23),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              color: marrom,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (complemento != null)
          Text(
            complemento,
            style: TextStyle(
              color: Colors.brown.shade400,
              fontSize: 11,
            ),
          ),
      ],
    );
  }

  Widget _textoVazio(String texto) {
    return Text(
      texto,
      style: TextStyle(
        color: Colors.brown.shade400,
        fontSize: 14,
      ),
    );
  }

  Widget _imagemVazia() {
    return Container(
      color: const Color(0xFFF4E2D2),
      child: const Center(
        child: Icon(
          Icons.restaurant,
          size: 70,
          color: terracota,
        ),
      ),
    );
  }
}
