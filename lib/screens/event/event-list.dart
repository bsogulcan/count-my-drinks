import 'package:count_my_drinks/main.dart';
import 'package:count_my_drinks/model/event.dart';
import 'package:count_my_drinks/screens/event/create-event.dart';
import 'package:count_my_drinks/screens/event/event-detail.dart';
import 'package:count_my_drinks/services/event-service.dart';
import 'package:flutter/material.dart';

class EventListPageState extends State<Main> {
  EventService eventService = EventService();
  List<Event> events = [];

  EventListPageState() {
    getEvents();
  }

  getEvents() {
    eventService.GetAll().then((val) => setState(() {
          events = val;
        }));
  }

  Future<void> _navigateAndDisplaySelection() async {
    //Navigator.pushNamed(context, '/new-event');
    //eventService.RemoveAll();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateEventScreen()),
    );

    if (!mounted) return;

    getEvents();
  }

  Future<void> _navigateEventDetail(Event event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    );

    if (!mounted) return;

    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, position) {
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                      backgroundColor: const Color(0xff764abc),
                      child: Text(events[position]
                          .place
                          .substring(0, 1)
                          .toUpperCase())),
                  trailing: Text(events[position].getGuestIcon()),
                  title: Text(events[position].place.toUpperCase()),
                  subtitle: Text(events[position].getOnlyDate()),
                  onTap: () => _navigateEventDetail(events[position]),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndDisplaySelection(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
