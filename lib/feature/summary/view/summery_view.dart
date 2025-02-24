import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/summary/controller/summery_controller.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/feature/transaction_type_dialogue/expense/controller%20/expense_controller.dart';
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
  SummaryController summeryController = Get.put(SummaryController());
  TransactionController transactionController = Get.put(TransactionController());
  double totalExpense = 0.0;
  int currentPage = 0;

  Future<void> _selectMonthYear(BuildContext context) async {
    int selectedMonth = DateTime.now().month;
    int selectedYear = DateTime.now().year;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Month and Year"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Month Dropdown
              DropdownButton<int>(
                value: selectedMonth,
                items: List.generate(12, (index) {
                  return DropdownMenuItem(value: index + 1, child: Text("${index + 1}"));
                }),
                onChanged: (int? value) {
                  if (value != null) {
                    selectedMonth = value;
                  }
                },
              ),

              // Year Dropdown
              DropdownButton<int>(
                value: selectedYear,
                items: List.generate(50, (index) {
                  int year = DateTime.now().year - 25 + index;
                  return DropdownMenuItem(value: year, child: Text("$year"));
                }),
                onChanged: (int? value) {
                  if (value != null) {
                    selectedYear = value;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                print("Selected Month-Year: $selectedMonth-$selectedYear");
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  final List<String> orderedMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  List<String> get currentPageMonths {
    int start = currentPage * 4;
    int end = start + 4;
    // Ensure we do not exceed the length of orderedMonths.
    return orderedMonths.sublist(start, end > orderedMonths.length ? orderedMonths.length : end);
  }

  // Go to next page if available.
  void nextPage() {
    if ((currentPage + 1) * 4 < orderedMonths.length) {
      setState(() {
        currentPage++;
      });
    }
  }

  // Go to previous page if available.
  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  // final List<double> data = [50, 70, 400, 40, 90, 30];

  //final List<String> labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];

  @override
  void initState() {
    transactionController.expensesData();
    summeryController.summaryData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                          _selectMonthYear(context);
                        },
                        child: Image.asset(AppImages.dateImage),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: currentPageMonths.length,
                        itemBuilder: (context, index) {
                          String month = currentPageMonths[index];
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
                    IconButton.outlined(
                      alignment: Alignment.center,
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(BorderSide(color: AppColor.primaryColor, width: 2.0)),
                      ),
                      onPressed: previousPage,
                      icon: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back_ios, color: AppColor.primaryColor),
                      ),
                    ),
                    IconButton.outlined(
                      alignment: Alignment.center,
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(BorderSide(color: AppColor.primaryColor, width: 2.0)),
                      ),
                      onPressed: nextPage,
                      icon: Icon(Icons.arrow_forward_ios, color: AppColor.primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // CustomPaint(
              //   size: Size(300, 250),
              //   painter: BarChartPainter(
              //     data: _getBarValues(),
              //     labels: List.generate(_getBarValues().length,
              //         (index) => index < currentPageMonths.length ? currentPageMonths[index] : ''),
              //   ),
              // ),
              Container(
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
                        maxY: getMaxY(),
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
                                List<String> months = currentPageMonths;
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
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: _buildBarGroups(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              AppText.manRope24600Align(text: AppString.expenseText),
              SizedBox(height: 20),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(currentPageMonths.length, (index) {
                    String month = currentPageMonths[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          summeryController.selectedMonth.value = month;
                          summeryController.chengIndex();
                        });
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
                                month == summeryController.selectedMonth.value ? AppColor.primaryColor : AppColor.dark,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2,
                          child: Obx(() {
                            final selectedExpenses = summeryController.result.entries.toList();
                            return ListView.builder(
                              shrinkWrap: true,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: selectedExpenses.length,
                              itemBuilder: (context, index) {
                                final category = summeryController.formatCategory(selectedExpenses[index].key);
                                final percentage = selectedExpenses[index].value;

                                return ListTile(
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
                                      AppText.manRope13(text: category),
                                      SizedBox(width: 3),
                                      AppText.manRope13(text: percentage),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 55),
                          child: Obx(() {
                            return PieChart(
                              PieChartData(sections: summeryController.getPieChartSections(), centerSpaceRadius: 40),
                            );
                          }),
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

  List<BarChartGroupData> _buildBarGroups() {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < currentPageMonths.length; i++) {
      String month = currentPageMonths[i];

      if (!summeryController.expenseMapData.containsKey(month)) continue;

      totalExpense = summeryController.expenseMapData[month]!.fold(
        0.0,
        (sum, expense) => sum + (double.parse(expense['price'])),
      );
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: totalExpense,
              color: AppColor.primaryColor,
              width: 15,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  double getMaxY() {
    final currentValues = _buildBarGroups().expand((group) => group.barRods).map((rod) => rod.toY).toList();

    if (currentValues.isEmpty) return 100;
    return currentValues.reduce((max, value) => value > max ? value : max) * 1;
  }
}
