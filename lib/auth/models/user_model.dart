import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserModel {
  String? name;
  String? username;
  String? email;
  String? uid;

  UserModel({
    this.name,
    this.username,
    this.email,
    this.uid,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['uid'] = this.uid;

    return data;
  }

  UserModel.fromFirebaseUser(User user){
    name = user.displayName!;
    email = user.providerData.first.email!;
    username = user.providerData.first.email!.split('@').first;
    uid = user.uid;
  }

}