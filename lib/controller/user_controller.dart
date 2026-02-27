import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserController extends GetxController{
  var name = ''.obs;
  var monthlyBudget = 0.0.obs;
  var savedMonth = 0.obs;

  final Box box = Hive.box('user');

  @override
  void onInit() {
    loadUser();
    super.onInit();
  }

  void loadUser() {
    name.value = box.get('name', defaultValue: '');
    monthlyBudget.value = box.get('monthlyBudget', defaultValue: 0.0);
    savedMonth.value = box.get('savedMonth', defaultValue: 0);

    int currentMonth = DateTime.now().month;

    if(savedMonth.value != currentMonth) {
      monthlyBudget.value = 0.0;
      box.put('monthlyBudget', 0.0);

      savedMonth.value = currentMonth;
      box.put('savedMonth', currentMonth);
    }
  }

  void saveUserName(String newName){
    name.value = newName;
    box.put('name', newName);
  }

  void saveUserBudget(double budget){
    monthlyBudget.value = budget;
    box.put('monthlyBudget', budget);

    int currentMonth = DateTime.now().month;
    savedMonth.value = currentMonth;
    box.put('savedMonth', currentMonth);
  }

  void updateUserName(String newName){
    name.value = newName;
    box.put('name', newName);
  }

  void updateUserBudget(double budget){
    monthlyBudget.value = budget;
    box.put('monthlyBudget', budget);

    int currentMonth = DateTime.now().month;
    savedMonth.value = currentMonth;
    box.put('savedMonth', currentMonth);
  }
}