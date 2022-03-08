class User {
  final String id;
  final String email;
  final String role;
  
  User({required this.id, required this.email, required this.role});

  User.fromJson(String id, Map<String, dynamic> json) : this(
    id: id,
    email: json["email"],
    role: json["role"]
  );

  Map<String, Object?> toJson(){
    return {
      "email" : email,
      "role" : role
    };
  }
}