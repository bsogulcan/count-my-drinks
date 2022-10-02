import 'dart:convert';
import 'dart:ffi';

import 'package:count_my_drinks/model/event.dart';
import 'package:count_my_drinks/model/guest.dart';
import 'package:count_my_drinks/services/event-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  DateTime dateTime = DateTime.now();
  List<Guest> guests = [];
  var guestInputVisible = false;
  TextEditingController txtPlace = TextEditingController();
  TextEditingController txtGuest = TextEditingController();

  EventService eventService = new EventService();

  onDateChange(DateTime selectedDateTime) {
    setState(() {
      dateTime = selectedDateTime;
    });
  }

  openAddGuestInput() {
    setState(() {
      guestInputVisible = !guestInputVisible;
    });
  }

  addGuest() {
    setState(() {
      if (txtGuest.text != "") {
        guests.add(new Guest(txtGuest.text));
        txtGuest.text = "";
      }
    });
  }

  saveEvent() {
    Event event = new Event(txtPlace.text, dateTime, guests);
    eventService.add(event);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dateTime.day.toString() +
              "-" +
              dateTime.month.toString() +
              "-" +
              dateTime.year.toString(),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    onDateChange(date);
                  }, currentTime: DateTime.now());
                },
                child: Icon(
                  Icons.date_range,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: txtPlace,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Place',
                  contentPadding: EdgeInsets.all(10)),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              "Guests",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: txtGuest,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Name',
                  contentPadding: EdgeInsets.all(10),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => addGuest(),
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: guests.length,
              itemBuilder: (context, position) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      guests[position].name,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {saveEvent()},
        tooltip: 'Save',
        child: const Icon(Icons.check),
      ),
    );
  }
}
