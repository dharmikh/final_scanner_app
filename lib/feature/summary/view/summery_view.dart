import 'dart:math';

import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/summary/controller/summery_controller.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({super.key});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  final ScrollController primaryScrollController = ScrollController();
  final ScrollController secondaryScrollController = ScrollController();
  SummaryController summeryController = Get.put(SummaryController());
  TransactionController transactionController = Get.put(TransactionController());

  @override
  void initState() {
    transactionController.expensesData();
    summeryController.summaryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Container(
                height: 65,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.greyColor100),
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          summeryController.selectMonthYear(context);
                        },
                        child: Image.asset(AppImages.dateImage),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: summeryController.currentPageMonths.length,
                        itemBuilder: (context, index) {
                          String month = summeryController.currentPageMonths[index];
                          return Row(
                            children: [
                              AppText.manRope14(text: DateFormat("MMM").format(DateFormat("MMMM").parse(month))),
                              SizedBox(width: 10),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.primaryColor),
                              ),
                              SizedBox(width: 10),
                            ],
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: summeryController.previousPage,
                      icon: Icon(Icons.arrow_back_ios, color: AppColor.primaryColor),
                    ),

                    IconButton(
                      onPressed: summeryController.nextPage,
                      icon: Icon(Icons.arrow_forward_ios, color: AppColor.primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  primary: true,
                  child: Column(
                    children: [
                      Obx(
                        () => Container(
                          height: MediaQuery.sizeOf(context).height / 2,
                          decoration: BoxDecoration(
                            //color: Colors.cyan,
                            border: Border.all(color: AppColor.greyColor100),
                            borderRadius: BorderRadius.all(Radius.circular(11)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BarChart(
                                BarChartData(
                                  maxY: summeryController.getMaxY(),
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                        return BarTooltipItem(
                                          'Value: ${rod.toY.toInt()}',
                                          TextStyle(color: AppColor.light, fontWeight: FontWeight.bold),
                                        );
                                      },
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          List<String> months = summeryController.currentPageMonths;
                                          int index = value.toInt();
                                          if (months.isEmpty || index < 0 || index >= months.length) {
                                            return const Text('');
                                          }
                                          return AppText.manRope14(
                                            text: DateFormat("MMM").format(DateFormat("MMMM").parse(months[index])),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  gridData: FlGridData(show: true),
                                  borderData: FlBorderData(show: false),
                                  barGroups: summeryController.buildBarGroups(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(right: 150),
                        child: AppText.manRope24600Align(text: AppString.expenseText),
                      ),
                      SizedBox(height: 20),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(summeryController.currentPageMonths.length, (index) {
                            String month = summeryController.currentPageMonths[index];
                            return GestureDetector(
                              onTap: () {
                                summeryController.selectedMonth.value = month;
                                summeryController.chengIndex();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            month == summeryController.selectedMonth.value
                                                ? AppColor.primaryColor
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: AppText.manRope14(
                                    text: month,
                                    color:
                                        month == summeryController.selectedMonth.value
                                            ? AppColor.primaryColor
                                            : AppColor.dark,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Container(
                        color: AppColor.greyColor,
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(() {
                                  final selectedExpenses = summeryController.result.entries.toList();
                                  return ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: selectedExpenses.length,
                                    itemBuilder: (context, index) {
                                      final category = summeryController.formatCategory(selectedExpenses[index].key);
                                      final percentage = selectedExpenses[index].value;
                                      return Container(
                                        color: AppColor.primaryColor,
                                        height: 40,
                                        child: ListTile(
                                          leading: Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: CategoryColorManager.getCategoryColor(category),
                                            ),
                                          ),
                                          title: Row(
                                            children: [
                                              AppText.manRope13(
                                                text:
                                                    category.length > 10 ? '${category.substring(0, 10)}..' : category,
                                              ),
                                              const SizedBox(width: 3),
                                              AppText.manRope13(text: percentage),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Obx(() {
                                  return PieChart(
                                    key: ValueKey(summeryController.selectedMonth.value),
                                    PieChartData(
                                      sections: summeryController.getPieChartSections(),
                                      centerSpaceRadius: 40,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
