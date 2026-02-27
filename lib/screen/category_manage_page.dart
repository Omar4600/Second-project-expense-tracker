import 'package:awexpenses/const/widget.dart';
import 'package:awexpenses/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryManagePage extends StatelessWidget {
  const CategoryManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
    Get.find<CategoryController>();

    return Scaffold(
      backgroundColor: AllColor.bgColor,
      appBar: AppBar(
        backgroundColor: AllColor.blueColor,
        foregroundColor: AllColor.fontColor,
        title: const Text(
          'Manage Categories',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context, categoryController);
        },
        child: Icon(Icons.add, size: 26),
        backgroundColor: AllColor.fontColor,
        foregroundColor: AllColor.bgColor,
      ),
      body: Obx(() {
        final categories = categoryController.categories;

        if (categories.isEmpty) {
          return Center(
            child: Text(
              'No categories yet!',
              style: TextStyle(color: AllColor.fontColor),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isDefault = cat.name.toLowerCase() == 'food' ||
                cat.name.toLowerCase() == 'transport';

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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isDefault)
                      IconButton(
                        icon: Icon(Icons.edit, color: AllColor.fontColor),
                        onPressed: () {
                          _showEditCategoryDialog(
                              context, categoryController, cat);
                        },
                      ),
                    if (!isDefault)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'Delete',
                            middleText: 'Are you sure?',
                            onConfirm: () {
                              categoryController.deleteCategory(cat.id);
                              Get.back();
                            },
                            onCancel: () {},
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// 🔹 Add Category Dialog
  void _showAddCategoryDialog(
      BuildContext context, CategoryController controller) {
    final TextEditingController nameController = TextEditingController();
    Color? selectedColor; // ✅ START: null → no tick initially

    Get.dialog(
      StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: AllColor.bgColor,
          title:
          Text('Add Category', style: TextStyle(color: AllColor.fontColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: AllColor.fontColor),
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  labelStyle:
                  TextStyle(color: AllColor.fontColor.withOpacity(0.7)),
                ),
              ),
              const SizedBox(height: 16),

              // 🎨 Color Picker — ONLY this logic
              Wrap(
                spacing: 10,
                children: controller.defaultPalette.map((color) {
                  final isSelected = selectedColor == color;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color; // ✅ Tick moves here
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: color,
                          radius: 18,
                        ),
                        if (isSelected)
                          const Icon(Icons.check, color: Colors.white),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    selectedColor != null) {
                  controller.addCategory(nameController.text,
                      color: selectedColor!.value);
                  Get.back();
                }
                if (nameController.text.isEmpty || selectedColor == null) {
                  Get.snackbar('Error',
                      'Please fill/select all fields correctly',
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AllColor.blueColor),
              child:
              Text('Add', style: TextStyle(color: AllColor.fontColor)),
            ),
          ],
        );
      }),
    );
  }

  /// 🔹 Edit Category Dialog
  void _showEditCategoryDialog(BuildContext context,
      CategoryController controller, dynamic cat) {
    final TextEditingController nameController =
    TextEditingController(text: cat.name);
    Color? selectedColor; // ✅ null initially → no tick

    Get.dialog(
      StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: AllColor.bgColor,
          title:
          Text('Edit Category', style: TextStyle(color: AllColor.fontColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: AllColor.fontColor),
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  labelStyle:
                  TextStyle(color: AllColor.fontColor.withOpacity(0.7)),
                ),
              ),
              const SizedBox(height: 16),

              // 🎨 Color Picker — ONLY this logic
              Wrap(
                spacing: 10,
                children: controller.defaultPalette.map((color) {
                  final isSelected = selectedColor == color;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color; // ✅ Tick moves here
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: color,
                          radius: 18,
                        ),
                        if (isSelected)
                          const Icon(Icons.check, color: Colors.white),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child:
              const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    selectedColor != null) {
                  controller.updateCategory(
                      cat.id, nameController.text, selectedColor!.value);
                  Get.back();
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AllColor.blueColor),
              child:
              Text('Update', style: TextStyle(color: AllColor.fontColor)),
            ),
          ],
        );
      }),
    );
  }
}
