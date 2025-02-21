import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/back_navigation_arrow.dart';
import 'package:final_scanner_app/core/common_widget/common_text_form_field.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/transaction_type_dialogue/expense/controller%20/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ExpensePage extends StatelessWidget {
  final int? id;
  final String? name;
  final String? price;
  final String? currency;
  final String? date;
  final String? image;
  final String? description;
  final String pageStatus;

  const ExpensePage({
    Key? key,
    required this.pageStatus,
    this.name,
    this.price,
    this.date,
    this.description,
    this.currency,
    this.image,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExpenseController expenseController = Get.put(ExpenseController());
    // final SummaryController summeryController = Get.put(SummaryController());

    // Initialize the text controllers with the provided values
    expenseController.nameTxt.text = name ?? "";
    expenseController.priceTxt.text = price ?? "";
    expenseController.dateTxt.text = date ?? "";
    expenseController.descriptionTxt.text = description ?? "";

    // Set the selected currency and category indices
    for (int i = 0; i < expenseController.currencyData.length; i++) {
      if (expenseController.currencyData[i] == currency) {
        expenseController.selectedCurrencyIndex.value = i;
      }
    }

    for (int i = 0; i < expenseController.categoryData.length; i++) {
      if (expenseController.categoryData[i]['image'] == image) {
        expenseController.selectedCategoryIndex.value = i;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: CustomIconButton(),
        title: AppText.manRope18(
          text: pageStatus == "add" ? AppString.newText : AppString.editText,
          color: AppColor.primaryColor,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppColor.greyColor50, height: 1),
        ),
      ),
      body: Form(
        key: expenseController.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildLabel(AppString.nameText),
                      OutlinedTextFormFieldWidget(
                        readonly: false,
                        controller: expenseController.nameTxt,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildLabel(AppString.priceText),
                      OutlinedTextFormFieldWidget(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?(\.\d*)?$'))],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Price is required";
                          }
                          return null;
                        },
                        readonly: false,
                        controller: expenseController.priceTxt,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel(AppString.dateText),
                      OutlinedTextFormFieldWidget(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Date is required";
                          }
                          return null;
                        },
                        readonly: true,
                        onTap: () {
                          expenseController.selectDate(context);
                        },
                        controller: expenseController.dateTxt,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel(AppString.currencyText),
                      const SizedBox(height: 8),
                      _buildCurrencySelector(expenseController),
                      const SizedBox(height: 16),
                      AppText.manRope16(text: AppString.categoryText, color: AppColor.greyColor100),
                      const SizedBox(height: 8),
                      _buildCategorySelector(expenseController, context),
                      const SizedBox(height: 16),
                      _buildLabel(AppString.descriptionText),
                      OutlinedTextFormFieldWidget(
                        controller: expenseController.descriptionTxt,
                        readonly: false,
                        maxLines: 5,
                        hintText: AppString.noteText,
                        hintStyle: GoogleFonts.poppins(color: AppColor.greyColor100),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButtons(expenseController, pageStatus, id, context),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return AppText.manRope16(text: text, color: AppColor.greyColor50);
  }

  Widget _buildCurrencySelector(ExpenseController expenseController) {
    return Row(
      children: List.generate(expenseController.currencyData.length, (index) {
        final currencyItem = expenseController.currencyData[index];
        return Expanded(
          child: GestureDetector(
            onTap: () {
              expenseController.onCurrencySelected(index);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color:
                          index == expenseController.selectedCurrencyIndex.value
                              ? AppColor.darkGreen
                              : AppColor.greyColor50,
                    ),
                    color:
                        index == expenseController.selectedCurrencyIndex.value
                            ? AppColor.lightGreen
                            : AppColor.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    currencyItem,
                    style: TextStyle(
                      color:
                          index == expenseController.selectedCurrencyIndex.value
                              ? AppColor.primaryColor
                              : AppColor.greyColor100,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCategorySelector(ExpenseController expenseController, BuildContext context) {
    return Row(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: AppColor.lightPink,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppColor.primaryColor),
          ),
          child: Center(
            child: IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                        child: DraggableScrollableSheet(
                          initialChildSize: 0.5,
                          minChildSize: 0.3,
                          maxChildSize: 0.9,
                          expand: false,
                          builder: (_, scrollController) {
                            return SingleChildScrollView(
                              controller: scrollController,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      height: 5,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  AppText.manRope16(text: AppString.createCategoryText),
                                  const SizedBox(height: 16),
                                  _buildLabel(AppString.nameText),
                                  const SizedBox(height: 8),
                                  Container(
                                    margin: const EdgeInsets.all(2),
                                    height: 56,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      border: Border.all(color: AppColor.greyColor100),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet<void>(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor: Colors.transparent,
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    height: MediaQuery.of(context).size.height * 0.75,
                                                    decoration: const BoxDecoration(
                                                      color: AppColor.light,
                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        // Top Bar
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 8,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Get.back();
                                                                },
                                                                child: Container(
                                                                  height: 35,
                                                                  width: 35,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: AppColor.primaryColor,
                                                                  ),
                                                                  child: Icon(Icons.close, color: AppColor.light),
                                                                ),
                                                              ),
                                                              // ============ rel way
                                                              AppText.manRope14(text: AppString.selectIconText),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Get.back();
                                                                },
                                                                child: Container(
                                                                  height: 35,
                                                                  width: 35,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: AppColor.primaryColor,
                                                                  ),
                                                                  child: Icon(Icons.check, color: AppColor.light),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Selected Emoji Preview
                                                        Container(
                                                          margin: const EdgeInsets.only(top: 16),
                                                          width: 80,
                                                          height: 80,
                                                          decoration: BoxDecoration(
                                                            color: Colors.pinkAccent.withOpacity(0.1),
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Obx(
                                                              () => Text(
                                                                expenseController.selectedEmoji.value,
                                                                style: const TextStyle(fontSize: 50),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 16),
                                                        // Emoji Selector (Example with some emojis)
                                                        Expanded(
                                                          child: EmojiPicker(
                                                            onEmojiSelected: (category, emoji) {
                                                              expenseController.onEmojiSelected(emoji.emoji);
                                                            },
                                                            config: Config(
                                                              emojiViewConfig: EmojiViewConfig(
                                                                columns: 7,
                                                                emojiSizeMax: 32,
                                                                recentsLimit: 28,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 36,
                                              width: 36,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                                              child: Center(
                                                child: Obx(
                                                  () => Text(
                                                    expenseController.selectedEmoji.value,
                                                    style: const TextStyle(fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Form(
                                              key: expenseController.categoryKey,
                                              child: TextFormField(
                                                controller: expenseController.createCategoryTxt,
                                                decoration: InputDecoration(
                                                  hintText: AppString.categoryNameText,
                                                  hintStyle: GoogleFonts.manrope(color: AppColor.dark),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: () async {
                                      await expenseController.addNewCategory();
                                    },
                                    child: Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColor.primaryColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AppText.manRope14(text: AppString.addNewCategoryText, color: AppColor.light),
                                          SizedBox(width: 10),
                                          Image.asset(AppImages.addIcon, color: AppColor.light),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.add, color: AppColor.primaryColor, size: 40),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
              () => Row(
                children: List.generate(expenseController.categoryData.length, (index) {
                  final categoryItem = expenseController.categoryData[index];
                  return categoryItem['category'] == "All"
                      ? SizedBox.shrink()
                      : GestureDetector(
                        onTap: () {
                          expenseController.onCategorySelected(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Obx(
                            () => Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(
                                  color:
                                      index == expenseController.selectedCategoryIndex.value
                                          ? AppColor.primaryColor
                                          : AppColor.greyColor50,
                                ),
                                color:
                                    index == expenseController.selectedCategoryIndex.value
                                        ? AppColor.lightPink
                                        : Colors.transparent,
                              ),
                              alignment: Alignment.center,
                              child: Text("${categoryItem['image']}"),
                            ),
                          ),
                        ),
                      );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(ExpenseController expenseController, String pageStatus, int? id, BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
                  //     return Padding(padding: const EdgeInsets.all(30), child: DeleteBottomSite());
                  //   },
                  // );
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildButton(
                text: AppString.saveText,
                color: AppColor.primaryColor,
                textColor: AppColor.light,
                icon: AppImages.saveIcon,
                onTap: () {
                  expenseController.saveExpense(pageStatus, id);
                },
              ),
            ),
          ],
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
