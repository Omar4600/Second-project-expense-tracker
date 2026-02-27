import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/expense_controller.dart'; // ✅ NEW
import 'package:awexpenses/screen/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthlyStatisticsListPage extends StatelessWidget {
  const MonthlyStatisticsListPage({super.key});

  // Full month names
  final List<String> fullMonths = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ExpenseController>( // ✅ NEW: Controller watch করা
      builder: (controller) {
        // ✅ NEW: Available years বের করলাম expense list থেকে
        final years = controller.expense
            .map((e) => e.date.year)
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

        if (years.isEmpty) {
          years.add(DateTime.now().year);
        }

        return Scaffold(
          backgroundColor: AllColor.bgColor,
          appBar: AppBar(
            backgroundColor: AllColor.blueColor,
            foregroundColor: AllColor.fontColor,
            title: const Text(
              'Monthly Statistics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ListView(
              children: years.map((year) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Year Heading
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

                    // 🔹 Month list under each year
                    ...fullMonths.asMap().entries.map((entry) {
                      final monthIndex = entry.key + 1;
                      final monthName = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: InkWell(
                          onTap: () {
                            // ✅ CHANGED: Click করলে ওই বছর+মাসের StatisticsPage এ যাবে
                            Get.to(() => StatisticsPage(
                              selectedMonth: DateTime(year, monthIndex),
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
                                monthName,
                                style: TextStyle(
                                  color: AllColor.fontColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
