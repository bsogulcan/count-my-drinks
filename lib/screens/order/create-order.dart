import 'dart:ffi';

import 'package:count_my_drinks/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/order.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  var order = new Order();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtCost = TextEditingController();

  orderTypeChanged(OrderType? type) {
    if (type != null) {
      setState(() {
        order.orderType = type;
      });
    }
  }

  completeOrder() {
    setState(() {
      order.name = txtName.text;
      order.price = double.parse(txtCost.text);
      order.dateTime = DateTime.now();
      Navigator.pop(context, order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("New Order"), automaticallyImplyLeading: false),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: DropdownButton(
              hint: Text('Category'),
              value: order.orderType,
              onChanged: (value) => {orderTypeChanged(value)},
              isExpanded: true,
              items: [
                DropdownMenuItem<OrderType>(
                  value: OrderType.beer,
                  child: Row(
                    children: [
                      Icon(CustomIcons.beer),
                      Padding(padding: EdgeInsets.all(10), child: Text('Beer'))
                    ],
                  ),
                ),
                DropdownMenuItem<OrderType>(
                  value: OrderType.alcohol,
                  child: Row(
                    children: [
                      Icon(CustomIcons.wine_glass_alt),
                      Padding(
                          padding: EdgeInsets.all(10), child: Text('Alcohol'))
                    ],
                  ),
                ),
                DropdownMenuItem<OrderType>(
                  value: OrderType.meal,
                  child: Row(
                    children: [
                      Icon(Icons.local_pizza),
                      Padding(padding: EdgeInsets.all(10), child: Text('Meal'))
                    ],
                  ),
                ),
                DropdownMenuItem<OrderType>(
                  value: OrderType.coffee,
                  child: Row(
                    children: [
                      Icon(CustomIcons.coffee),
                      Padding(
                          padding: EdgeInsets.all(10), child: Text('Coffee'))
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: TextField(
                    controller: txtName,
                    decoration: const InputDecoration(helperText: "Order Name"),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: TextField(
                    controller: txtCost,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(helperText: "Cost"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => completeOrder(),
        tooltip: 'Increment',
        child: const Icon(Icons.check),
      ),
    );
  }
}
