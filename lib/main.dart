import 'package:awexpenses/controller/category_controller.dart';
import 'package:awexpenses/models/category_model.dart';
import 'package:awexpenses/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controller/expense_controller.dart';
import 'models/expense_model.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(CategoryModelAdapter());

  // 🔴 ALL BOXES MUST BE OPENED BEFORE Get.put
  await Hive.openBox<Expense>('expense');
  await Hive.openBox('user');
  await Hive.openBox<CategoryModel>('categories');
  await Hive.openBox<double>('category_budget'); // ✅ ADD THIS

  Get.put(CategoryController(), permanent: true);
  Get.put(ExpenseController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

