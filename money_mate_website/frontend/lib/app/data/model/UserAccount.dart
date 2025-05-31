class UserAccount {
  int id;
  String firebaseUid;
  String name;
  String email;
  double limit;
  String totalSpent;
  DateTime createdAt;
  DateTime updatedAt;

  UserAccount({
    required this.id,
    required this.firebaseUid,
    required this.name,
    required this.email,
    required this.limit,
    required this.totalSpent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
    id: json['id'],
    firebaseUid: json['firebase_uid'],
    name: json['name'],
    email: json['email'],
    limit: double.parse(json['limit'].toString()),
    totalSpent: json['total_spent'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firebase_uid': firebaseUid,
    'name': name,
    'email': email,
    'limit': limit,
    'total_spent': totalSpent,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
