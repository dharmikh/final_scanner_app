import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/common_text_form_field.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/report/controller%20/add_new_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NewReportView extends StatelessWidget {
  final int? id;
  final String? reportPageStatus;
  final String? reportName;
  final String? clientName;
  final String? status;
  final String? description;

  const NewReportView({
    super.key,
    this.reportPageStatus,
    this.reportName,
    this.clientName,
    this.status,
    this.description,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final NewReportController controller = Get.put(NewReportController());

    // Initialize data when the view is created
    controller.initializeData(reportName: reportName, clientName: clientName, description: description, status: status);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppText.manRope18(
          text: reportPageStatus == "add" ? AppString.newReport : AppString.editReport,
          color: AppColor.primaryColor,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppColor.greyColor50, height: 1),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              AppText.manRope16(text: AppString.reportNameText, color: AppColor.greyColor50),
              OutlinedTextFormFieldWidget(
                controller: controller.reportNameTxt,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
                readonly: false,
              ),
              const SizedBox(height: 16),
              AppText.manRope16(text: AppString.clientNameText, color: AppColor.greyColor50),
              OutlinedTextFormFieldWidget(controller: controller.reportClientNameTxt, readonly: false),
              const SizedBox(height: 16),
              AppText.manRope16(text: AppString.statusText, color: AppColor.greyColor50),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: List.generate(controller.textData.length, (index) {
                        final currencyItem = controller.textData[index];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedStatusIndex.value = index;
                            },
                            child: Obx(
                              () => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(
                                      color:
                                          index == controller.selectedStatusIndex.value
                                              ? AppColor.darkGreen
                                              : AppColor.greyColor50,
                                    ),
                                    color:
                                        index == controller.selectedStatusIndex.value
                                            ? AppColor.lightGreen
                                            : Colors.transparent,
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        controller.statusData[index],
                                        color:
                                            index == controller.selectedStatusIndex.value
                                                ? AppColor.primaryColor
                                                : AppColor.greyColor100,
                                      ),
                                      AppText.manRope13(
                                        text: currencyItem,
                                        color:
                                            index == controller.selectedStatusIndex.value
                                                ? AppColor.primaryColor
                                                : AppColor.greyColor100,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppText.manRope16(text: AppString.descriptionText, color: AppColor.greyColor50),
              OutlinedTextFormFieldWidget(
                controller: controller.reportDescriptionTxt,
                readonly: false,
                maxLines: 5,
                hintText: AppString.noteText,
                hintStyle: GoogleFonts.poppins(color: AppColor.greyColor100),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildButton(
                      text: AppString.cancelText,
                      color: AppColor.lightPink,
                      textColor: AppColor.primaryColor,
                      icon: AppImages.deleteIcon,
                      onTap: () {
                        // showModalBottomSheet<void>(
                        //   context: context,
                        //   backgroundColor: Colors.transparent,
                        //   builder: (BuildContext context) {
                        //     return Padding(
                        //       padding: const EdgeInsets.all(30),
                        //       child: DeleteBottomSite(),
                        //     );
                        //   },
                        // );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      text: AppString.saveText,
                      color: AppColor.primaryColor,
                      textColor: AppColor.light,
                      icon: AppImages.saveIcon,
                      onTap: () async {
                        await controller.saveOrUpdateReport(reportPageStatus: reportPageStatus!, id: id);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 175,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppColor.primaryColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AppText.manRope14(text: text, color: textColor), const SizedBox(width: 20), Image.asset(icon)],
        ),
      ),
    );
  }
}
