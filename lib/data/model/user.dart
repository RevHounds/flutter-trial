class User{
  String uid;
  String name;
  String password;
  String email;
  String image;

  User(this.name, this.email, this.password, this.image);

  User.fromMap(Map<String, dynamic> map){
    this.uid = map["Id"];
    this.name = map["Name"];
    this.email = map["Email"];
    this.password = map["Password"];
    this.image = map["Image"];
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map["Id"] = this.uid;
    map["Name"] = this.name;
    map["Email"] = this.email;
    map["Password"] = this.password;
    map["Image"] = this.image;
    
    return map;
  }
}