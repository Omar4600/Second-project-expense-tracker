import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/expense_controller.dart';
import 'package:awexpenses/screen/add_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyExpense extends StatefulWidget {
  final DateTime? selectedDate;
  final int? year;
  final int? month;

  const DailyExpense({super.key, this.selectedDate, this.year, this.month});

  @override
  State<DailyExpense> createState() => _DailyExpenseState();
}

class _DailyExpenseState extends State<DailyExpense> {
  late ExpenseController _expenseController;

  @override
  void initState() {
    super.initState();
    _expenseController = Get.find<ExpenseController>(); // FIX ✔
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedDate != null) {
      final date = widget.selectedDate!;

      return GetBuilder(
        init: _expenseController,
        builder: (_) {
          final todatList = _expenseController.dailyExpense(date);
          return Scaffold(
              backgroundColor: AllColor.bgColor,
              appBar: AppBar(
                foregroundColor: AllColor.fontColor,
                title: Text('${date.day} ${_expenseController.monthName(date.month)} ${date.year}',
                  style: TextStyle(fontSize: 26, color: AllColor.fontColor, fontWeight: FontWeight.bold),),
                backgroundColor: AllColor.blueColor,
                actions: [
                  IconButton(
                    icon: Icon(Icons.add, color: AllColor.fontColor),
                    onPressed: () {
                      Get.to(() => AddExpensePage(initialDate: date));
                    },
                  )
                ],
              ),
              body: todatList.isEmpty ? Center(
                child:  Text('No expenses for this day', style: TextStyle(color: AllColor.fontColor)),
              )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      itemCount: todatList.length,
                      itemBuilder: (_, index){
                        final e = todatList[index];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: AllColor.blueColor.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AllColor.blueColor.withOpacity(0.5),
                            ),
                          ),
                          child: ListTile(
                            title: Text(e.title, style: TextStyle(color: AllColor.fontColor, fontWeight: FontWeight.w600)),
                            subtitle: Text('${e.category} • ${e.date.day}-${e.date.month}-${e.date.year}',
                                style: TextStyle(color: AllColor.fontColor)
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('৳${e.amount.toStringAsFixed(2)}', style: TextStyle(color: AllColor.fontColor, fontSize: 15)),
                                // SizedBox(width: 8),
                                // InkWell(
                                //   onTap: () {
                                //     final keys = _expenseController.box.keys.toList();
                                //     final hiveKey = keys[index];
                                //
                                //     Get.to(EditExpensePage(
                                //       expense: e,
                                //       hiveKey: hiveKey,
                                //     ));
                                //   },
                                //   child: Icon(Icons.edit, color: AllColor.purpleColor),
                                // ),
                                SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: 'Delete',
                                      middleText: 'Are you sure?',
                                      onConfirm: () {
                                        _expenseController.deleteExpense(e);
                                        _expenseController.update(); // Update controller state
                                        Get.back();
                                      },
                                      onCancel: () {},
                                    );
                                  },

                                  child: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                  ),
          );
        }
      );
    }

    final y = widget.year ?? DateTime.now().year;
    final m = widget.month ?? DateTime.now().month;

    return GetBuilder(

      builder: (_) {

        final monthList = _expenseController.monthlyExpense(DateTime(y,m));

        final Map<int, List> byDay = {};
        for (var e in monthList) {
          byDay[e.date.day] = (byDay[e.date.day] ?? [])..add(e);
        }
        final sortedDays = byDay.keys.toList()..sort((a,b) => b.compareTo(a));

        return Scaffold(
          backgroundColor: AllColor.bgColor,
          appBar: AppBar(
            backgroundColor: AllColor.blueColor,
            foregroundColor: AllColor.fontColor,
            title: Text('${_expenseController.monthName(m)} $y',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: AllColor.fontColor),
                onPressed: (){
                  Get.to(() => AddExpensePage(initialDate: DateTime(y, m, DateTime.now().day)));
                },
              )
            ],
          ),
          body: sortedDays.isEmpty ? Center(
            child: Text('No expenses in this month', style: TextStyle(color: AllColor.fontColor)),
          )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 12),
              itemCount: sortedDays.length,
              itemBuilder: (_, idx) {
                final day = sortedDays[idx];
                final list = byDay[day]!;
                final sum = list.fold<double>(0, (p, e) => p + e.amount);
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: InkWell(
                    onTap: (){
                      Get.to(() => DailyExpense(selectedDate: DateTime(y, m, day)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AllColor.blueColor.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AllColor.blueColor.withOpacity(0.5)),
                      ),
                      child: ListTile(
                        title: Text('$day ${_expenseController.monthName(m)}',
                          style: TextStyle(color: AllColor.fontColor, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${list.length} item(s)', style: TextStyle(color: Colors.grey),),
                        trailing: Text('${sum.toStringAsFixed(2)} ৳', style: TextStyle(color: AllColor.fontColor),),
                      ),
                    ),
                  ),
                );
              }
          ),
        );
      }
    );
  }
}
