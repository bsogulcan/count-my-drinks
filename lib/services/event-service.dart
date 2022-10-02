import 'dart:convert';
import 'dart:ui';
import 'package:count_my_drinks/model/event.dart';
import 'package:count_my_drinks/model/guest.dart';
import 'package:count_my_drinks/model/order.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class EventService {
  final LocalStorage eventStorage = new LocalStorage('count-my-drinks');

  void add(Event event) async {
    var events = await GetAll();
    events.add(event);
    Save(events);
  }

  void Delete(String id) async {
    var events = await GetAll();
    var index = events.indexWhere((x) => x.id == id);
    events.removeAt(index);
    Save(events);
  }

  AddGuest(String id, String name) async {
    var events = await GetAll();
    var eventIndex = events.indexWhere((x) => x.id == id);
    events[eventIndex].guests.add(new Guest(name));
    Save(events);

    return events[eventIndex].guests;
  }

  RemoveGuest(String id, String name) async {
    var events = await GetAll();
    var eventIndex = events.indexWhere((x) => x.id == id);
    var guestIndex =
        events[eventIndex].guests.indexWhere((element) => element.name == name);

    events[eventIndex].guests.removeAt(guestIndex);
    Save(events);

    return events[eventIndex].guests;
  }

  AddOrderToGuest(String id, Guest guest, Order order) async {
    var events = await GetAll();
    var eventIndex = events.indexWhere((x) => x.id == id);
    var guestIndex = events[eventIndex]
        .guests
        .indexWhere((element) => element.name == guest.name);

    events[eventIndex].guests[guestIndex].orders.add(order);
    Save(events);

    return events[eventIndex].guests;
  }

  void Save(List<Event> events) {
    eventStorage.setItem("events", jsonEncode(events));
  }

  Future<List<Event>> GetAll() async {
    await eventStorage.ready;

    final eventsFromStorage = eventStorage.getItem("events");
    if (eventsFromStorage == null) {
      return new List.empty(growable: true);
    }

    var eventJson = json.decode(eventsFromStorage);
    List<Event> events =
        List<Event>.from(eventJson.map((model) => Event.fromJson(model)));

    events.sort((a, b) {
      return b.dateTime.compareTo(a.dateTime);
    });

    return events;
  }

  RemoveAll() {
    eventStorage.deleteItem("events");
  }

  Initialize() {
    List<Event> events = [];

    for (int i = 0; i < 10; i++) {
      events.add(new Event("Radyo Pub", DateTime.now(), List.empty()));
    }

    eventStorage.setItem("events", jsonEncode(events));
  }
}
