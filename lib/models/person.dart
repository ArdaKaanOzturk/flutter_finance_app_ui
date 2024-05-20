import 'dart:ui';
import 'package:flutter/material.dart';

class User{
  final String id;
  final String name;
  final String urlAvatar;
  final String price;
  final String time;

  const User({
    required this.id,
    required this.name,
    required this.urlAvatar,
    required this.price,
    required this.time,
  });
  static User fromJson(json) => User(id: json['id'], name: json['name'], urlAvatar: json['urlAvatar'], price: json['price'], time: json['time']);
}

List<User> users = getUser();

static List<User> getUser(){

  const data = [
    {"id": "1", "name": 'Mona OGarro', "urlAvatar": "https://randomuser.me/api/portraits/men/79.jpg","price": "\$300", "time": "11:27 AM"},
  ];

  return data.map<User>(User.fromJson).toList();

}

