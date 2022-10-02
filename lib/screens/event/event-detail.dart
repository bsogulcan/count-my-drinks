import 'package:confetti/confetti.dart';
import 'package:count_my_drinks/model/event.dart';
import 'package:count_my_drinks/model/guest.dart';
import 'package:count_my_drinks/model/order.dart';
import 'package:count_my_drinks/my_flutter_app_icons.dart';
import 'package:count_my_drinks/screens/guest/create-guest.dart';
import 'package:count_my_drinks/screens/order/create-order.dart';
import 'package:count_my_drinks/services/event-service.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.event});

  final Event event;

  @override
  State<StatefulWidget> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  EventService eventService = new EventService();
  ConfettiController _controllerTopCenter =
      ConfettiController(duration: const Duration(seconds: 4));

  void deleteEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Removing"),
          content: Text("Would you like to remove event?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Continue"),
              onPressed: () {
                Navigator.pop(context);
                deleteEvent();
              },
            ),
          ],
        );
      },
    );
  }

  deleteEvent() {
    eventService.Delete(widget.event.id);
    Navigator.pop(context);
  }

  createGuest(String name) {
    setState(() {
      if (!name.isEmpty) {
        eventService.AddGuest(widget.event.id, name);
        widget.event.guests.add(new Guest(name));
      }
    });
  }

  addOrderToGuest(Guest guest, Order? order) {
    if (order != null) {
      setState(() {
        guest.orders.add(order);
        eventService.AddOrderToGuest(widget.event.id, guest, order);
        _controllerTopCenter.play();
      });
    }
  }

  removeGuest(Guest guest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Removing"),
          content: Text("Would you like to remove guest?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Continue"),
              onPressed: () async {
                Navigator.pop(context);
                eventService.RemoveGuest(widget.event.id, guest.name);
                setState(() {
                  var guestIndex = widget.event.guests
                      .indexWhere((element) => element.name == guest.name);
                  widget.event.guests.removeAt(guestIndex);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.event.place.toUpperCase()),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Add Photo')),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add Guest'),
                    onTap: () async {
                      Navigator.pop(context);

                      String? guestName = await showModalBottomSheet<String>(
                        context: context,
                        builder: (context) => CreateGuestScreen(),
                      );
                      if (guestName != null) {
                        createGuest(guestName.toString());
                      }
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.delete_forever),
                    title: Text('Delete Event'),
                    onTap: () {
                      Navigator.pop(context);
                      deleteEventDialog();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
            child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: widget.event.guests.length,
            itemBuilder: (context, position) {
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _controllerTopCenter,
                        blastDirection: 3 / 2,
                        maxBlastForce: 5, // set a lower max blast force
                        minBlastForce: 2, // set a lower min blast force
                        emissionFrequency: 0.05,
                        numberOfParticles: 50, // a lot of particles at once
                        gravity: 1,
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                          backgroundColor: const Color(0xff764abc),
                          child: Text(widget.event.guests[position].name
                              .substring(0, 1)
                              .toUpperCase())),
                      title: Text(widget.event.guests[position].name),
                      onLongPress: () =>
                          removeGuest(widget.event.guests[position]),
                      trailing: GestureDetector(
                        child: Icon(CustomIcons.beer),
                        onTap: () async {
                          var order = await showModalBottomSheet<Order>(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => Container(
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: CreateOrderScreen(),
                            ),
                          );

                          addOrderToGuest(widget.event.guests[position], order);
                        },
                      ),
                    ),
                    widget.event.guests[position].orders.length > 0
                        ? Text("Orders")
                        : Center(
                            child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Order a beer to get drunk ♥️"),
                          )),
                    widget.event.guests[position].orders.length > 0
                        ? Column(
                            children: [
                              Divider(),
                              ListView.builder(
                                shrinkWrap: true, // use this
                                itemCount:
                                    widget.event.guests[position].orders.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(widget
                                        .event.guests[position].orders[index]
                                        .getIcon()),
                                    title: Text(widget.event.guests[position]
                                        .orders[index].name),
                                    trailing: Column(children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(widget.event
                                              .guests[position].orders[index]
                                              .getPrice())),
                                      Text(widget
                                          .event.guests[position].orders[index]
                                          .getTime()),
                                    ]),
                                  );
                                },
                              )
                            ],
                          )
                        : Center(),
                  ],
                ),
              );
            },
          ),
        ])));
  }
}
