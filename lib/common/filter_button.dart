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
        width: 1039,
        height: 79,
        decoration: BoxDecoration(
          color: Get.theme.dialogBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Filter',
              style: TextStyle(
                fontSize: 22,
                color: Get.theme.highlightColor,
              ),
            ),
            const SizedBox(height: 8),
            Image.asset(
              showFilter.value
                  ? 'assets/images/theme${box.read("theme")}/filter_up.png'
                  : 'assets/images/theme${box.read("theme")}/filter_down.png',
              width: 19,
            )
          ],
        ),
      ),
    );
  }

  showDialogWidget() {
    CustomDialog.showCustomDialog(
      context,
      dismissCallback: () {
        showFilter.value = false;
      },
      child: dialogWidget(),
    );
  }

  Widget dialogWidget() {
    return Container(
      width: 1039,
      height: 1.sh - 220,
      decoration: BoxDecoration(
        color: Get.theme.dialogBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Expanded(
            child: FilterView(),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Verfy',
                width: 165,
                height: 64,
                onTap: () async {
                  await parameterCon.getDefaultProPertySelectList();
                  await parameterCon.getParameterWithProperty();

                  Navigator.pop(context);
                  widget.voidCallback();
                },
              ),
              const SizedBox(width: 30),
              CustomButton(
                text: 'Program',
                width: 165,
                height: 64,
                bgColor: Get.theme.primaryColor,
                borderWidth: 0,
                borderColor: Colors.transparent,
                onTap: () async {
                  await parameterCon.getParameterWithProperty();
                  Navigator.pop(context);
                  widget.voidCallback();
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          filterButton(),
        ],
      ),
    );
  }
}
