import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  static const double _itemHeight = 50.0;
  static const EdgeInsets _padding = EdgeInsets.all(8.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(AppString.purchaseText),
              _buildPremiumContainer(),
              _buildSectionHeader(AppString.generalText),
              _buildSettingsItem(AppString.rateUsText),
              _buildSettingsItem(AppString.sendFeedbackCrashText),
              _buildSectionHeader(AppString.othersText),
              _buildSettingsItem(AppString.termsAndConditionsText),
              _buildSettingsItem(AppString.privacyPolicyText),
              _buildSettingsItem(AppString.restorePurchaseText),
              _buildOtherAppsContainer(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the AppBar
  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: AppText.manRope18(text: AppString.settingsData, color: AppColor.primaryColor),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(color: AppColor.greyColor50, height: 1),
      ),
      centerTitle: true,
    );
  }

  /// Builds section headers
  Padding _buildSectionHeader(String text) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: AppText.manRope20(text: text));
  }

  /// Builds a settings item
  Widget _buildSettingsItem(String text) {
    return Container(
      height: _itemHeight,
      color: AppColor.light,
      padding: _padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [AppText.manRope16(text: text), Icon(Icons.arrow_forward_ios, color: AppColor.primaryColor)],
      ),
    );
  }

  /// Builds the Premium upgrade container
  Widget _buildPremiumContainer() {
    return Container(
      height: _itemHeight,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.primaryColor),
      padding: _padding,
      child: Row(
        children: [
          Image.asset(AppImages.premiumImage),
          const SizedBox(width: 8),
          Expanded(child: AppText.manRope16(text: AppString.upgradeToPremiumText, color: AppColor.light)),
          Icon(Icons.arrow_forward_ios, color: AppColor.light),
        ],
      ),
    );
  }

  /// Builds the Other Apps container with gradient
  Widget _buildOtherAppsContainer() {
    return Container(
      height: _itemHeight,
      color: AppColor.light,
      child: Row(
        children: [
          Padding(
            padding: _padding,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  colors: [Color(0XFFFFB467), Color(0XFFAF8CFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Image.asset(AppImages.extraIconImage, color: AppColor.light),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppText.manRope16(text: AppString.ourOtherAppsText),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: AppColor.primaryColor),
        ],
      ),
    );
  }
}
