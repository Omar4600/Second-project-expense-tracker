import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryBudgetPage extends StatelessWidget {
  const CategoryBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.find();

    return Scaffold(
      backgroundColor: AllColor.bgColor,
      appBar: AppBar(
        backgroundColor: AllColor.blueColor,
        foregroundColor: AllColor.fontColor,
        title: const Text(
          'Category Budgets',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Obx(() {
        final categories = controller.categories;

        if (categories.isEmpty) {
          return Center(
            child: Text('No categories found',
                style: TextStyle(color: AllColor.fontColor)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];

            return Card(
              color: AllColor.blueColor.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(cat.color),
                ),
                title: Text(
                  cat.name,
                  style: TextStyle(
                      color: AllColor.fontColor,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: cat.monthlyBudget > 0
                    ? Text(
                  'Budget: ৳${cat.monthlyBudget.toStringAsFixed(0)}',
                  style: TextStyle(color: AllColor.fontColor),
                )
                    : Text(
                  'No budget set',
                  style: TextStyle(
                      color:
                      AllColor.fontColor.withOpacity(0.6)),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.attach_money,
                      color: Colors.green),
                  onPressed: () {
                    _showBudgetDialog(context, controller, cat);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showBudgetDialog(BuildContext context,
      CategoryController controller, dynamic cat) {
    final TextEditingController budgetController =
    TextEditingController(
        text: cat.monthlyBudget > 0
            ? cat.monthlyBudget.toStringAsFixed(0)
            : '');

    Get.dialog(
      AlertDialog(
        backgroundColor: AllColor.bgColor,
        title: Text('Set Budget for ${cat.name}',
            style: TextStyle(color: AllColor.fontColor)),
        content: TextField(
          controller: budgetController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: AllColor.fontColor),
          decoration: InputDecoration(
            labelText: 'Enter amount',
            labelStyle:
            TextStyle(color: AllColor.fontColor.withOpacity(0.7)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearCategoryBudget(cat.id);
              Get.back();
            },
            child: const Text('Clear',
                style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child:
            const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              final value =
                  double.tryParse(budgetController.text.trim()) ?? 0;
              controller.setCategoryBudget(cat.id, value);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AllColor.blueColor),
            child:
            Text('Save', style: TextStyle(color: AllColor.fontColor)),
          ),
        ],
      ),
    );
  }
}
