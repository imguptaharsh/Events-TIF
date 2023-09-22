import 'package:events/data/events.dart';
import 'package:events/custom%20widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventPage extends StatelessWidget {
  final Event event;

  EventPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('d MMMM, y').format(DateTime.parse(event.dateTime));
    final subDate =
        DateFormat('EEEE, h:mm a').format(DateTime.parse(event.dateTime));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Event Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 48,
                color: Colors.grey.withOpacity(0.3),
                child: IconButton(
                  icon: const Icon(
                    Icons.bookmark,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Handle bookmark button press
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: EventDetails(date, subDate),
    );
  }

  Column EventDetails(String date, String subDate) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Image.network(
                      event.bannerImage,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 0,
                        child: ListTile(
                          leading: Image.asset(
                            "assets/logo.jpeg",
                            width: 32,
                            height: 32,
                          ),
                          title: Text(' ${event.organiserName}'),
                          subtitle: const Text(' Organizer'),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: ListTile(
                          leading: const SVGIcon(icon: 'assets/date.svg'),
                          title: Text(date),
                          subtitle: Text(subDate),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: ListTile(
                          leading: const SVGIcon(icon: 'assets/location.svg'),
                          title: Text(event.venueName),
                          subtitle: Text(
                            ' ${event.venueCity} • ${event.venueCountry}',
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'About Event',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          event.description,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14), color: kPrimaryColor),
            child: ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(),
                  Text(
                    'BOOK NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  SVGIcon(
                    icon: "assets/forword_arrow.svg",
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
