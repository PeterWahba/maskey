import 'package:flutter/material.dart';

class Car {
  int id;
  String brand;
  String model;
  double price;
  String condition;
  List<String> images;

  Car(
      {required this.id,
      required this.brand,
      required this.model,
      required this.price,
      required this.condition,
      required this.images});
}
