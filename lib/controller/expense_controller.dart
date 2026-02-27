// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
//
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'category_controller.dart';
//
// import '../models/expense_model.dart';
//
// class ExpenseController extends GetxController {
//   var expense = <Expense>[].obs;
//   late Box<Expense> box;
//
//   @override
//   void onInit() {
//     box = Hive.box<Expense>('expense'); // Safe Hive box access
//     loadExpense();
//     super.onInit();
//   }
//
//
//   final CategoryController categoryController = Get.find<CategoryController>();
//
//   Color getColorForCategory(String categoryName) {
//     return categoryController.getColorByName(categoryName);
//   }
//
//   /// ------------------------
//   /// 🔹 BASIC CRUD FUNCTIONS
//   /// ------------------------
//
//   /// Load all expenses from Hive
//   void loadExpense() {
//     expense.assignAll(box.values.toList());
//     update(); // 🔥 UI refresh trigger
//   }
//
//   /// Add new expense
//   Future<void> addExpense(Expense expense) async {
//     await box.add(expense);
//     loadExpense();
//   }
//
//   /// Edit expense
//   Future<void> editExpense(int index, Expense newExpense) async {
//     await box.put(index, newExpense);
//     loadExpense();
//   }
//
//   /// Delete expense (using HiveObject.delete)
//   Future<void> deleteExpense(Expense expenseItem) async {
//     await expenseItem.delete();
//     loadExpense();
//     update();
//   }
//
//   /// ------------------------
//   /// 🔹 DATE FILTER FUNCTIONS
//   /// ------------------------
//
//   /// Daily expenses
//   List<Expense> dailyExpense(DateTime day) {
//     return expense.where((e) =>
//     e.date.year == day.year &&
//         e.date.month == day.month &&
//         e.date.day == day.day).toList();
//   }
//
//   /// Monthly expenses
//   List<Expense> monthlyExpense(DateTime month) {
//     return expense.where((e) =>
//     e.date.year == month.year &&
//         e.date.month == month.month).toList();
//   }
//
//   /// Yearly expenses
//   List<Expense> yearlyExpense(int year) {
//     return expense.where((e) => e.date.year == year).toList();
//   }
//
//   /// ------------------------
//   /// 🔹 TOTAL CALCULATIONS
//   /// ------------------------
//
//   /// Monthly total
//   double monthlyTotal(DateTime month) {
//     return monthlyExpense(month).fold(0.0, (sum, e) => sum + e.amount);
//   }
//
//   /// Yearly total
//   double yearlyTotal(int year) {
//     return yearlyExpense(year).fold(0.0, (sum, e) => sum + e.amount);
//   }
//
//   /// Daily sum
//   double sumDaily(DateTime day) =>
//       dailyExpense(day).fold(0, (p, e) => p + e.amount);
//
//   /// Monthly sum
//   double sumMonthly(int year, int month) =>
//       monthlyExpense(DateTime(year, month)).fold(0, (p, e) => p + e.amount);
//
//   /// Yearly sum
//   double sumYearly(int year) =>
//       yearlyExpense(year).fold(0, (p, e) => p + e.amount);
//
//   /// ------------------------
//   /// 🔹 CATEGORY BASED LOGIC (🔥 NEW / UPDATED)
//   /// ------------------------
//
//   /// 🔥 Category-wise totals for a given month (for Pie Chart)
//   Map<String, double> monthlyCategoryTotal(DateTime month) {
//     Map<String, double> total = {};
//
//     for (var e in monthlyExpense(month)) {
//       total[e.category] = (total[e.category] ?? 0) + e.amount;
//     }
//
//     return total;
//   }
//
//   /// 🔥 Get all expenses of a specific category in a month
//   List<Expense> categoryMonthlyExpenses(DateTime month, String category) {
//     return expense.where((e) =>
//     e.date.year == month.year &&
//         e.date.month == month.month &&
//         e.category == category).toList();
//   }
//
//   /// Category-wise monthly expenses
//   List<Expense> monthlyCategoryExpenses(DateTime month, String category) {
//     return monthlyExpense(month)
//         .where((e) => e.category.toLowerCase() == category.toLowerCase())
//         .toList();
//   }
//
//   /// 🔥 Group category expenses by day (used when clicking pie slice)
//   Map<int, List<Expense>> categoryExpensesByDay(
//       DateTime month, String category) {
//     final Map<int, List<Expense>> grouped = {};
//
//     final filtered = categoryMonthlyExpenses(month, category);
//
//     for (var e in filtered) {
//       final day = e.date.day;
//       if (!grouped.containsKey(day)) {
//         grouped[day] = [];
//       }
//       grouped[day]!.add(e);
//     }
//
//     return grouped;
//   }
//
//   /// ------------------------
//   /// 🔹 YEAR-MONTH SUMMARY
//   /// ------------------------
//
//   /// Year-Month totals (12 months)
//   Map<String, double> yearMonthTotal(int year) {
//     Map<String, double> total = {
//       'Jan': 0,
//       'Feb': 0,
//       'Mar': 0,
//       'Apr': 0,
//       'May': 0,
//       'June': 0,
//       'July': 0,
//       'Aug': 0,
//       'Sep': 0,
//       'Oct': 0,
//       'Nov': 0,
//       'Dec': 0,
//     };
//
//     for (var e in expense) {
//       if (e.date.year == year) {
//         String key = monthName(e.date.month);
//         total[key] = total[key]! + e.amount;
//       }
//     }
//
//     return total;
//   }
//
//   /// ------------------------
//   /// 🔹 HELPER FUNCTIONS
//   /// ------------------------
//
//   /// Convert month index to name
//   String monthName(int m) {
//     const names = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'June',
//       'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return names[m - 1];
//   }
//
//   /// Convert month name to index
//   int monthIndexFromName(String m) {
//     const names = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'June',
//       'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return names.indexOf(m) + 1;
//   }
// }
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'category_controller.dart';
import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  var expense = <Expense>[].obs;
  late Box<Expense> box;

  // ✅ NEW: Category budget storage (month+category based)
  late Box<double> budgetBox; // key = "2026-01-Food", value = budget amount

  @override
  void onInit() {
    box = Hive.box<Expense>('expense'); // Safe Hive box access
    budgetBox = Hive.box<double>('category_budget'); // ✅ NEW
    loadExpense();
    super.onInit();
  }

  final CategoryController categoryController = Get.find<CategoryController>();

  Color getColorForCategory(String categoryName) {
    return categoryController.getColorByName(categoryName);
  }

  /// ------------------------
  /// 🔹 BASIC CRUD FUNCTIONS
  /// ------------------------

  /// Load all expenses from Hive
  void loadExpense() {
    expense.assignAll(box.values.toList());
    update(); // 🔥 UI refresh trigger
  }

  /// Add new expense
  Future<void> addExpense(Expense expense) async {
    await box.add(expense);
    loadExpense();
  }

  /// Edit expense
  Future<void> editExpense(int index, Expense newExpense) async {
    await box.put(index, newExpense);
    loadExpense();
  }

  /// Delete expense (using HiveObject.delete)
  Future<void> deleteExpense(Expense expenseItem) async {
    await expenseItem.delete();
    loadExpense();
    update();
  }

  /// ------------------------
  /// 🔹 DATE FILTER FUNCTIONS
  /// ------------------------

  /// Daily expenses
  List<Expense> dailyExpense(DateTime day) {
    return expense.where((e) =>
    e.date.year == day.year &&
        e.date.month == day.month &&
        e.date.day == day.day).toList();
  }

  /// Monthly expenses
  List<Expense> monthlyExpense(DateTime month) {
    return expense.where((e) =>
    e.date.year == month.year &&
        e.date.month == month.month).toList();
  }

  /// Yearly expenses
  List<Expense> yearlyExpense(int year) {
    return expense.where((e) => e.date.year == year).toList();
  }

  /// ------------------------
  /// 🔹 TOTAL CALCULATIONS
  /// ------------------------

  /// Monthly total
  double monthlyTotal(DateTime month) {
    return monthlyExpense(month).fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Yearly total
  double yearlyTotal(int year) {
    return yearlyExpense(year).fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Daily sum
  double sumDaily(DateTime day) =>
      dailyExpense(day).fold(0, (p, e) => p + e.amount);

  /// Monthly sum
  double sumMonthly(int year, int month) =>
      monthlyExpense(DateTime(year, month)).fold(0, (p, e) => p + e.amount);

  /// Yearly sum
  double sumYearly(int year) =>
      yearlyExpense(year).fold(0, (p, e) => p + e.amount);

  /// ------------------------
  /// 🔹 CATEGORY BASED LOGIC (🔥 EXISTING - UNCHANGED)
  /// ------------------------

  /// 🔥 Category-wise totals for a given month (for Pie Chart)
  Map<String, double> monthlyCategoryTotal(DateTime month) {
    Map<String, double> total = {};

    for (var e in monthlyExpense(month)) {
      total[e.category] = (total[e.category] ?? 0) + e.amount;
    }

    return total;
  }

  /// 🔥 Get all expenses of a specific category in a month
  List<Expense> categoryMonthlyExpenses(DateTime month, String category) {
    return expense.where((e) =>
    e.date.year == month.year &&
        e.date.month == month.month &&
        e.category == category).toList();
  }

  /// Category-wise monthly expenses
  List<Expense> monthlyCategoryExpenses(DateTime month, String category) {
    return monthlyExpense(month)
        .where((e) => e.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// 🔥 Group category expenses by day (used when clicking pie slice)
  Map<int, List<Expense>> categoryExpensesByDay(
      DateTime month, String category) {
    final Map<int, List<Expense>> grouped = {};

    final filtered = categoryMonthlyExpenses(month, category);

    for (var e in filtered) {
      final day = e.date.day;
      if (!grouped.containsKey(day)) {
        grouped[day] = [];
      }
      grouped[day]!.add(e);
    }

    return grouped;
  }

  /// ------------------------
  /// 🔹 YEAR-MONTH SUMMARY
  /// ------------------------

  /// Year-Month totals (12 months)
  Map<String, double> yearMonthTotal(int year) {
    Map<String, double> total = {
      'Jan': 0,
      'Feb': 0,
      'Mar': 0,
      'Apr': 0,
      'May': 0,
      'June': 0,
      'July': 0,
      'Aug': 0,
      'Sep': 0,
      'Oct': 0,
      'Nov': 0,
      'Dec': 0,
    };

    for (var e in expense) {
      if (e.date.year == year) {
        String key = monthName(e.date.month);
        total[key] = total[key]! + e.amount;
      }
    }

    return total;
  }

  /// ------------------------
  /// 🔹 HELPER FUNCTIONS
  /// ------------------------

  /// Convert month index to name
  String monthName(int m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'June',
      'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[m - 1];
  }

  /// Convert month name to index
  int monthIndexFromName(String m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'June',
      'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names.indexOf(m) + 1;
  }

  /// ======================================================
  /// 🔹 🔥🔥🔥 NEW: CATEGORY BUDGET / LIMIT SYSTEM 🔥🔥🔥
  /// ======================================================

  /// 🔹 Generate unique budget key for month+category
  String _budgetKey(DateTime month, String category) {
    return '${month.year}-${month.month}-$category';
  }

  /// 🔹 Set budget for a category in a specific month
  Future<void> setCategoryBudget(
      DateTime month, String category, double amount) async {
    final key = _budgetKey(month, category);
    await budgetBox.put(key, amount);
    update();
  }

  /// 🔹 Get budget for a category in a specific month
  double getCategoryBudget(DateTime month, String category) {
    final key = _budgetKey(month, category);
    return budgetBox.get(key, defaultValue: 0.0) ?? 0.0;
  }

  /// 🔹 Clear budget (set to 0)
  Future<void> clearCategoryBudget(
      DateTime month, String category) async {
    final key = _budgetKey(month, category);
    await budgetBox.put(key, 0.0);
    update();
  }

  /// 🔹 Get total spent for a category in a month
  double getCategoryMonthlySpent(DateTime month, String category) {
    return categoryMonthlyExpenses(month, category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  /// 🔹 Get remaining budget
  double getCategoryRemainingBudget(DateTime month, String category) {
    final budget = getCategoryBudget(month, category);
    final spent = getCategoryMonthlySpent(month, category);
    return budget - spent;
  }

  /// 🔹 Check if 80% of budget crossed (for warning notification)
  bool isCategoryNearBudgetLimit(DateTime month, String category) {
    final budget = getCategoryBudget(month, category);
    if (budget <= 0) return false;

    final spent = getCategoryMonthlySpent(month, category);
    return spent >= (budget * 0.8) && spent < budget;
  }

  /// 🔹 Check if budget exceeded (100%)
  bool isCategoryBudgetExceeded(DateTime month, String category) {
    final budget = getCategoryBudget(month, category);
    if (budget <= 0) return false;

    final spent = getCategoryMonthlySpent(month, category);
    return spent >= budget;
  }
}
