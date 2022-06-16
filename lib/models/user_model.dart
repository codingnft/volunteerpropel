import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.dateJoined});

  String uid;
  String name;
  String email;
  Timestamp dateJoined;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        dateJoined: json["dateJoined"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "dateJoined": dateJoined,
      };
}
