import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'monthly_expense_page.dart';

class YearlySummaryPage extends StatefulWidget {
  const YearlySummaryPage({super.key});

  @override
  State<YearlySummaryPage> createState() => _YearlySummaryPageState();
}

class _YearlySummaryPageState extends State<YearlySummaryPage> {

  final ExpenseController expenseController = Get.find<ExpenseController>();

  final Map<String, String> shortToFull = {
    'Jan':'January',
    'Feb':'February',
    'Mar':'March',
    'Apr':'April',
    'May': 'May',
    'June':'June',
    'July': 'July',
    'Aug':'August',
    'Sep':'September',
    'Oct':'October',
    'Nov':'November',
    'Dec':'December'
  };

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpenseController>(
        builder: (controller) {

          final years = controller.expense
              .map((e)=> e.date.year).toSet().toList()
            ..sort((a,b)=> b.compareTo(a));

          if(years.isEmpty){
            years.add(DateTime.now().year);
          }

          return Scaffold(
            backgroundColor: AllColor.bgColor,
            appBar: AppBar(
              backgroundColor: AllColor.blueColor,
              foregroundColor: AllColor.fontColor,
              title: const Text(
                'Summary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(
                children: years.map((year){
                  final monthTotals = controller.yearMonthTotal(year);
                  return _buildYearSection(year, monthTotals);
                }).toList(),
              ),
            ),
          );
        }
    );
  }

  Widget _buildYearSection(int year, Map<String, double> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              year.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AllColor.fontColor.withOpacity(0.85),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 1.5,
                color: AllColor.fontColor.withOpacity(0.85),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...data.entries.map((e) {
          final short = e.key;
          final monthIndex = _monthIndexFromShort(short);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: InkWell(
              onTap: () {
                Get.to(() => MonthlyExpensePage(
                  year: year,
                  month: monthIndex,
                ));
              },
              borderRadius: BorderRadius.circular(12),
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
                    short,
                    style: TextStyle(
                      color: AllColor.fontColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Text(
                    '${e.value.toStringAsFixed(0)} ৳',
                    style: TextStyle(
                      color: AllColor.fontColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  int _monthIndexFromShort(String s) {
    final keys = ['Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec'];
    return keys.indexOf(s) + 1;
  }
}
