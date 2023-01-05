import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';

import '../../config/config.dart';

class RealTimeDataFilter extends StatefulWidget {
  final List<int> selectids;
  final VoidCallback voidCallback;
  const RealTimeDataFilter({
    Key? key,
    required this.selectids,
    required this.voidCallback,
  }) : super(key: key);

  @override
  State<RealTimeDataFilter> createState() => _RealTimeDataFilterState();
}

class _RealTimeDataFilterState extends State<RealTimeDataFilter> {
  final parameterCon = Get.put(ParameterCon());
  List<int> selectids = [];
  @override
  void initState() {
    super.initState();
    selectids = List.generate(
        widget.selectids.length, (index) => widget.selectids[index]);
  }

  @override
  Widget build(BuildContext context) {
    return dialogWidget();
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

              setState(() {});
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

  Widget foldButton(index) {
    return InkWell(
      onTap: () {
        parameterCon.property_select_more[index] =
            !parameterCon.property_select_more[index];
        setState(() {});
      },
      child: Row(
        children: [
          Text(
            parameterCon.property_select_more[index] ? 'Fold' : 'Unfold',
            style: TextStyle(
              color: Get.theme.hintColor,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(
            width: 4.w,
          ),
          Image.asset(
            parameterCon.property_select_more[index]
                ? 'assets/images/theme${box.read("theme")}/filter_up.png'
                : 'assets/images/theme${box.read("theme")}/filter_down.png',
            width: 16.w,
          )
        ],
      ),
    );
  }

  Widget dialogWidget() {
    return Container(
      width: 1039.w,
      height: 1.sh - 220.h,
      decoration: BoxDecoration(
        color: Get.theme.dialogBackgroundColor,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        children: [
          Expanded(
            child: filterListView(),
          ),
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Reset',
                width: buttonWidth(),
                height: buttonHeight(),
                onTap: () async {
                  Navigator.pop(context);
                  parameterCon.real_time_data_select = List.generate(
                      parameterCon.real_time_data_list.length,
                      (index) => parameterCon.real_time_data_list[index].motId);
                  widget.voidCallback();
                },
              ),
              SizedBox(width: 30.w),
              CustomButton(
                text: 'Confirm',
                 width: buttonWidth(),
                height: buttonHeight(),
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
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
