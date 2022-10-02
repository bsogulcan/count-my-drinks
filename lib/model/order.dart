import 'dart:ffi';

import 'package:count_my_drinks/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Order {
  String id = Uuid().v1();
  OrderType orderType = OrderType.beer;
  late String name;
  late double price;
  late DateTime dateTime;

  Order();

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        orderType = OrderType.values.byName(json['orderType']),
        name = json['name'],
        price = json['price'],
        dateTime = DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderType': orderType.name,
      'name': name,
      'price': price,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  getTime() {
    return dateTime.hour.toString() + ':' + dateTime.minute.toString();
  }

  getIcon() {
    switch (orderType) {
      case OrderType.beer:
        return CustomIcons.beer;
        break;
      case OrderType.alcohol:
        return CustomIcons.wine_glass_alt;
        break;
      case OrderType.coffee:
        return CustomIcons.coffee;
        break;
      case OrderType.meal:
        return Icons.local_pizza;
    }
  }

  getPrice() {
    return '₺' + price.toInt().toString();
  }
}

enum OrderType { meal, coffee, beer, alcohol }
