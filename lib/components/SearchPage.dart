import 'dart:convert';

import 'package:events/data/events.dart';
import 'package:events/components/EventPage.dart';
import 'package:events/custom%20widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.events}) : super(key: key);
  final Future<List<Event>> events;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Event>> eventsData;
  List<Event> filteredItems = [];

  @override
  void initState() {
    super.initState();
    eventsData = widget.events;
  }

  Future<List<Event>> fetchEvents(String query) async {
    final response = await http.get(Uri.parse(
        'https://sde-007.api.assignment.theinternetfolks.works/v1/event?search=$query'));

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

  Future<void> filterItems(String query) async {
    try {
      final events = await fetchEvents(query);
      setState(() {
        filteredItems = events;
      });
    } catch (error) {
      setState(() {
        filteredItems = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 25.0,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Search',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterItems,
              decoration: InputDecoration(
                hintText: 'Type Event Name',
                hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
                prefixIcon: SizedBox(
                  child: SvgPicture.asset("assets/search.svg",
                      color: kPrimaryColor),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<Event>>(
                future: eventsData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No events available'),
                    );
                  } else {
                    final eventList = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredItems.isEmpty
                          ? eventList.length
                          : filteredItems.length,
                      itemBuilder: (context, index) {
                        final event = filteredItems.isEmpty
                            ? eventList[index]
                            : filteredItems[index];
                        final imageUrl = event.organiserIcon;

                        final formattedDate =
                            DateFormat('d\'st\' MMM - E - h:mm a')
                                .format((DateTime.parse(event.dateTime)));

                        bool isSvg = imageUrl.toLowerCase().endsWith('.svg');
                        return GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventPage(
                                          event: event,
                                        )))
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isSvg
                                    ? SvgPicture.network(
                                        imageUrl,
                                        width: 100,
                                        height: 100,
                                      )
                                    : Image.network(
                                        imageUrl,
                                        width: 100,
                                        height: 100,
                                      ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(formattedDate,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                              color: kPrimaryColor,
                                            )),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          event.organiserName,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          event.title,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
