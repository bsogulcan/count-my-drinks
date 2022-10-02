import 'package:count_my_drinks/model/order.dart';

class Guest {
  String name;
  List<Order> orders = new List.empty(growable: true);

  Guest(this.name);

  Guest.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        orders = List.from(
            json['orders'].map((val) => Order.fromJson(val)).toList());

  Map<String, dynamic> toJson() {
    return {'name': name, 'orders': orders};
  }
}
