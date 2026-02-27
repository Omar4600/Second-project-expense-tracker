import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject{
  @HiveField(0)
  double amount;

  @HiveField(1)
  String category;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String title;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  Expense({
    required this.amount,
    required this.category,
    required this.date,
    this.title='',
    DateTime? createdAt,
    DateTime? updatedAt
  }) : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}