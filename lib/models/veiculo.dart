class Veiculo {
  String? id;
  String? modelo;
  String? marca;
  String? cor;
  String? placa;
  String? ano;

  Veiculo(

      {this.id,
      required this.modelo,
      required this.marca,
      required this.cor,
      required this.placa,
      required this.ano});

  Veiculo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelo = json['modelo'];
    marca = json['marca'];
    ano = json['ano'];
    cor = json['cor'];
    placa = json['placa'];
  }

  factory Veiculo.fromMap(Map<String, dynamic> data) {
    return Veiculo(
      id: data['id'],
      modelo: data['modelo'],
      marca: data['marca'],
      ano: data['ano'],
      cor: data['cor'],
      placa: data['placa'],
    );
  }
}
