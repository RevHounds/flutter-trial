class UserModel{
  String uid;
  String name;
  String password;
  String email;

  UserModel(this.uid, this.name, this.email, this.password);

  UserModel.fromMap(Map<String, dynamic> map){
    this.uid = map["id"];
    this.name = map["name"];
    this.email = map["email"];
    this.password = map["password"];
  }
}