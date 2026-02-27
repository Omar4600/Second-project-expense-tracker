import 'dart:math';
import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/category_controller.dart';
import 'package:awexpenses/controller/expense_controller.dart';
import 'package:awexpenses/controller/user_controller.dart';
import 'package:awexpenses/screen/add_expense_page.dart';
import 'package:awexpenses/screen/statistics_page.dart';
import 'package:awexpenses/screen/yearly_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  final DateTime? selectedMonth;

  const HomePage({super.key, this.selectedMonth});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _nameClt = TextEditingController();
  TextEditingController _budgetClt = TextEditingController();

  final expenseController = Get.put(ExpenseController());
  final userController = Get.put(UserController());
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      expenseController.loadExpense();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.find<CategoryController>();
    categoryController.addDefaultCategoriesIfEmpty();

    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    /// Responsive multipliers
    double font(double f) => f * (width/390);
    double h(double val) => val * (height/844);
    double w(double val) => val * (width / 390);


    final now = widget.selectedMonth ?? DateTime.now();
    // ✅ Existing: Category-wise totals
    final categoryTotals = expenseController.monthlyCategoryTotal(now);

    return Scaffold(
      backgroundColor: AllColor.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w(15)),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h(20)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    "Hello, ${userController.name.value}!",
                    style: TextStyle(
                      fontSize: font(26),
                      fontWeight: FontWeight.bold,
                      color: AllColor.fontColor,
                    ),
                  ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  content: TextField(
                                    controller: _nameClt,
                                    showCursor: true,
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Name',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  actions: [
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: CircleAvatar(
                                        child: Icon(Icons.close, color: Colors.redAccent,),
                                        backgroundColor: Colors.grey[50],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        userController.saveUserName(_nameClt.text);
                                        Get.back();
                                      },
                                      child: CircleAvatar(
                                        child: Icon(Icons.check, color: Colors.greenAccent,),
                                        backgroundColor: Colors.grey[50],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    },
                    child: Container(
                      width: w(60),
                      height: w(60),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: AllColor.fontColor),
                        borderRadius: BorderRadius.circular(w(40)),
                        color: AllColor.bgColor,
                      ),
                      child: Icon(
                        Icons.person,
                        color: AllColor.fontColor,
                        size: font(35),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: h(5)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Monthly Statistics',
                  style: TextStyle(
                    color: AllColor.fontColor,
                    fontSize: font(14),
                  ),
                ),
              ),
              //SizedBox(height: h(2)),

              /// 🔥🔥🔥 DYNAMIC PIE CHART STARTS HERE 🔥🔥🔥
              Center(
                child: SizedBox(
                  height: h(230),
                  child: InkWell(
                    onTap: () {
                      Get.to(StatisticsPage());
                    },
                    child: Obx(() {
                      final now = widget.selectedMonth ?? DateTime.now();

                      final categoryTotals =
                      expenseController.monthlyCategoryTotal(now);

                      final totalExpense =
                      categoryTotals.values.fold(0.0, (sum, e) => sum + e);

                      final sections = categoryTotals.entries.map((entry) {
                        final percent = (entry.value / totalExpense) * 100;

                        return PieChartSectionData(
                          value: entry.value,
                          color: _getColorForCategory(entry.key),
                          title: '${entry.key}\n${percent.toStringAsFixed(1)}%',
                          radius: 60,
                          titleStyle: TextStyle(
                            color: AllColor.fontColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();

                      if (sections.isEmpty) {
                        return PieChart(
                          PieChartData(
                            sectionsSpace: 0,          // কোনো gap না
                            centerSpaceRadius: w(50),  // ভিতরের খালি circle
                            sections: [
                              PieChartSectionData(
                                value: 100,
                                color: Colors.grey.shade300, // empty background circle
                                radius: w(40),
                                title: 'Empty',
                                titleStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: font(16),
                                ),
                                showTitle: false,
                              ),
                            ],
                          ),
                        );
                      }

                      return PieChart(
                        PieChartData(
                          sectionsSpace: 8,
                          centerSpaceRadius: 40,
                          sections: sections,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              /// 🔥🔥🔥 DYNAMIC PIE CHART ENDS HERE 🔥🔥🔥

              SizedBox(height: h(40)),
              InkWell(
                onTap: () {
                  Get.to(YearlySummaryPage());
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Transform.rotate(
                        alignment: Alignment.topLeft,
                        angle: -pi / 25,
                        child: Container(
                          width: width * 0.9,
                          height: h(180),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AllColor.purpleColor,
                                AllColor.blueColor
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(w(20)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: w(15),
                                spreadRadius: w(3),
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      // top: 0,
                      // right: 0,
                      // left: 0,
                      child: Container(
                        // width: 50,
                        // height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(w(20)),
                        ),
                        child: Obx(() {
                          final currentMonth = DateTime.now();
                          final spend = expenseController.monthlyTotal(currentMonth);
                          final budget = userController.monthlyBudget.value;
                          final remaining = budget - spend;

                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: h(20), left: w(30), right: w(40)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Remain balance',
                                      style: TextStyle(
                                          color: AllColor.fontColor, fontSize: font(14)),
                                    ),
                                    Text(
                                      '৳${remaining.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color: AllColor.fontColor,
                                        fontSize: font(26),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: h(20)),
                                    Text(
                                      'Spend',
                                      style: TextStyle(
                                          color: AllColor.fontColor, fontSize: font(14)),
                                    ),
                                    Text(
                                      '৳${spend.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color: AllColor.fontColor,
                                        fontSize: font(18),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: SingleChildScrollView(
                                              child: AlertDialog(
                                                content: TextField(
                                                  controller: _budgetClt,
                                                  cursorColor: Colors.grey,
                                                  showCursor: true,
                                                  decoration: InputDecoration(
                                                    hintText: 'Add Budget',
                                                    hintStyle: TextStyle(color: Colors.grey),
                                                  ),
                                                ),
                                                actions: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: CircleAvatar(
                                                      child: Icon(Icons.close, color: Colors.redAccent,),
                                                      backgroundColor: Colors.grey[50],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      double budget = double.tryParse(_budgetClt.text.trim()) ?? 0.0;
                                                      userController.saveUserBudget(budget);
                                                      Get.back();
                                                    },
                                                    child: CircleAvatar(
                                                      child: Icon(Icons.check, color: Colors.greenAccent,),
                                                      backgroundColor: Colors.grey[50],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    );
                                  },
                                  child: Container(
                                    height: h(75),
                                    padding: EdgeInsets.all(w(10)),
                                    constraints: BoxConstraints(
                                      minWidth: 0,   // content অনুযায়ী width shrink করবে
                                    ),

                                    decoration: BoxDecoration(
                                      // Glass morphic soft background
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(w(18)),

                                      // Nice border gradient
                                      border: Border.all(
                                        width: 1.6,
                                        color: Colors.white.withOpacity(0.35),
                                      ),

                                      // beautiful light glow effect
                                      boxShadow: [
                                        BoxShadow(
                                          color: AllColor.blueColor.withOpacity(0.25),
                                          blurRadius: 12,
                                          spreadRadius: 1,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),

                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Budget',
                                            style: TextStyle(
                                                color: AllColor.fontColor, fontSize: font(16)),
                                          ),
                                          Text(
                                            '৳${budget.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              color: AllColor.fontColor,
                                              fontSize: font(18),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h(40)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Daily Expenses',
                      style: TextStyle(
                        fontSize: font(20),
                        fontWeight: FontWeight.bold,
                        color: AllColor.fontColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h(10)),
              Obx(() {
                final todayList = expenseController.dailyExpense(DateTime.now());

                if(todayList.isEmpty){
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No Expenses Today!',
                      style: TextStyle(color: AllColor.fontColor, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: todayList.length,
                  itemBuilder: (_, index) {

                    final e = todayList[index];
                    return ListTile(
                      // leading: CircleAvatar(
                      //   radius: w(22),
                      //   backgroundColor: Colors.grey.withOpacity(0.3),
                      //   child:
                      //   Icon(
                      //     Icons.category,
                      //     color: AllColor.fontColor,
                      //     size: font(20),
                      //   ),
                      // ),
                      title: Text(
                          e.title,
                          style: TextStyle(color: AllColor.fontColor, fontSize: font(16))),
                      subtitle: Text(
                        '${e.category} • ${e.date.day}-${e.date.month}-${e.date.year}',
                        style: TextStyle(color: Colors.grey,fontSize: font(12)),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '৳${e.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AllColor.fontColor,
                              fontSize: font(16),
                            ),
                          ),
                          SizedBox(width: 16),

                          InkWell(
                            onTap: () {
                              Get.defaultDialog(
                                title: 'Delete',
                                middleText: 'Are you sure?',
                                onConfirm: () {
                                  expenseController.deleteExpense(e);
                                  Get.back();
                                },
                                onCancel: () {},
                              );
                            },
                            child: Icon(Icons.delete, color: Colors.red, size: font(18)),
                          ),
                        ],
                      ),

                    );
                  },
                );
              }),
              SizedBox(height: h(40)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddExpensePage());
        },
        child: Icon(Icons.add, size: h(30)),
        backgroundColor: AllColor.fontColor,
        foregroundColor: AllColor.bgColor,
      ),
    );
  }

  Color _getColorForCategory(String category) {
    return categoryController.getColorByName(category);
  }
}
