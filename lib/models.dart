class Reminder {
  String title;
  DateTime dateTime;

  Reminder({required this.title, required this.dateTime});

  Map<String, dynamic> toJson() => {
        'title': title,
        'dateTime': dateTime.toIso8601String(),
      };

  static Reminder fromJson(Map<String, dynamic> json) => Reminder(
        title: json['title'],
        dateTime: DateTime.parse(json['dateTime']),
      );
}
