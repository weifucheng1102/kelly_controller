import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/get_box.dart';

import '../config/config.dart';

class ShowSuccessDialog extends StatefulWidget {
  const ShowSuccessDialog({Key? key}) : super(key: key);

  @override
  State<ShowSuccessDialog> createState() => _ShowSuccessDialogState();
}

class _ShowSuccessDialogState extends State<ShowSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        color: Get.theme.dialogBackgroundColor,
      ),
      child: dialogView(),
    );
  }

  Widget dialogView() {
    return Column(
      children: [
        Column(
          children: [
            Image.asset(
              'assets/images/theme${box.read("theme")}/sucess.png',
            ),
            SizedBox(
              height: 28.h,
            ),
            Text(
              'modify successfully',
              style: TextStyle(
                fontSize: 30.sp,
                color: Get.theme.highlightColor,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.h,
        ),
        CustomButton(
          text: 'OK',
          width: buttonWidth(),
          height: buttonHeight(),
          bgColor: Get.theme.primaryColor,
          borderWidth: 0,
          borderColor: Colors.transparent,
          onTap: () async {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
