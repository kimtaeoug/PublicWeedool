import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WDTextInput extends StatelessWidget {
  final double width;
  final double height;
  final TextEditingController controller;
  final Function(String?) onChanged;
  final String? hintText;
  final String? label;
  final bool isError;
  final String? errorText;
  final bool isObscure;
  final Function()? obscureFunction;
  final Function(String)? onSubmitted;
  final bool showObscure;
  final int? minLength;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormat;
  final TextInputType? keyboardInputType;
  final bool enabled;
  final Widget? errorWidget;
  final Widget? clearSuffix;
  final FocusNode? focusNode;
  final Function()? onTap;
  const WDTextInput(
      {Key? key,
      required this.width,
      this.height = 54,
      required this.controller,
      required this.onChanged,
      this.hintText,
      this.label,
      this.isError = false,
      this.errorText,
      this.isObscure = false,
      this.obscureFunction,
      this.onSubmitted,
      this.showObscure = false,
      this.minLength,
      this.maxLength,
      this.inputFormat,
      this.keyboardInputType,
      this.enabled = true,
      this.errorWidget,
      this.clearSuffix,
      this.focusNode,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8),
            child: Text(
              label ?? '',
              style: Styler.style(
                  color: WDColors.black2,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              border: Border.all(
                  color: isError ? WDColors.accentRed : Colors.white),
              color: WDColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: TextField(
            onTap: onTap,
            focusNode: focusNode,
            enabled: enabled,
            keyboardType: keyboardInputType,
            maxLength: maxLength,
            cursorColor: WDColors.primaryColor,
            textInputAction: TextInputAction.go,
            onSubmitted: onSubmitted,
            controller: controller,
            onChanged: onChanged,
            obscureText: isObscure,
            style: Styler.style(
                fontWeight: FontWeight.w500,
                color: WDColors.black2,
                fontSize: 16),
            inputFormatters: inputFormat,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              counterText: '',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hintText: hintText,
              hintStyle: Styler.style(
                  color: WDColors.assitive,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5),
              suffixIconConstraints: clearSuffix != null
                  ? const BoxConstraints(minHeight: 18, maxHeight: 18)
                  : null,
              suffixIcon: clearSuffix ??
                  (showObscure
                      ? obscureFunction != null
                          ? GestureDetector(
                              onTap: obscureFunction,
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: Image.asset(isObscure
                                    ? 'assets/images/ic_obscure_close.png'
                                    : 'assets/images/ic_obscure_open.png'),
                              ),
                            )
                          : Container(
                              width: 0,
                            )
                      : Container(
                          width: 0,
                        )),
              // floatingLabelBehavior: FloatingLabelBehavior.always
            ),
          ),
        ),
        if (errorWidget != null && isError) errorWidget ?? Container(),
        if (errorWidget == null)
          Container(
            width: width,
            height: 26,
            color: Colors.transparent,
            child: isError && errorText != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Text(
                      errorText ?? '',
                      style: Styler.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: WDColors.accentRed),
                    ),
                  )
                : Container(),
          )
      ],
    );
  }
}
