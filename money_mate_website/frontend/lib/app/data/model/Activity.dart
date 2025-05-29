class Activity {
  int id;
  String firebaseUid;
  String name;
  String description;
  String type;
  String priority;
  int spent;
  DateTime date;
  DateTime createdAt;
  DateTime updatedAt;

  Activity({
    required this.id,
    required this.firebaseUid,
    required this.name,
    required this.description,
    required this.type,
    required this.priority,
    required this.spent,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json['id'],
    firebaseUid: json['firebase_uid'],
    name: json['name'],
    description: json['description'],
    type: json['type'],
    priority: json['priority'],
    spent: json['spent'],
    date: DateTime.parse(json['date']),
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firebase_uid': firebaseUid,
    'name': name,
    'description': description,
    'type': type,
    'priority': priority,
    'spent': spent,
    'date': date.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
