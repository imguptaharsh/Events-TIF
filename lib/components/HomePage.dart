import 'package:events/data/events.dart';
import 'package:events/components/EventBox.dart';
import 'package:events/components/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Event>> events;

  @override
  void initState() {
    super.initState();
    events = fetchEvents();
  }

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse(
        'https://sde-007.api.assignment.theinternetfolks.works/v1/event'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> eventList = jsonData['content']['data'];
      final List<Event> events =
          eventList.map((data) => Event.fromJson(data)).toList();
      return events;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            const Text(
              'Events',
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            const Spacer(),
            GestureDetector(
              child: SizedBox(
                width: 22,
                height: 22,
                child: SvgPicture.asset("assets/search.svg"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(
                      events: events,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: EventBox(events: events),
      ),
    );
  }
}
