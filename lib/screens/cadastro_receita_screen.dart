
import 'package:flutter/material.dart';

import '../models/receita.dart';
import '../services/receita_service.dart';

class CadastroReceitaScreen extends StatefulWidget {
  const CadastroReceitaScreen({super.key});

  @override
  State<CadastroReceitaScreen> createState() =>
      _CadastroReceitaScreenState();
}

class _CadastroReceitaScreenState
    extends State<CadastroReceitaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ReceitaService();

  final _nomeController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _modoFazerController = TextEditingController();
  final _imagemController = TextEditingController();
  final _custoController = TextEditingController();

  String _tipoSelecionado = 'SALGADA';
  bool _salvando = false;

  static const Color terracota = Color(0xFFB85C38);
  static const Color marrom = Color(0xFF462B20);

  @override
  void dispose() {
    _nomeController.dispose();
    _ingredientesController.dispose();
    _modoFazerController.dispose();
    _imagemController.dispose();
    _custoController.dispose();
    super.dispose();
  }

  Future<void> _salvarReceita() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final custoTexto =
        _custoController.text.trim().replaceAll(',', '.');

    final custo = double.tryParse(custoTexto);

    if (custo == null || custo < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe um custo válido.'),
        ),
      );
      return;
    }

    setState(() {
      _salvando = true;
    });

    final receita = Receita(
      nome: _nomeController.text.trim(),
      tipo: _tipoSelecionado,
      ingredientes: _ingredientesController.text.trim(),
      modoFazer: _modoFazerController.text.trim(),
      img: _imagemController.text.trim(),
      custoAproximado: custo,
    );

    try {
      await _service.cadastrarReceita(receita);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receita cadastrada com sucesso!'),
          backgroundColor: Color(0xFF39804A),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível cadastrar: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9F2),
        foregroundColor: marrom,
        elevation: 0,
        title: const Text(
          'Nova receita',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
          children: [
            const Text(
              'Compartilhe seu sabor',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: marrom,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Preencha os detalhes para adicionar uma receita ao livro.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.brown.shade400,
              ),
            ),
            const SizedBox(height: 28),

            _rotulo('Nome da receita'),
            const SizedBox(height: 8),
            _campo(
              controller: _nomeController,
              dica: 'Ex.: Bolo de cenoura',
              icone: Icons.restaurant_menu,
            ),

            const SizedBox(height: 20),
            _rotulo('Categoria'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _tipoSelecionado,
              decoration: _decoracao(
                dica: 'Selecione a categoria',
                icone: Icons.category_outlined,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'SALGADA',
                  child: Text('Salgada'),
                ),
                DropdownMenuItem(
                  value: 'DOCE',
                  child: Text('Doce'),
                ),
                DropdownMenuItem(
                  value: 'BEBIDA',
                  child: Text('Bebida'),
                ),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  setState(() {
                    _tipoSelecionado = valor;
                  });
                }
              },
            ),

            const SizedBox(height: 20),
            _rotulo('Ingredientes'),
            const SizedBox(height: 8),
            _campo(
              controller: _ingredientesController,
              dica: 'Digite um ingrediente por linha',
              icone: Icons.shopping_basket_outlined,
              maxLinhas: 5,
            ),

            const SizedBox(height: 20),
            _rotulo('Modo de preparo'),
            const SizedBox(height: 8),
            _campo(
              controller: _modoFazerController,
              dica: 'Descreva o passo a passo da receita',
              icone: Icons.menu_book_outlined,
              maxLinhas: 6,
            ),

            const SizedBox(height: 20),
            _rotulo('URL da imagem'),
            const SizedBox(height: 8),
            _campo(
              controller: _imagemController,
              dica: 'https://exemplo.com/imagem.jpg',
              icone: Icons.image_outlined,
              obrigatorio: false,
              tipoTeclado: TextInputType.url,
            ),

            const SizedBox(height: 20),
            _rotulo('Custo aproximado (R\$)'),
            const SizedBox(height: 8),
            _campo(
              controller: _custoController,
              dica: 'Ex.: 25,50',
              icone: Icons.payments_outlined,
              tipoTeclado: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _salvando ? null : _salvarReceita,
                style: ElevatedButton.styleFrom(
                  backgroundColor: terracota,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.brown.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: _salvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_circle_outline),
                label: Text(
                  _salvando ? 'Salvando...' : 'Salvar receita',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rotulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: marrom,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String dica,
    required IconData icone,
    int maxLinhas = 1,
    bool obrigatorio = true,
    TextInputType tipoTeclado = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipoTeclado,
      minLines: maxLinhas == 1 ? 1 : maxLinhas,
      maxLines: maxLinhas,
      validator: (valor) {
        if (obrigatorio &&
            (valor == null || valor.trim().isEmpty)) {
          return 'Preencha este campo.';
        }

        if (valor != null &&
            valor.trim().isNotEmpty &&
            tipoTeclado == TextInputType.url) {
          final uri = Uri.tryParse(valor.trim());

          if (uri == null ||
              !uri.hasScheme ||
              (uri.scheme != 'http' && uri.scheme != 'https') ||
              uri.host.isEmpty) {
            return 'Informe uma URL válida começando com http:// ou https://.';
          }
        }

        return null;
      },
      decoration: _decoracao(
        dica: dica,
        icone: icone,
      ),
    );
  }

  InputDecoration _decoracao({
    required String dica,
    required IconData icone,
  }) {
    return InputDecoration(
      hintText: dica,
      hintStyle: TextStyle(
        color: Colors.brown.shade300,
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icone,
        color: terracota,
        size: 21,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFF0E5DA),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFF0E5DA),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: terracota,
          width: 1.5,
        ),
      ),
      errorMaxLines: 2,
    );
  }
}
