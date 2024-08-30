import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../resources/colors.dart';

class AppFormField extends StatefulWidget {
  const AppFormField({
    this.controller,
    this.suffixIcon,
    this.hintText = "hint",
    this.enablePasswordVisibilityIcon = false,
    super.key,
  });

  final String hintText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool enablePasswordVisibilityIcon;

  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  bool isPassword = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.secondary),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: widget.hintText,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.enablePasswordVisibilityIcon && widget.suffixIcon == null
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    icon: Icon(
                      isPassword
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
                      color: AppColors.grey,
                    ),
                  )
                : widget.suffixIcon ?? const SizedBox.shrink(),
          ],
        )
      ],
    );
  }
}
