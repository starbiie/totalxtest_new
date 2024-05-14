//usermodel.dart
class UserModel {
  String userid;
  String name;
  String age; // Change type to int
  String imageUrl;

  UserModel({
    required this.userid,
    required this.name,
    required this.age,
    required this.imageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userid: map['userid'],
      name: map['name'],
      age: map['age'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'age': age,
      'imageUrl': imageUrl,
    };
  }
}
