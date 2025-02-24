import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpenseController extends GetxController {
  TransactionController transactionController = Get.put(TransactionController());

  final List<String> currencyData = [
    AppString.oneCurrency,
    AppString.twoCurrency,
    AppString.threeCurrency,
    AppString.fourCurrency,
  ];

  var selectedCurrencyIndex = 0.obs;
  var selectedCategoryIndex = 0.obs;
  var selectedEmoji = '😊'.obs;

  var categoryData = [].obs;

  TextEditingController createCategoryTxt = TextEditingController();
  TextEditingController nameTxt = TextEditingController();
  TextEditingController priceTxt = TextEditingController();
  TextEditingController dateTxt = TextEditingController();
  TextEditingController descriptionTxt = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final categoryKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    tabsData();
  }

  Future<void> tabsData() async {
    categoryData.value = await DBHelper.instance.readCategories();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      dateTxt.text = DateFormat('dd.MM.yyyy').format(pickedDate);
    }
  }

  void onCurrencySelected(int index) {
    selectedCurrencyIndex.value = index;
  }

  void onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
  }

  void onEmojiSelected(String emoji) {
    selectedEmoji.value = emoji;
  }

  Future<void> saveExpense(String pageStatus, int? id) async {
    if (formKey.currentState!.validate()) {
      final selectedCurrency = currencyData[selectedCurrencyIndex.value];
      if (pageStatus == "add") {
        await DBHelper.instance.insertExpense(
          name: nameTxt.text,
          price: priceTxt.text,
          date: dateTxt.text,
          currency: selectedCurrency,
          categoryName: categoryData[selectedCategoryIndex.value]['category'],
          categoryImage: categoryData[selectedCategoryIndex.value]['image'],
          description: descriptionTxt.text,
        );
        await transactionController.expensesData();
        await transactionController.getReportData();
      } else if (pageStatus == "edit") {
        await DBHelper.instance.updateExpense(
          id: id ?? 0,
          name: nameTxt.text,
          price: priceTxt.text,
          date: dateTxt.text,
          currency: selectedCurrency,
          categoryName: categoryData[selectedCategoryIndex.value]['category'],
          categoryImage: categoryData[selectedCategoryIndex.value]['image'],
          description: descriptionTxt.text,
        );
        await transactionController.expensesData();
        await transactionController.getReportData();
      }
      Fluttertoast.showToast(
        msg: "Validation passed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColor.dark,
        textColor: AppColor.light,
        fontSize: 16.0,
      );
      Get.back();
    }
  }

  Future<void> addNewCategory() async {
    if (createCategoryTxt.text.isNotEmpty) {
      await DBHelper.instance.insertCategory(category: createCategoryTxt.text, image: selectedEmoji.value);
      tabsData();
      createCategoryTxt.clear();
      selectedEmoji.value = '😊';
      Get.back();
    } else {
      Fluttertoast.showToast(msg: "Category required");
    }
  }

  @override
  void onClose() {
    createCategoryTxt.dispose();
    nameTxt.dispose();
    priceTxt.dispose();
    dateTxt.dispose();
    descriptionTxt.dispose();
    super.onClose();
  }
}
