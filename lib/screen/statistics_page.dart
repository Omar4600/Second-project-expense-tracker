import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/expense_controller.dart';
import 'package:awexpenses/controller/category_controller.dart';
import 'package:awexpenses/screen/category_budget_page.dart';
import 'package:awexpenses/screen/category_expense_page.dart';
import 'package:awexpenses/screen/monthly_statistics_list_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatisticsPage extends StatefulWidget {
  final DateTime? selectedMonth;

  const StatisticsPage({super.key, this.selectedMonth});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {

  // ✅ Existing: ExpenseController
  final ExpenseController expenseController = Get.find<ExpenseController>();

  // ✅ NEW: CategoryController (dynamic color + category support)
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {

    // ✅ Existing: selected month logic
    final now = widget.selectedMonth ?? DateTime.now();

    // ✅ Existing: Category-wise totals
    final categoryTotals = expenseController.monthlyCategoryTotal(now);

    // ✅ Existing: Total expense for percentage calculation
    final totalExpense = categoryTotals.values.fold(0.0, (sum, e) => sum + e);

    // 🔥 CHANGED: Pie chart sections now use dynamic category color
    final sections = categoryTotals.entries.map((entry) {
      final percent = (entry.value / totalExpense) * 100;

      return PieChartSectionData(
        value: entry.value,
        color: _getColorForCategory(entry.key), // ✅ CHANGED: dynamic color
        title: '${entry.key}\n${percent.toStringAsFixed(1)}%',
        radius: 90,
        titleStyle: TextStyle(
          color: AllColor.fontColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: AllColor.bgColor,
      appBar: AppBar(
        foregroundColor: AllColor.fontColor,
        backgroundColor: AllColor.blueColor,
        title: const Text(
          'Monthly Statistics',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AllColor.fontColor),
            onSelected: (value) {
              if (value == 'months') {
                Get.to(() => MonthlyStatisticsListPage());
              } else if (value == 'budget') {
                Get.to(() => const CategoryBudgetPage());
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'months',
                child: Text('Monthly Overview'),
              ),
              PopupMenuItem(
                value: 'budget',
                child: Text('Category Budget Manager'),
              ),
            ],
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 8,
                  centerSpaceRadius: 50,
                  sections: sections, // ✅ Already dynamic
                ),
              ),
            ),

            SizedBox(height: 30),

            // 🔥 Category list also uses dynamic color
            Expanded(
              child: ListView(
                children: categoryTotals.entries.map((entry) {
                  return ListTile(
                    onTap: () {
                      Get.to(() => CategoryExpensePage(
                        category: entry.key,
                        month: now,
                      ));
                    },
                    leading: Container(
                      height: 15,
                      width: 30,
                      decoration: BoxDecoration(
                        color: _getColorForCategory(entry.key),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    title: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AllColor.fontColor,
                      ),
                    ),
                    trailing: Text(
                      '৳${entry.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AllColor.fontColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 Now Colors will take from CategoryController
  Color _getColorForCategory(String category) {
    return categoryController.getColorByName(category);
  }
}
