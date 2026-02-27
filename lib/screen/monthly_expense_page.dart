import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/expense_controller.dart';
import 'package:awexpenses/screen/add_expense_page.dart';
import 'package:awexpenses/screen/daily_expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthlyExpensePage extends StatelessWidget {
  final int year;
  final int month;

  const MonthlyExpensePage({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        final ExpenseController expenseController = Get.find<ExpenseController>();
        final monthName = expenseController.monthName(month);
        final monthTotal = expenseController.sumMonthly(year, month);

        final List expense = expenseController.monthlyExpense(DateTime(year, month));
        final Map<int, List> byDay = {};
        for (var e in expense) {
          byDay[e.date.day] = (byDay[e.date.day] ?? [])..add(e);
        }

        final sortedDays = byDay.keys.toList()..sort((a,b) => b.compareTo(a));
        return Scaffold(
          backgroundColor: AllColor.bgColor,
          appBar: AppBar(
            backgroundColor: AllColor.blueColor,
            foregroundColor: AllColor.fontColor,
            title: Text(
              '$monthName $year',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            actions: [
              IconButton(
                  onPressed: (){
                    final initial = DateTime(year, month, DateTime.now().day);
                    Get.to(() => AddExpensePage());
                  },
                  icon: Icon(Icons.add, color: AllColor.fontColor),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Expense:',
                        style: TextStyle(
                          color: AllColor.fontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${monthTotal.toStringAsFixed(0)} ৳',
                        style: TextStyle(
                          color: AllColor.fontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: sortedDays.isEmpty ? Center(
                    child: Text('No expenses in this month',
                        style: TextStyle(color: AllColor.fontColor),
                    ),
                  )
                      : ListView.builder(
                    itemCount: sortedDays.length,
                    itemBuilder: (context, idx) {
                      final day = sortedDays[idx];
                      final dayList = byDay[day]!;
                      final daySum = dayList.fold<double>(0, (p,e) => p + e.amount);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: InkWell(
                          onTap: (){
                            final selectedDate = DateTime(year, month, day);
                            Get.to(() => DailyExpense(selectedDate: selectedDate));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AllColor.blueColor.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AllColor.blueColor.withOpacity(0.5),
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                '$day ${expenseController.monthName(month)}',
                                style: TextStyle(
                                  color: AllColor.fontColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text('${dayList.length} item(s)', style: TextStyle(color: AllColor.fontColor),),
                              trailing: Text(
                                '${daySum.toStringAsFixed(2)} ৳',
                                style: TextStyle(
                                  color: AllColor.fontColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
