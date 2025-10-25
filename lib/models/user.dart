class User {
  final int? id;
  final String name;
  final String email;
  final int idade;
  final String profissao;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.idade,
    required this.profissao,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // pode ser null
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      idade: json['idade'] ?? 0,
      profissao: json['profissao'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'email': email,
        'idade': idade,
        'profissao': profissao,
      };
}
