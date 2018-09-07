class User{
  String uid;
  String name;
  String password;
  String email;

  User(this.uid, this.name, this.email, this.password);

  User.fromMap(Map<String, dynamic> map){
    this.uid = map["id"];
    this.name = map["name"];
    this.email = map["email"];
    this.password = map["password"];
  }
}