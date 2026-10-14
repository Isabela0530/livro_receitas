
import 'package:flutter/material.dart';

import '../models/receita.dart';
import '../services/receita_service.dart';
import 'cadastro_receita_screen.dart';
import 'detalhes_receita_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ReceitaService _service = ReceitaService();

  late Future<List<Receita>> _futureReceitas;

  String _categoriaSelecionada = 'TODAS';

  final List<Map<String, dynamic>> _categorias = [
    {'nome': 'TODAS', 'icone': Icons.restaurant_menu},
    {'nome': 'SALGADA', 'icone': Icons.lunch_dining},
    {'nome': 'DOCE', 'icone': Icons.cake_outlined},
    {'nome': 'BEBIDA', 'icone': Icons.local_cafe_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _futureReceitas = _service.listarReceitas();
  }

  void _recarregar() {
    setState(() {
      _futureReceitas = _service.listarReceitas();
    });
  }

  Future<void> _abrirCadastro() async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => const CadastroReceitaScreen(),
      ),
    );

    if (!mounted) return;

    if (resultado == true) {
      _recarregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _recarregar();
            await _futureReceitas;
          },
          color: const Color(0xFFB85C38),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _cabecalho()),
              SliverToBoxAdapter(child: _campoBuscaVisual()),
              SliverToBoxAdapter(child: _categoriasWidget()),
              SliverToBoxAdapter(child: _tituloSecao()),
              FutureBuilder<List<Receita>>(
                future: _futureReceitas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFB85C38),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: _mensagemErro(),
                    );
                  }

                  final receitas = snapshot.data ?? [];

                  final filtradas =
                      _categoriaSelecionada == 'TODAS'
                          ? receitas
                          : receitas.where((receita) {
                              return receita.tipo.toUpperCase() ==
                                  _categoriaSelecionada;
                            }).toList();

                  if (filtradas.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Nenhuma receita encontrada nesta categoria.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.brown.shade400,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _cardReceita(filtradas[index]);
                        },
                        childCount: filtradas.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.67,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _navegacaoInferior(),
    );
  }

  Widget _cabecalho() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SEU CANTINHO CULINÁRIO',
                  style: TextStyle(
                    color: Colors.brown.shade400,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Livro de Receitas',
                  style: TextStyle(
                    color: Color(0xFF462B20),
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Inspiração para sua próxima refeição.',
                  style: TextStyle(
                    color: Colors.brown.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF4E2D2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: Color(0xFFB85C38),
              size: 27,
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoBuscaVisual() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF0E5DA),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.brown.shade300),
            const SizedBox(width: 12),
            Text(
              'Descubra sua próxima receita...',
              style: TextStyle(
                color: Colors.brown.shade300,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoriasWidget() {
    return SizedBox(
      height: 94,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
        scrollDirection: Axis.horizontal,
        itemCount: _categorias.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final categoria = _categorias[index];
          final nome = categoria['nome'] as String;
          final selecionada = _categoriaSelecionada == nome;

          return GestureDetector(
            onTap: () {
              setState(() {
                _categoriaSelecionada = nome;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: BoxDecoration(
                color: selecionada
                    ? const Color(0xFFB85C38)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selecionada
                      ? const Color(0xFFB85C38)
                      : const Color(0xFFF0E5DA),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    categoria['icone'] as IconData,
                    color: selecionada
                        ? Colors.white
                        : const Color(0xFFB85C38),
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    nome == 'TODAS'
                        ? 'Todas'
                        : '${nome[0]}${nome.substring(1).toLowerCase()}',
                    style: TextStyle(
                      color: selecionada
                          ? Colors.white
                          : const Color(0xFF462B20),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tituloSecao() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Receitas para você',
              style: TextStyle(
                color: Color(0xFF462B20),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(
            Icons.auto_awesome,
            color: Colors.orange.shade700,
            size: 19,
          ),
        ],
      ),
    );
  }

  Widget _cardReceita(Receita receita) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => DetalhesReceitaScreen(
                receita: receita,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFF0E5DA),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    receita.img.isNotEmpty
                        ? Image.network(
                            receita.img,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _imagemAlternativa(),
                          )
                        : _imagemAlternativa(),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          receita.tipo,
                          style: const TextStyle(
                            color: Color(0xFF9C4A2D),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receita.nome,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF462B20),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.payments_outlined,
                            size: 15,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'R\$ ${receita.custoAproximado.toStringAsFixed(2).replaceAll('.', ',')}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagemAlternativa() {
    return Container(
      color: const Color(0xFFF4E2D2),
      child: const Center(
        child: Icon(
          Icons.restaurant,
          color: Color(0xFFB85C38),
          size: 42,
        ),
      ),
    );
  }

  Widget _mensagemErro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: Color(0xFFB85C38),
            ),
            const SizedBox(height: 14),
            const Text(
              'Não conseguimos carregar as receitas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF462B20),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Confira sua conexão e tente novamente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.brown.shade400,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _recarregar,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navegacaoInferior() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFB85C38),
      unselectedItemColor: Colors.brown.shade300,
      onTap: (index) {
        if (index == 2) {
          _abrirCadastro();
        } else if (index != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Essa funcionalidade será adicionada em breve.',
              ),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favoritas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Cadastrar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }
}
