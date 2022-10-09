import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShowSuccessDialog extends StatefulWidget {
  const ShowSuccessDialog({Key? key}) : super(key: key);

  @override
  State<ShowSuccessDialog> createState() => _ShowSuccessDialogState();
}

class _ShowSuccessDialogState extends State<ShowSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 562.w,
      height: 600.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        color: const Color(0xFF2E3A46),
      ),
      child: dialogView(),
    );
  }

  Widget dialogView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Image.asset(
              'images/sucess.png',
              width: 150.w,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 28.w,
            ),
            Text(
              'modify successfully',
              style: TextStyle(
                fontSize: 30.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 88.w,
            width: 340.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
              gradient: LinearGradient(
                colors: [
                  Get.theme.appBarTheme.backgroundColor!,
                  Get.theme.appBarTheme.foregroundColor!,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'Modify',
              style: Get.theme.textTheme.bodyText1,
            ),
          ),
        ),
      ],
    );
  }
}
