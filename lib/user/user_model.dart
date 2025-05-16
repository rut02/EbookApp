import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    int userId;
    String username;
    String email;
    String password;

    UserModel({
        required this.userId,
        required this.username,
        required this.email,
        required this.password,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userID"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "username": username,
        "email": email,
        "password": password,
    };
}