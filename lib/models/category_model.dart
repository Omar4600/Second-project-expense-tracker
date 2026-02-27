import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int color; // store Color.value

  @HiveField(3)
  double monthlyBudget; // 👈 NEW

  @HiveField(4)
  int budgetMonth; // 👈 NEW (YYYYMM)

  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    this.monthlyBudget = 0,
    this.budgetMonth = 0,
  });
}
