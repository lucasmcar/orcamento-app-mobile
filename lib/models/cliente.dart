class Cliente {
  String? id;
  String? nome;
  String? email;
  String? telefone;
  String? endereco;

  Cliente(
      {this.id,
      required this.nome,
      required this.email,
      required this.telefone,
      required this.endereco});

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    telefone = json['telefone'];
    endereco = json['endereco'];
  }

  factory Cliente.fromMap(Map<String, dynamic> data) {
    return Cliente(
      id: data['id'],
      nome: data['nome'],
      email: data['email'],
      telefone: data['telefone'],
      endereco: data['endereco'],
    );
  }
}
