import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool autoFocus;
  final TextStyle? style;
  final bool obscureText;
  final int? minLine;
  final int? maxLine;
  final bool? showCursor, readOnly;
  final FocusNode? focusNode;
  final InputBorder? border;
  const InputField({
    this.labelText,
    this.maxLine = 1,
    this.minLine = 1,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.autoFocus = false,
    this.obscureText = false,
    Key? key,
    this.focusNode,
    this.controller,
    this.style,
    this.readOnly,
    this.border,
    this.showCursor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      minLines: minLine,
      maxLines: maxLine,
      focusNode: focusNode,
      showCursor: showCursor,
      readOnly: readOnly ?? false,
      style: style,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
      ),
    );
  }
}
