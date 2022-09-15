import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'back_widget.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color bgColor;
  final double borderWidth;
  final Color? borderColor;
  final void Function()? onTap;
  const CustomButton({
    Key? key,
    required this.text,
    required this.width,
    required this.height,
    this.bgColor = Colors.transparent,
    this.borderWidth = 1,
    this.borderColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackWidget(
      borderWidth: borderWidth,
      borderColor: borderColor,
      bgColor: bgColor,
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: GetPlatform.isDesktop ? 26 : 16,
          color: Get.theme.highlightColor,
        ),
      ),
      width: width,
      height: height,
    );
  }
}
