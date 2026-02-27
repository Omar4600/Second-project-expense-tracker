import 'package:awexpenses/const/widget.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import 'dart:math';

class CategoryController extends GetxController {
  final Box<CategoryModel> box = Hive.box<CategoryModel>('categories');

  var categories = <CategoryModel>[].obs;

  //late Box<CategoryModel> box;

  // 🎨 Default color palette
  final List<Color> defaultPalette = [
    AllColor.purpleColor,
    AllColor.blueColor,
    AllColor.yellowColor,
    Color(0xff9d4edd),
    Color(0xff5b8cff),
    Color(0xfff284b6),
    Color(0xff4ddbb2),
    Colors.deepOrangeAccent
  ];

  @override
  void onInit() {
    loadCategories();
    addDefaultCategoriesIfEmpty();
    _resetBudgetsIfNewMonth(); // 👈 NEW
    super.onInit();
  }

  /// 🔹 Load all categories
  void loadCategories() {
    categories.assignAll(box.values.toList());
  }

  /// 🔄 Reset all budgets if month changed
  void _resetBudgetsIfNewMonth() {
    final now = DateTime.now();
    final currentMonth = now.year * 100 + now.month;

    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      if (cat.budgetMonth != currentMonth) {
        final updated = CategoryModel(
          id: cat.id,
          name: cat.name,
          color: cat.color,
          monthlyBudget: 0,
          budgetMonth: currentMonth,
        );
        categories[i] = updated;
        box.putAt(i, updated);
      }
    }
  }

  /// 💰 Set monthly budget
  void setCategoryBudget(int id, double amount) {
    final index = categories.indexWhere((c) => c.id == id);
    if (index != -1) {
      final now = DateTime.now();
      final currentMonth = now.year * 100 + now.month;

      final old = categories[index];
      final updated = CategoryModel(
        id: old.id,
        name: old.name,
        color: old.color,
        monthlyBudget: amount,
        budgetMonth: currentMonth,
      );
      categories[index] = updated;
      box.putAt(index, updated);
    }
  }

  /// 🧹 Clear budget
  void clearCategoryBudget(int id) {
    setCategoryBudget(id, 0);
  }

  /// 🔍 Get budget by category name (current month only)
  double getBudgetByName(String name) {
    final match = categories.firstWhereOrNull(
            (c) => c.name.toLowerCase() == name.toLowerCase());
    return match?.monthlyBudget ?? 0;
  }

  /// 🔥 NEW: Get monthly budget by category name (alias to fix error)
  /// 🔥 Get monthly budget by category name and month
  double getMonthlyBudget(String name, DateTime month) {
    final match = categories.firstWhereOrNull(
          (c) => c.name.toLowerCase() == name.toLowerCase()
          && c.budgetMonth == (month.year * 100 + month.month), // 🔹 Match month
    );
    return match?.monthlyBudget ?? 0;
  }

  /// 🔹 Add default categories (only once)
  void addDefaultCategoriesIfEmpty() {
    final names = categories.map((c) => c.name.toLowerCase()).toList();

    if (!names.contains('transport')) {
      addCategory('Transport', color: AllColor.blueColor.value);
    }

    if (!names.contains('food')) {
      addCategory('Food', color: AllColor.purpleColor.value);
    }
  }

  /// 🔹 Add new category
  void addCategory(String name, {int? color}) {
    final id = DateTime.now().millisecondsSinceEpoch;
    final newColor = color ?? _getUnusedColor().value;

    final category = CategoryModel(
      id: id,
      name: name,
      color: newColor,
      monthlyBudget: 0,
      budgetMonth: 0,
    );

    box.add(category);
    categories.add(category);
  }

  /// 🔹 Update category (name + color)
  void updateCategory(int id, String newName, int newColor) {
    final index = categories.indexWhere((c) => c.id == id);
    if (index != -1) {
      final old = categories[index];

      if (old.name.toLowerCase() == 'food' ||
          old.name.toLowerCase() == 'transport') {
        return;
      }

      final updated = CategoryModel(
        id: id,
        name: newName,
        color: newColor,
        monthlyBudget: old.monthlyBudget, // 👈 preserve budget
        budgetMonth: old.budgetMonth,     // 👈 preserve month
      );
      categories[index] = updated;
      box.putAt(index, updated);
    }
  }

  /// 🔹 Delete category
  void deleteCategory(int id) {
    final index = categories.indexWhere((c) => c.id == id);
    if (index != -1) {
      final cat = categories[index];

      if (cat.name.toLowerCase() == 'food' ||
          cat.name.toLowerCase() == 'transport') {
        return;
      }

      box.deleteAt(index);
      categories.removeAt(index);
    }
  }

  /// 🔹 Get color by category name
  Color getColorByName(String name) {
    final match = categories.firstWhereOrNull(
          (c) => c.name.toLowerCase() == name.toLowerCase(),
    );
    return match != null ? Color(match.color) : Colors.grey;
  }

  /// 🔹 Get unused color automatically
  Color _getUnusedColor() {
    final usedColors = categories.map((c) => c.color).toSet();
    for (var color in defaultPalette) {
      if (!usedColors.contains(color.value)) {
        return color;
      }
    }
    return defaultPalette[Random().nextInt(defaultPalette.length)];
  }
}
