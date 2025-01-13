class Empresa {
  String? id;
  String? nome;
  String? cnpj;
  String? email;
  String? telefone;
  String? endereco;
  String? imagem_path;
  String? cidade;

  Empresa(
      {this.id,
      required this.nome,
      required this.cnpj,
      required this.email,
      required this.telefone,
      required this.endereco,
      required this.cidade,
      this.imagem_path});

  Empresa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cnpj = json['cnpj'];
    email = json['email'];
    telefone = json['telefone'];
    endereco = json['endereco'];
    cidade = json['cidade'];
    imagem_path = json['imagem_path'];
  }

  factory Empresa.fromMap(Map<String, dynamic> data) {
    return Empresa(
      id: data['id'],
      nome: data['nome'],
      cnpj: data['cnpj'],
      email: data['email'],
      telefone: data['telefone'],
      endereco: data['endereco'],
      cidade: data['cidade'],
      imagem_path: data['imagem_path'],
    );
  }
}
