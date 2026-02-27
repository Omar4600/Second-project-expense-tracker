import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/expense_controller.dart';
import 'package:awexpenses/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditExpensePage extends StatefulWidget {
  final Expense expense;
  final dynamic hiveKey; // hive key for update

  const EditExpensePage({
    super.key,
    required this.expense,
    required this.hiveKey,
  });

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  final ExpenseController _expenseController = Get.find<ExpenseController>();

  late TextEditingController _titleCtl;
  late TextEditingController _amountCtl;

  String? _selectedValue;
  List<String> listOfValue = ['Food', 'Transport', 'Shopping', 'Others'];

  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _titleCtl = TextEditingController(text: widget.expense.title);
    _amountCtl = TextEditingController(text: widget.expense.amount.toString());
    _selectedValue = widget.expense.category;
    selectedDate = widget.expense.date;
  }

  Future<void> pickDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
    );

    if (newDate != null) {
      setState(() => selectedDate = newDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.bgColor,
      appBar: AppBar(
        foregroundColor: AllColor.fontColor,
        backgroundColor: AllColor.blueColor,
        title: Text(
          'Edit Expense',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 25),
        child: Column(
          children: [
            // ---------------- TITLE ----------------
            TextField(
              controller: _titleCtl,
              style: TextStyle(color: AllColor.fontColor),
              cursorColor: AllColor.fontColor,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: AllColor.fontColor.withOpacity(0.7)),

                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AllColor.fontColor.withOpacity(0.7),
                        width: 1.5)),

                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AllColor.fontColor,
                        width: 2)),
              ),
            ),

            SizedBox(height: 25),

            // ---------------- AMOUNT ----------------
            TextField(
              controller: _amountCtl,
              cursorColor: AllColor.fontColor,
              style: TextStyle(color: AllColor.fontColor),
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: AllColor.fontColor.withOpacity(0.7)),

                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AllColor.fontColor.withOpacity(0.7),
                        width: 1.5)),

                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AllColor.fontColor,
                        width: 2)),
              ),
            ),

            SizedBox(height: 25),

            // ---------------- CATEGORY ----------------
            DropdownButtonFormField(
              value: _selectedValue,
              iconEnabledColor: AllColor.fontColor,
              dropdownColor: AllColor.blueColor,

              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: AllColor.fontColor.withOpacity(0.7)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AllColor.fontColor.withOpacity(0.7),
                        width: 1.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    BorderSide(color: AllColor.fontColor, width: 1.5)),
              ),

              items: listOfValue.map((String val) {
                return DropdownMenuItem(
                  value: val,
                  child: Text(val, style: TextStyle(color: AllColor.fontColor)),
                );
              }).toList(),

              isExpanded: true,

              onChanged: (value) {
                setState(() => _selectedValue = value);
              },
            ),

            SizedBox(height: 25),

            // ---------------- DATE PICKER ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDate.day} ${_expenseController.monthName(selectedDate.month)} ${selectedDate.year}',
                  style: TextStyle(
                      fontSize: 18,
                      color: AllColor.fontColor.withOpacity(0.8)),
                ),
                ElevatedButton(
                  onPressed: pickDate,
                  child: Text(
                    'Select Date',
                    style: TextStyle(
                        fontSize: 18,
                        color: AllColor.fontColor.withOpacity(0.8)),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AllColor.fontColor.withOpacity(0.4)),
                ),
              ],
            ),

            SizedBox(height: 30),

            // ---------------- SAVE BUTTON ----------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(_amountCtl.text) ?? 0;

                  final updatedExpense = Expense(
                    title: _titleCtl.text,
                    amount: amount,
                    category: _selectedValue!,
                    date: selectedDate,
                  );

                  _expenseController.editExpense(widget.hiveKey, updatedExpense);
                  _expenseController.update();

                  Get.back();
                },

                child: Text(
                  'Save Changes',
                  style: TextStyle(
                      fontSize: 22,
                      color: AllColor.fontColor,
                      fontWeight: FontWeight.bold),
                ),

                style: ElevatedButton.styleFrom(
                    backgroundColor: AllColor.blueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
