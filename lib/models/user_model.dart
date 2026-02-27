import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserProfile extends HiveObject{
  @HiveField(0)
  String name;

  @HiveField(1)
  double monthlyBudget;

  UserProfile({
    required this.name,
    required this.monthlyBudget,
  });
}