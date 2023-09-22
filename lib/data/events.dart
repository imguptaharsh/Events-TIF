class Event {
  final int id;
  final String title;
  final String description;
  final String bannerImage;
  final String dateTime;
  final String organiserName;
  final String organiserIcon;
  final String venueName;
  final String venueCity;
  final String venueCountry;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImage,
    required this.dateTime,
    required this.organiserName,
    required this.organiserIcon,
    required this.venueName,
    required this.venueCity,
    required this.venueCountry,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      bannerImage: json['banner_image'],
      dateTime: json['date_time'],
      organiserName: json['organiser_name'],
      organiserIcon: json['organiser_icon'],
      venueName: json['venue_name'],
      venueCity: json['venue_city'],
      venueCountry: json['venue_country'],
    );
  }
}

class EventData {
  final List<Event> data;
  final Meta meta;

  EventData({
    required this.data,
    required this.meta,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> eventList = json['data'];
    final List<Event> events =
        eventList.map((eventData) => Event.fromJson(eventData)).toList();

    return EventData(
      data: events,
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class Meta {
  final int total;

  Meta({
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
    );
  }
}
