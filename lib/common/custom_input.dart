import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/back_widget.dart';

class CustomInput extends StatefulWidget {
  final String title;
  final String hint;
  final Color? textColor;
  final bool readOnly;
  final void Function()? onTap;
  final double width;
  final double height;
  final TextEditingController? fieldCon;
  final void Function(String)? onChanged;
  const CustomInput({
    Key? key,
    required this.title,
    required this.hint,
    required this.readOnly,
    this.onTap,
    required this.width,
    required this.height,
    this.fieldCon,
    this.textColor,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
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
          child: TextFormField(
            controller: widget.fieldCon,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
            ),
            style: TextStyle(
              color: widget.textColor ?? Get.theme.highlightColor,
              fontSize: GetPlatform.isDesktop ? 20 : 16,
            ),
            onChanged: widget.onChanged,
            // validator: (res) {
            //   if (res!.isEmpty) {
            //     return '2222222';
            //   }
            // },
          ),
        ),
      ],
    );
  }
}
