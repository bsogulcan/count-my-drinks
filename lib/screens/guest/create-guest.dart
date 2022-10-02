import 'package:flutter/material.dart';

class CreateGuestScreen extends StatefulWidget {
  const CreateGuestScreen({super.key});

  @override
  State<CreateGuestScreen> createState() => _CreateGuestScreenState();
}

class _CreateGuestScreenState extends State<CreateGuestScreen> {
  TextEditingController txtGuest = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("New Guest"), automaticallyImplyLeading: false),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          TextFormField(
            controller: txtGuest,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Name',
              contentPadding: EdgeInsets.all(10),
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: () => {Navigator.pop(context, txtGuest.text)},
              ),
            ),
          )
        ],
      ),
    );
  }
}
