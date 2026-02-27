import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/category_controller.dart';
import 'package:awexpenses/controller/expense_controller.dart';
import 'package:awexpenses/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryExpensePage extends StatelessWidget {
  final String category;
  final DateTime month;

  const CategoryExpensePage({
    super.key,
    required this.category,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final ExpenseController expenseController = Get.find<ExpenseController>();
    final CategoryController categoryController =
    Get.find<CategoryController>();

    // 🔹 Category-wise list (UNCHANGED)
    final List<Expense> list =
    expenseController.monthlyCategoryExpenses(month, category);

    // 🔹 Category-wise total (UNCHANGED)
    final double categoryTotal =
        expenseController.monthlyCategoryTotal(month)[category] ?? 0.0;

    // 🔹 NEW: Get category budget for this month
    final double categoryBudget =
    categoryController.getMonthlyBudget(category, month);

    // 🔹 NEW: Remaining calculation
    final double remaining = categoryBudget > 0
        ? (categoryBudget - categoryTotal)
        : 0.0;

    // 🔹 Date অনুযায়ী group করা (UNCHANGED)
    final Map<DateTime, List<Expense>> byDay = {};

    for (var e in list) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      byDay.putIfAbsent(day, () => []).add(e);
    }

    // 🔹 Date গুলো sort করা (latest first) (UNCHANGED)
    final sortedDays = byDay.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: AllColor.bgColor,
      appBar: AppBar(
        backgroundColor: AllColor.blueColor,
        foregroundColor: AllColor.fontColor,
        title: Text(
          '$category Expenses',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: list.isEmpty
          ? Center(
        child: Text(
          'No expenses found!',
          style: TextStyle(color: AllColor.fontColor),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔹 UPDATED: Top summary section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Total (always shown)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total $category:',
                        style: TextStyle(
                          color: AllColor.fontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${categoryTotal.toStringAsFixed(2)} ৳',
                        style: TextStyle(
                          color: AllColor.fontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // 🔹 NEW: Budget & Remaining (only if budget > 0)
                  if (categoryBudget > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Budget / Limit:',
                          style: TextStyle(
                            color: AllColor.fontColor,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${categoryBudget.toStringAsFixed(2)} ৳',
                          style: TextStyle(
                            color: AllColor.fontColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Remaining:',
                          style: TextStyle(
                            color: remaining < 0
                                ? Colors.red
                                : AllColor.fontColor,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${remaining.toStringAsFixed(2)} ৳',
                          style: TextStyle(
                            color: remaining < 0
                                ? Colors.red
                                : AllColor.fontColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Expense List (UNCHANGED)
            Expanded(
              child: ListView.builder(
                itemCount: sortedDays.length,
                itemBuilder: (context, index) {
                  final day = sortedDays[index];
                  final dayList = byDay[day]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...dayList.map((e) {
                        return Card(
                          color: AllColor.blueColor.withOpacity(0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              '${day.day} ${_monthName(day.month)}',
                              style: TextStyle(
                                color: AllColor.fontColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              e.title,
                              style: TextStyle(color: AllColor.fontColor),
                            ),
                            trailing: Text(
                              '৳${e.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AllColor.fontColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Month number → Month name (UNCHANGED)
  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }
}
