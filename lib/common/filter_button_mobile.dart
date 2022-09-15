import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/filter_view.dart';
import 'package:kelly_user_project/common/filter_view_mobile.dart';
import 'package:kelly_user_project/config/config.dart';

import 'custom_button.dart';
import 'custom_dialog.dart';
import 'get_box.dart';

class FilterButtonMobile extends StatefulWidget {
  const FilterButtonMobile({Key? key}) : super(key: key);

  @override
  State<FilterButtonMobile> createState() => _FilterButtonMobileState();
}

class _FilterButtonMobileState extends State<FilterButtonMobile> {
  RxBool showFilter = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(() => filterButton());
  }

  Widget filterButton() {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        showFilter.value = !showFilter.value;
        if (!showFilter.value) {
          Get.back();
        } else {
          showDialogWidget();
        }
      },
      child: Container(
        width: 1.sw,
        height: 50,
        decoration: BoxDecoration(
          color: Get.theme.dialogBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Filter',
              style: TextStyle(
                fontSize: 13,
                color: Get.theme.highlightColor,
              ),
            ),
            const SizedBox(height: 4),
            Image.asset(
              showFilter.value
                  ? 'assets/images/theme${box.read("theme")}/filter_up.png'
                  : 'assets/images/theme${box.read("theme")}/filter_down.png',
              width: 12.5,
            )
          ],
        ),
      ),
    );
  }

  showDialogWidget() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20), bottom: Radius.zero),
      ),
      builder: (context) => dialogWidget(),
    ).then((res) {
      showFilter.value = false;
    });
  }

  Widget dialogWidget() {
    return Container(
      height: 0.8.sh,
      margin: EdgeInsets.only(left: isLandScape() ? 1.sw / 4 : 0),
      decoration: BoxDecoration(
        color: Get.theme.dialogBackgroundColor,
        borderRadius:const BorderRadius.vertical(
            top: Radius.circular(20), bottom: Radius.zero),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: FilterViewMobile(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Verfy',
                  width: 127,
                  height: 35,
                  onTap: () {},
                ),
                const SizedBox(width: 20),
                CustomButton(
                  text: 'Program',
                  width: 127,
                  height: 35,
                  bgColor: Get.theme.primaryColor,
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            filterButton(),
          ],
        ),
      ),
    );
  }
}
