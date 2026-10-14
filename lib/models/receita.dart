
class Receita {
  final int? id;
  final String nome;
  final String tipo;
  final String ingredientes;
  final String modoFazer;
  final String img;
  final double custoAproximado;

  Receita({
    this.id,
    required this.nome,
    required this.tipo,
    required this.ingredientes,
    required this.modoFazer,
    required this.img,
    required this.custoAproximado,
  });

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: json['id'] == null
          ? null
          : int.tryParse(json['id'].toString()),
      nome: json['nome']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? 'SALGADA',
      ingredientes: json['ingredientes']?.toString() ?? '',
      modoFazer: json['modoFazer']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      custoAproximado:
          double.tryParse(json['custoAproximado'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipo': tipo,
      'ingredientes': ingredientes,
      'modoFazer': modoFazer,
      'img': img,
      'custoAproximado': custoAproximado,
    };
  }
}
