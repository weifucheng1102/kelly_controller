import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/filter_view.dart';
import 'package:kelly_user_project/common/filter_view_mobile.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/config/config.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';

class RealTimeDataFilterMobile extends StatefulWidget {
  final List<int> selectids;

  final VoidCallback voidCallback;

  const RealTimeDataFilterMobile(
      {Key? key, required this.selectids, required this.voidCallback})
      : super(key: key);

  @override
  State<RealTimeDataFilterMobile> createState() =>
      _RealTimeDataFilterMobileState();
}

class _RealTimeDataFilterMobileState extends State<RealTimeDataFilterMobile> {
  double spaceHeight = 20;

  RxBool showFilter = false.obs;
  final parameterCon = Get.put(ParameterCon());
  List<int> selectids = [];
  var dialogstate;
  @override
  void initState() {
    super.initState();
  }

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
    selectids = List.generate(
        widget.selectids.length, (index) => widget.selectids[index]);
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
    return StatefulBuilder(builder: (context, dialogState) {
      dialogstate = dialogState;
      return Container(
        height: 0.8.sh,
        margin: EdgeInsets.only(left: isLandScape() ? 1.sw / 4 : 0),
        decoration: BoxDecoration(
          color: Get.theme.dialogBackgroundColor,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20), bottom: Radius.zero),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: filterListView(),
              ),
              SizedBox(height: spaceHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'Reset',
                    width: mobileButtonWidth(),
                    height: mobileButtonHeight(),
                    onTap: () async {
                      Navigator.pop(context);
                      parameterCon.real_time_data_select = List.generate(
                          parameterCon.real_time_data_list.length,
                          (index) =>
                              parameterCon.real_time_data_list[index].motId);
                      widget.voidCallback();
                    },
                  ),
                  SizedBox(width: spaceHeight),
                  CustomButton(
                    text: 'Confirm',
                    width: mobileButtonWidth(),
                    height: mobileButtonHeight(),
                    bgColor: Get.theme.primaryColor,
                    borderWidth: 0,
                    borderColor: Colors.transparent,
                    onTap: () async {
                      Navigator.pop(context);
                      parameterCon.real_time_data_select = selectids;
                      widget.voidCallback();
                    },
                  ),
                ],
              ),
              SizedBox(height: spaceHeight),
              filterButton(),
            ],
          ),
        ),
      );
    });
  }

  filterListView() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 78.w, vertical: 42.h),
      children: [
        Wrap(
          spacing: 20.w,
          runSpacing: 20.w,
          children: gridViewList(),
        )
      ],
    );
  }

  List<Widget> gridViewList() {
    List<Widget> list = [];

    for (var i = 0; i < parameterCon.real_time_data_list.length; i++) {
      Parameter parameter = parameterCon.real_time_data_list[i];
      list.add(
        Tooltip(
          message: parameter.toolTip,
          showDuration: const Duration(seconds: 0),
          preferBelow: false,
          child: InkWell(
            onTap: () {
              if (selectids.contains(parameter.motId)) {
                selectids.remove(parameter.motId);
              } else {
                selectids.add(parameter.motId);
              }

              dialogstate(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: selectids.contains(parameter.motId)
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Get.theme.primaryColor,
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.transparent,
                      border: Border.all(
                        color: Get.theme.hintColor,
                        width: 1.w,
                      ),
                    ),
              child: Text(
                parameter.parmName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: selectids.contains(parameter.motId)
                      ? Get.theme.highlightColor
                      : Get.theme.hintColor,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return list;
  }
}
