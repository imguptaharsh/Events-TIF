import 'package:events/data/events.dart';
import 'package:events/components/EventPage.dart';
import 'package:events/custom%20widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class EventBox extends StatelessWidget {
  const EventBox({
    super.key,
    required this.events,
  });

  final Future<List<Event>> events;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder<List<Event>>(
        future: events,
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
              itemCount: eventList.length,
              itemBuilder: (context, index) {
                final event = eventList[index];
                final imageUrl = event.organiserIcon;
                final formattedDate = DateFormat('d\'st\' MMM - E - h:mm a')
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
                                width: 95,
                                height: 95,
                              ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: kPrimaryColor,
                                  ),
                                ),
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
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const SVGIcon(
                                        icon: "assets/small_location.svg"),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${event.venueName} • ${event.venueCity} • ${event.venueCountry}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
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
    );
  }
}
