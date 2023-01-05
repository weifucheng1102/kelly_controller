import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/dash_board.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/config/config.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';

import '../../common/common.dart';
import '../../config/event.dart';
import '../../controller/connection_con.dart';

class TestMonitoringMobile extends StatefulWidget {
  const TestMonitoringMobile({Key? key}) : super(key: key);

  @override
  State<TestMonitoringMobile> createState() => _TestMonitoringMobileState();
}

class _TestMonitoringMobileState extends State<TestMonitoringMobile> {
  final parameterCon = Get.put(ParameterCon());
  final connectionCon = Get.put(ConnectionCon());

  double leftMenuMargin = isLandScape() ? 1.sw / 4 : 0;

  Parameter? realTimeDataShow0;
  Parameter? realTimeDataShow1;
  Parameter? realTimeDataShow2;
  Parameter? realTimeDataShow3;
  Timer? timer;

  @override
  void initState() {
    realTimeDataShow0 = parameterCon.real_time_data_list[0];
    realTimeDataShow1 = parameterCon.real_time_data_list[1];
    realTimeDataShow2 = parameterCon.real_time_data_list[2];
    realTimeDataShow3 = parameterCon.real_time_data_list[3];
    super.initState();
    bus.on('updateRealParameter', (arg) {
      // dashValueChange(arg, firstDashValue);
      //dashValueChange(list[1], secondDashValue);
      //dashValueChange(list.last, thirdDashValue);
    });

    ///发送指令 每1000ms 发送一次
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (connectionCon.port != null) {
        ///发送指令
        connectionCon.sendParameterInstruct(257);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        dashboardWidget(),
        Column(
          children: [
            CustomInput(
              title: 'Error code',
              hint: '',
              readOnly: true,
              textColor: Get.theme.errorColor,
              width: 1.sw - getMobileLeftMargin() - 40,
              height: 50,
              fieldCon: TextEditingController(text: 'ErrorCode：2021'),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        inputGridview(parameterCon.real_time_data_list
            .where((element) => (element.motId != realTimeDataShow0!.motId &&
                element.motId != realTimeDataShow0!.motId &&
                element.motId != realTimeDataShow1!.motId &&
                element.motId != realTimeDataShow2!.motId &&
                element.motId != realTimeDataShow3!.motId))
            .toList()),
      ],
    );
  }

  Widget dashboardWidget() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              width: 130,
              child: displayValue(0),
            ),
            DashBoard(
              minnum: 0,
              maxnum: 200,
              interval: 20,
              size: 180,
              endValue: 100,
              centerWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '1',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.highlightColor,
                    ),
                  ),
                  Text(
                    realTimeDataShow0!.unit,
                    style: TextStyle(
                      fontSize: 8,
                      color: Get.theme.highlightColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              width: 130,
              child: displayValue(1),
            ),
            DashBoard(
              minnum: 0,
              maxnum: 200,
              interval: 20,
              size: 180,
              endValue: 100,
              centerWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '1',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.highlightColor,
                    ),
                  ),
                  Text(
                    realTimeDataShow1!.unit,
                    style: TextStyle(
                      fontSize: 8,
                      color: Get.theme.highlightColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              width: 130,
              child: displayValue(2),
            ),
            DashBoard(
              minnum: 0,
              maxnum: 200,
              interval: 20,
              size: 180,
              endValue: 100,
              centerWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '1',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.highlightColor,
                    ),
                  ),
                  Text(
                    realTimeDataShow2!.unit,
                    style: TextStyle(
                      fontSize: 8,
                      color: Get.theme.highlightColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              width: 130,
              child: displayValue(3),
            ),
            DashBoard(
              minnum: 0,
              maxnum: 200,
              interval: 20,
              size: 180,
              endValue: 100,
              centerWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '1',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.highlightColor,
                    ),
                  ),
                  Text(
                    realTimeDataShow3!.unit,
                    style: TextStyle(
                      fontSize: 8,
                      color: Get.theme.highlightColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget displayValue(index) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        focusColor: Colors.transparent,
        child: DropdownButton(
          focusColor: Colors.transparent,
          dropdownColor: Get.theme.dialogBackgroundColor,
          isExpanded: true,
          icon: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Image.asset(
              'assets/images/theme${box.read("theme")}/point_down.png',
              width: 19.w,
            ),
          ),
          alignment: AlignmentDirectional.center,
          items: parameterCon.real_time_data_list
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.parmName,
                    style: TextStyle(
                      color: Get.theme.highlightColor,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (index == 0) {
              realTimeDataShow0 = value as Parameter?;
            }
            if (index == 1) {
              realTimeDataShow1 = value as Parameter?;
            }
            if (index == 2) {
              realTimeDataShow2 = value as Parameter?;
            }
            if (index == 3) {
              realTimeDataShow3 = value as Parameter?;
            }
            setState(() {});
          },
          value: index == 0
              ? realTimeDataShow0
              : index == 1
                  ? realTimeDataShow1
                  : index == 2
                      ? realTimeDataShow2
                      : realTimeDataShow3,
        ),
      ),
    );
  }

  ///输入框类型参数布局
  Widget inputGridview(List<Parameter> list) {
    return Wrap(
      runSpacing: 20,
      spacing: 20,
      children: list
          .map(
            (e) => Tooltip(
              preferBelow: false,
              message: e.toolTip,
              child: CustomInput(
                title: e.parmName,
                hint: 'hint',
                readOnly: true,
                width: (1.sw - leftMenuMargin - 40) / 2,
                height: 40,
                // fieldCon: TextEditingController(
                //     text:
                //         parameterCon.all_parameter_value[e.parmName].toString()),
                // onChanged: (res) async {
                //   if (isSlider) {
                //     await parameterCon.updateParameterValue(
                //         e, res.isEmpty ? 0 : double.parse(res));
                //   } else {
                //     await parameterCon.updateParameterValue(e, res);
                //   }
                // },
              ),
            ),
          )
          .toList(),
    );
  }
}
