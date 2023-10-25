class User {
  static const String collectionName = 'users';
  String? id;
  String? email;
  String? name;

  User({this.id, this.email, this.name});

  Map<String, dynamic> toFireStore() {
    return {'id': id, 'email': email, 'name': name};
  }

  User.fromFireStore(Map<String, dynamic>? data) {
    id = data?['id'];
    email = data?['email'];
    name = data?['name'];
  }
}
