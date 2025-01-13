class Pdf {
  String? id; // ID gerado automaticamente
  String name; // Nome do PDF
  String path; // Caminho do arquivo
  DateTime createdAt; // Data de criação

  Pdf({
    this.id,
    required this.name,
    required this.path,
    required this.createdAt,
  });

  // Converter para um mapa (para o SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Converter de um mapa (do SQLite)
  factory Pdf.fromMap(Map<String, dynamic> map) {
    return Pdf(
      id: map['id'],
      name: map['name'],
      path: map['path'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
