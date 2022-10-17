import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kelly_user_project/common/filter_view.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';

import 'custom_button.dart';
import 'custom_dialog.dart';
import 'get_box.dart';

class FilterButton extends StatefulWidget {
  final VoidCallback voidCallback;
  const FilterButton({
    Key? key,
    required this.voidCallback,
  }) : super(key: key);

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  final parameterCon = Get.put(ParameterCon());

  // RxBool showFilter = false.obs;

  @override
  Widget build(BuildContext context) {
    return filterButton();
  }

  Widget filterButton() {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        widget.voidCallback();
        // showFilter.value = !showFilter.value;
        // if (!showFilter.value) {
        //   Get.back();
        // } else {
        //   showDialogWidget();
        // }
      },
      child: Container(
        width: 1039.w,
        height: 79.h,
        decoration: BoxDecoration(
          color: Get.theme.dialogBackgroundColor,
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Filter',
              style: TextStyle(
                fontSize: 22.sp,
                color: Get.theme.highlightColor,
              ),
            ),
            SizedBox(height: 8.h),
            Image.asset(
              // showFilter.value
              //     ? 'assets/images/theme${box.read("theme")}/filter_up.png'
              // :
              'assets/images/theme${box.read("theme")}/filter_down.png',
              width: 19.w,
            )
          ],
        ),
      ),
    );
  }
}
