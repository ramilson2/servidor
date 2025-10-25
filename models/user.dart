class User {
  int? id;
  String name;
  String email;
  //int idade;
 // String profissao;

  User({
    this.id,
    required this.name,
    required this.email,
    //required this.idade,
    //required this.profissao,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      //idade: json['idade'],
      //profissao: json['profissao'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        //'idade': idade,
        //'profissao': profissao,
      };
}
