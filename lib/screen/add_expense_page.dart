import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/expense_controller.dart';
import 'package:awexpenses/controller/category_controller.dart';
import 'package:awexpenses/models/expense_model.dart';
import 'package:awexpenses/screen/category_manage_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpensePage extends StatefulWidget {
  final DateTime? initialDate;
  const AddExpensePage({super.key, this.initialDate});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final ExpenseController _expenseController =
  Get.find<ExpenseController>();
  final CategoryController _categoryController =
  Get.find<CategoryController>();

  TextEditingController _titleCtl = TextEditingController();
  TextEditingController _amountCtl = TextEditingController();

  String? _selectedValue;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();

    // ✅ Always default to Food
    _setDefaultCategory();
  }

  /// 🔹 NEW: Ensure dropdown always has valid value
  void _setDefaultCategory() {
    final food = _categoryController.categories.firstWhereOrNull(
            (c) => c.name.toLowerCase() == 'food');

    if (food != null) {
      _selectedValue = food.name;
    } else if (_categoryController.categories.isNotEmpty) {
      _selectedValue = _categoryController.categories.first.name;
    } else {
      _selectedValue = null;
    }
  }

  Future<void> pickDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
    );

    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.bgColor,
      appBar: AppBar(
        foregroundColor: AllColor.fontColor,
        backgroundColor: AllColor.blueColor,
        title: const Text(
          'Add Expense',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 25),
        child: Column(
          children: [
            // 🔹 TITLE
            TextField(
              controller: _titleCtl,
              style: TextStyle(color: AllColor.fontColor),
              cursorColor: AllColor.fontColor,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                    color: AllColor.fontColor.withOpacity(0.7)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: AllColor.fontColor.withOpacity(0.7),
                      width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: AllColor.fontColor, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔹 AMOUNT
            TextField(
              controller: _amountCtl,
              cursorColor: AllColor.fontColor,
              keyboardType: TextInputType.number,
              style: TextStyle(color: AllColor.fontColor),
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(
                    color: AllColor.fontColor.withOpacity(0.7)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: AllColor.fontColor.withOpacity(0.7),
                      width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: AllColor.fontColor, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔹 CATEGORY DROPDOWN (🔥 GUARANTEED FIX)
            Obx(() {
              final categories = _categoryController.categories;

              // ✅ Ensure selectedValue is valid
              final validNames = categories.map((e) => e.name).toList();
              if (_selectedValue == null ||
                  !validNames.contains(_selectedValue)) {
                _setDefaultCategory();
              }

              final items = [
                ...categories.map((cat) => DropdownMenuItem<String>(
                  value: cat.name,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 6,
                        backgroundColor: Color(cat.color),
                      ),
                      const SizedBox(width: 8),
                      Text(cat.name,
                          style: TextStyle(
                              color: AllColor.fontColor)),
                    ],
                  ),
                )),
                DropdownMenuItem<String>(
                  value: '__add_more__',
                  child: Text(
                    '+ Add more category',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AllColor.fontColor),
                  ),
                ),
              ];

              return DropdownButtonFormField<String>(
                value: _selectedValue,
                iconEnabledColor: AllColor.fontColor,
                dropdownColor: AllColor.bgColor,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(
                      color: AllColor.fontColor.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color:
                        AllColor.fontColor.withOpacity(0.7),
                        width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    BorderSide(color: AllColor.fontColor, width: 1.5),
                  ),
                ),
                items: items,
                isExpanded: true,
                onChanged: (value) async {
                  if (value == '__add_more__') {
                    // 🔹 Go to manage page
                    await Get.to(() => const CategoryManagePage());

                    // ✅ HARD RESET after return
                    setState(() {
                      _setDefaultCategory();
                    });
                  } else {
                    setState(() {
                      _selectedValue = value;
                    });
                  }
                },
              );
            }),

            const SizedBox(height: 25),

            // 🔹 DATE PICKER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDate.day} ${_expenseController.monthName(selectedDate.month)} ${selectedDate.year}',
                  style: TextStyle(
                      fontSize: 18,
                      color:
                      AllColor.fontColor.withOpacity(0.8)),
                ),
                ElevatedButton(
                  onPressed: pickDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AllColor.fontColor.withOpacity(0.4),
                  ),
                  child: Text(
                    'Select Date',
                    style: TextStyle(
                        fontSize: 18,
                        color: AllColor.fontColor.withOpacity(0.8)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 🔹 SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount =
                      double.tryParse(_amountCtl.text) ?? 0;

                  if (_selectedValue == null ||
                      _titleCtl.text.isEmpty ||
                      amount <= 0) {
                    Get.snackbar('Error',
                        'Please fill all fields correctly',
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                    return;
                  }

                  final expense = Expense(
                    title: _titleCtl.text,
                    amount: amount,
                    category: _selectedValue!,
                    date: selectedDate,
                  );

                  _expenseController.addExpense(expense);
                  _expenseController.update();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AllColor.blueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                      fontSize: 22,
                      color: AllColor.fontColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
