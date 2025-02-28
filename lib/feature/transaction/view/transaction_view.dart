import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/feature/report/controller%20/report_controller.dart';
import 'package:final_scanner_app/feature/summary/controller/summery_controller.dart';
import 'package:final_scanner_app/feature/transaction/view/transaction_details_view.dart';
import 'package:final_scanner_app/feature/transaction/widget%20/transaction_to_report.dart';
import 'package:final_scanner_app/feature/transaction_type_dialogue/expense/controller%20/expense_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionsView extends StatefulWidget {
  final int? id;
  final String? rName;
  final String? status;

  const TransactionsView({super.key, this.id, this.rName, this.status});

  @override
  _TransactionsViewState createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  SummaryController summaryController = Get.put(SummaryController());
  late TransactionController transactionController;
  late ExpenseController expenseController;
  late ReportController reportController;

  @override
  void initState() {
    super.initState();
    transactionController = Get.put(TransactionController());
    expenseController = Get.put(ExpenseController());
    reportController = Get.put(ReportController());
    // Optionally fetch data immediately
    transactionController.getReportData();
    transactionController.expensesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: TextField(
          textCapitalization: TextCapitalization.sentences,
          controller: transactionController.searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            hintText: AppString.searchData,
            hintStyle: GoogleFonts.poppins(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            suffixIcon:
                transactionController.searchController.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        transactionController.searchController.clear();
                      },
                    )
                    : null,
            filled: true,
            fillColor: Colors.grey[200],
          ),
          onChanged: (value) {
            transactionController.searchQuery.value = value;
          },
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              height: 60,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: expenseController.categoryData.length,
                itemBuilder: (context, index) {
                  final tabsItem = expenseController.categoryData[index];
                  return Obx(() {
                    bool isSelected = transactionController.selectedIndex.value == index;
                    return GestureDetector(
                      onTap: () {
                        transactionController.selectCategory(index, tabsItem['category']);
                      },
                      child: Container(
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isSelected ? AppColor.lightPink : AppColor.greyColor,
                          border: Border.all(color: isSelected ? AppColor.primaryColor : AppColor.greyColor),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            AppText.manRope16(text: tabsItem['category']),
                            SizedBox(width: 3),
                            AppText.manRope16(text: tabsItem['image']),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            transactionController.getFilteredExpenses().isEmpty
                ? Expanded(
                  child: Center(child: AppText.manRope16(text: "No expenses found", color: AppColor.greyColor50)),
                )
                : Expanded(
                  child: Obx(() {
                    final filteredData = transactionController.getFilteredExpenses();
                    final months = filteredData.keys.toList();
                    return ListView.builder(
                      itemCount: months.length,
                      itemBuilder: (context, index) {
                        final month = months[index];
                        final items = filteredData[month] ?? [];
                        double totalExpense = items.fold(0.0, (sum, item) {
                          return sum + double.tryParse(item['price']?.toString() ?? '0')!;
                        });
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: const EdgeInsets.all(8.0), child: AppText.manRope24600(text: month)),
                                if (index == 0)
                                  Obx(() {
                                    return transactionController.isSelected.value
                                        ? Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: IconButton(
                                                icon: Image.asset(AppImages.copyIcon),
                                                onPressed: () {
                                                  if (transactionController.selectedExpenses.isNotEmpty) {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      backgroundColor: Colors.transparent,
                                                      isScrollControlled: true,
                                                      builder: (BuildContext context) {
                                                        return DataBottomSheet(
                                                          id: widget.id ?? 0,
                                                          expenseIds: transactionController.selectedExpenses.value,
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    Get.snackbar(
                                                      "something Wrong",
                                                      "Pleas Select Expense",
                                                      snackPosition: SnackPosition.TOP,
                                                      backgroundColor: Colors.redAccent,
                                                      colorText: Colors.white,
                                                      duration: Duration(seconds: 1),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: IconButton(
                                                icon: Image.asset(AppImages.deleteIcon),
                                                onPressed: () {
                                                  if (transactionController.selectedExpenses.isNotEmpty) {
                                                    showCupertinoDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext context) {
                                                        return CupertinoAlertDialog(
                                                          title: Column(
                                                            children: [
                                                              SizedBox(height: 8),
                                                              Image.asset(AppImages.deleteIcon, height: 50, width: 50),
                                                              SizedBox(height: 8),
                                                              AppText.manRope24600(
                                                                text: AppString.sureText,
                                                                color: AppColor.dark,
                                                              ),
                                                            ],
                                                          ),
                                                          content: AppText.manRope14(
                                                            text: AppString.deleteWantText,
                                                            color: AppColor.dark,
                                                          ),
                                                          actions: [
                                                            CupertinoDialogAction(
                                                              isDefaultAction: true,
                                                              onPressed: () {
                                                                Get.back();
                                                                transactionController.isSelected.value = false;
                                                                transactionController.selectedExpenses.clear();
                                                              },
                                                              child: AppText.manRope16(
                                                                text: AppString.cancelText,
                                                                color: AppColor.greyColor100,
                                                              ),
                                                            ),
                                                            CupertinoDialogAction(
                                                              isDestructiveAction: true,
                                                              onPressed: () async {
                                                                if (transactionController.isSelected.value) {
                                                                  await transactionController.deleteExpensesByIds(
                                                                    transactionController.selectedExpenses,
                                                                  );
                                                                  await transactionController.expensesData();
                                                                  await summaryController.summaryData();
                                                                  summaryController.chengIndex();
                                                                }
                                                                await transactionController.expensesData();
                                                                Get.back();
                                                              },
                                                              child: AppText.manRope16(
                                                                text: AppString.deleteText,
                                                                color: AppColor.primaryColor,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    Get.snackbar(
                                                      "something Wrong",
                                                      "Pleas Select Expense",
                                                      snackPosition: SnackPosition.TOP,
                                                      backgroundColor: AppColor.redColor,
                                                      colorText: AppColor.light,
                                                      duration: Duration(seconds: 1),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                transactionController.isSelected.value = false;
                                                transactionController.selectedExpenses.clear();
                                              },
                                              icon: Icon(Icons.close, color: AppColor.primaryColor),
                                            ),
                                          ],
                                        )
                                        : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            icon: AppText.manRope16(
                                              text: AppString.select,
                                              color: AppColor.primaryColor,
                                            ),
                                            onPressed: () {
                                              transactionController.select(true);
                                            },
                                          ),
                                        );
                                  }),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: AppText.manRope16(
                                text: "Total expense: ${totalExpense.toStringAsFixed(2)}",
                                color: AppColor.greyColor100,
                              ),
                            ),
                            ListView.builder(
                              itemCount: items.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, itemIndex) {
                                final item = items[itemIndex];
                                return Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                  child: Obx(
                                    () => Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (transactionController.isSelected.value) {
                                              transactionController.toggleSelection(item['id']);
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => ViewReceiptData(
                                                        id: item['id'] ?? 0,
                                                        currency: item['currency'] ?? "",
                                                        description: item['description'] ?? "",
                                                        title: item['name'] ?? "",
                                                        image: item['category_image'] ?? "",
                                                        amount: item['price'] ?? "",
                                                        date: item['date'] ?? "",
                                                      ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 89,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(11),
                                              border: Border.all(
                                                color:
                                                    transactionController.isSelected.value &&
                                                            transactionController.selectedExpenses.contains(item['id'])
                                                        ? AppColor.primaryColor
                                                        : AppColor.greyColor50,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(color: AppColor.primaryColor),
                                                        ),
                                                        child: CircleAvatar(
                                                          backgroundColor: AppColor.lightPink1,
                                                          child: Text(item['category_image']),
                                                        ),
                                                      ),
                                                      SizedBox(width: 25),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          AppText.manRope16(text: item['name']),
                                                          AppText.manRope14(
                                                            text: DateFormat(
                                                              "MMM dd, yyyy",
                                                            ).format(DateFormat("d.M.yyyy").parse("${item['date']}")),
                                                          ),
                                                          AppText.manRope16(
                                                            text:
                                                                "${item['report_name'] == "No Report" ? "" : item['report_name']}",
                                                            color:
                                                                item['report_status'] == "Completed"
                                                                    ? AppColor.darkGreen
                                                                    : item['report_status'] == "Sent"
                                                                    ? AppColor.blueShad
                                                                    : AppColor.redColor,
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      AppText.manRope16(text: '- ${item['price']} ${item['currency']}'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (transactionController.isSelected.value)
                                          Padding(
                                            padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).height / 2.4),
                                            child:
                                                transactionController.isSelected.value &&
                                                        transactionController.selectedExpenses.contains(item['id'])
                                                    ? SizedBox(
                                                      height: 7,
                                                      width: 7,
                                                      //color: AppColor.primaryColor,
                                                      child: Checkbox(
                                                        value: transactionController.selectedExpenses.contains(
                                                          item['id'],
                                                        ),
                                                        onChanged: (value) {
                                                          transactionController.toggleSelection(item['id']);
                                                        },
                                                        shape: CircleBorder(),
                                                        fillColor: WidgetStateProperty.resolveWith<Color>((
                                                          Set<WidgetState> states,
                                                        ) {
                                                          if (states.contains(WidgetState.selected)) {
                                                            return AppColor.primaryColor;
                                                          }
                                                          return AppColor.greyColor100;
                                                        }),
                                                        checkColor: AppColor.light,
                                                      ),
                                                    )
                                                    : SizedBox.shrink(),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),
          ],
        ),
      ),
    );
  }
}
