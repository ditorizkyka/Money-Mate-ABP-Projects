import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String uid;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String email;

  @HiveField(3)
  int? cost;

  @HiveField(4)
  bool? isLoggedin;

  UserModel(
      {required this.uid,
      this.name,
      required this.email,
      this.cost,
      this.isLoggedin});
}
