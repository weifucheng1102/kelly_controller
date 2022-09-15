import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/back_widget.dart';
import 'package:kelly_user_project/common/get_box.dart';

class CustomSelectButton extends StatefulWidget {
  final String title;
  final double width;
  final double height;
  final String text;
  final Color? textColor;
  final void Function()? onTap;
  const CustomSelectButton({
    Key? key,
    required this.width,
    required this.height,
    required this.title,
    this.text = 'Please select',
    this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomSelectButton> createState() => _CustomSelectButtonState();
}

class _CustomSelectButtonState extends State<CustomSelectButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: GetPlatform.isDesktop ? 21 : 0, bottom: 9),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Get.theme.hintColor,
              fontSize: GetPlatform.isDesktop ? 20 : 16,
            ),
          ),
        ),
        BackWidget(
          width: widget.width, // 682,
          height: widget.height, // 66,
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: GetPlatform.isDesktop ? 20 : 16,
                      color: widget.textColor ?? Get.theme.hintColor,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/theme${box.read("theme")}/point_down.png',
                  width: GetPlatform.isDesktop ? 19 : 13,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
