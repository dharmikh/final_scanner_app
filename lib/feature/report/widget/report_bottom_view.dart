import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/report/controller%20/report_controller.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExpenseBottomSheet extends StatefulWidget {
  final int id;
  final String status;
  final String text;
  final TextAlign? textAlign;

  const ExpenseBottomSheet({super.key, required this.text, this.textAlign, required this.id, required this.status});

  @override
  _ExpenseBottomSheetState createState() => _ExpenseBottomSheetState();
}

class _ExpenseBottomSheetState extends State<ExpenseBottomSheet> {
  final TransactionController transactionController = Get.find<TransactionController>();
  final ReportController reportController = Get.find<ReportController>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        transactionController.selectCategory(0, "All");
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    color: AppColor.light,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Draggable Indicator
                        Center(
                          child: Container(
                            height: 5,
                            width: 56,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColor.dark),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Title
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AppText.manRope16(text: AppString.addReportText, color: AppColor.dark),
                          ),
                        ),
                        // Search TextField
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onChanged: (value) {
                              transactionController.searchQuery.value = value;
                            },
                          ),
                        ),
                        // Expenses List
                        Expanded(
                          child: Obx(() {
                            final filteredData = transactionController.getFilteredExpenses();

                            if (filteredData.isEmpty) {
                              return Center(
                                child: AppText.manRope16(text: "No expenses found", color: AppColor.greyColor50),
                              );
                            }

                            return ListView.builder(
                              itemCount: filteredData.keys.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final month = filteredData.keys.elementAt(index);
                                final List<Map<String, dynamic>> expenses = filteredData[month]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...expenses.map((item) {
                                      return GestureDetector(
                                        onTap: () async {
                                          DBHelper.instance.updateExpenseReportData(
                                            id: int.tryParse(item['id'].toString()) ?? 0,
                                            reportId: widget.id,
                                            //status: widget.status,
                                          );
                                          await transactionController.expensesData();
                                          await reportController.fetchReportExpenses(widget.id.toString());
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(11),
                                            border: Border.all(color: AppColor.greyColor50),
                                          ),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: AppColor.lightPink1,
                                                child: Text(item['category_image']),
                                              ),
                                              SizedBox(width: 15),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AppText.manRope16(text: item['name']),
                                                  AppText.manRope14(
                                                    text: DateFormat(
                                                      "MMM dd, yyyy",
                                                    ).format(DateFormat("d.M.yyyy").parse(item['date'])),
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
                                        ),
                                      );
                                    }),
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
              },
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(width: 1, color: AppColor.greyColor50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset(AppImages.addIcon),
              SizedBox(width: 10),
              Text(
                widget.text,
                textAlign: widget.textAlign,
                style: GoogleFonts.manrope(color: AppColor.dark, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
