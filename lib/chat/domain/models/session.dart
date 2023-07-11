class Session {
  final String id;
  final String title;
  final DateTime dateCreated;

  Session({required this.id, required this.title, required this.dateCreated});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      title: json['title'],
      dateCreated: DateTime.parse(json['date_created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date_created': dateCreated.toIso8601String(),
    };
  }
}
