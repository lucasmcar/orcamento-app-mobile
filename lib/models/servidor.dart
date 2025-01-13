class Servidor {
  String? id;
  String? url;
  String? rotaCliente;
  String? rotaVeiculo;
  String? rotaServico;

  Servidor(
      {this.id,
        required this.url,
        required this.rotaCliente,
        required this.rotaVeiculo,
        required this.rotaServico});

  Servidor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['nome'];
    rotaCliente = json['email'];
    rotaVeiculo = json['telefone'];
    rotaServico = json['endereco'];
  }

  factory Servidor.fromMap(Map<String, dynamic> data) {
    return Servidor(
      id: data['id'],
      url: data['nome'],
      rotaCliente: data['email'],
      rotaVeiculo: data['telefone'],
      rotaServico: data['endereco'],
    );
  }
}
