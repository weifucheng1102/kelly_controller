import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BackWidget extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color bgColor;
  final double? borderWidth;
  final Color? borderColor;
  final void Function()? onTap;
  const BackWidget({
    Key? key,
    required this.child,
    required this.width,
    required this.height,
    this.bgColor = Colors.transparent,
    this.borderWidth,
    this.borderColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double borderwidth = borderWidth ?? (GetPlatform.isDesktop ? 1 : 1.w);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width, // 682,
        height: height, // 66,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            width: borderwidth,
            color: borderColor ?? Get.theme.hintColor,
          ),
          borderRadius: BorderRadius.circular(GetPlatform.isDesktop ? 15 : 10),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
