import 'dart:convert';

import 'package:uuid/uuid.dart';
import '../model/guest.dart';

class Event {
  String id = Uuid().v1();
  String place;
  DateTime dateTime;
  List<Guest> guests;

  Event(this.place, this.dateTime, this.guests);

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        place = json['place'],
        dateTime = DateTime.tryParse(json['dateTime'])!,
        guests = List.from(
            json['guests'].map((val) => Guest.fromJson(val)).toList());

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place': place,
      'dateTime': dateTime.toIso8601String(),
      'guests': guests
    };
  }

  getOnlyDate() {
    return dateTime.day.toString() +
        "-" +
        dateTime.month.toString() +
        "-" +
        dateTime.year.toString();
  }

  getGuestIcon() {
    var guestIcon = "";
    for (var i = 0; i < guests.length; i++) {
      guestIcon += "👨🏻‍🦲";
    }

    return guestIcon;
  }
}
