import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutlinedTextFormFieldWidget extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool readonly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ScrollController? scrollController;
  final TextInputType? keyboardType;
  final Widget? prefixWidget;
  final IconData? suffixIcon;
  final bool isObscure;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onSuffixIconTap;
  final TextStyle? hintStyle; // New property added

  const OutlinedTextFormFieldWidget({
    super.key,
    this.labelText,
    this.hintText,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
    this.prefixWidget,
    this.suffixIcon,
    this.isObscure = false,
    this.validator,
    this.onChanged,
    this.onSuffixIconTap,
    this.hintStyle,
    this.scrollController,
    this.onTap,
    required this.readonly,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      inputFormatters: inputFormatters,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onTap: onTap,
      readOnly: readonly,
      obscureText: isObscure,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: hintStyle ?? const TextStyle(color: AppColor.greyColor50),
        // Default hint style
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColor.greyColor50,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        prefixIcon: prefixWidget,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
          onTap: onSuffixIconTap,
          child: Icon(suffixIcon),
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 22.0,
          horizontal: 12.0,
        ),
      ),
    );
  }
}
