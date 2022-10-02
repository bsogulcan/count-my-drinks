import 'package:count_my_drinks/screens/event/create-event.dart';
import 'package:count_my_drinks/screens/event/event-detail.dart';
import 'package:flutter/material.dart';
import 'screens/event/event-list.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Count My Drinks',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Main(title: 'Events'),
        '/new-event': (context) => const CreateEventScreen(),
        //'/event-detail': (context) => const EventDetailScreen(),
      },
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key, required this.title});

  final String title;

  @override
  State<Main> createState() => EventListPageState();
}
