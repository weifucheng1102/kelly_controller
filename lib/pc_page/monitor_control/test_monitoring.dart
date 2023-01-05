import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/back_widget.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/dash_board.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/config/config.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';

import '../../controller/connection_con.dart';

class TestMonitoring extends StatefulWidget {
  const TestMonitoring({Key? key}) : super(key: key);

  @override
  State<TestMonitoring> createState() => _TestMonitoringState();
}

class _TestMonitoringState extends State<TestMonitoring> {
  Timer? timer;
  final connectionCon = Get.put(ConnectionCon());

  final parameterCon = Get.put(ParameterCon());

  Parameter? realTimeDataShow0;
  Parameter? realTimeDataShow1;
  Parameter? realTimeDataShow2;
  Parameter? realTimeDataShow3;
  @override
  void initState() {
    realTimeDataShow0 = parameterCon.real_time_data_list[0];
    realTimeDataShow1 = parameterCon.real_time_data_list[1];
    realTimeDataShow2 = parameterCon.real_time_data_list[2];
    realTimeDataShow3 = parameterCon.real_time_data_list[3];

    super.initState();
    bus.on('updateRealParameter', (arg) {
      

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
  void dispose() {
    super.dispose();
    bus.off('updateRealParameter');
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: left_menu_margin()),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40.h, right: 90.w, bottom: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Error code',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Get.theme.hintColor,
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                BackWidget(
                  width: 322.w,
                  height: 66.h,
                  child: TextFormField(
                    controller: TextEditingController(text: 'errorcode:2022'),
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      // hintText: widget.hint,
                    ),
                    style: TextStyle(
                      color: Get.theme.errorColor,
                      fontSize: 20.sp,
                    ),
                    // validator: (res) {
                    //   if (res!.isEmpty) {
                    //     return '2222222';
                    //   }
                    // },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            controller: ScrollController(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                        child: displayValue(0),
                      ),
                      DashBoard(
                        minnum: 0,
                        maxnum: 200,
                        size: 280.w,
                        interval: 20,
                        endValue: 100,
                        centerWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1',
                              style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Get.theme.highlightColor,
                              ),
                            ),
                            Text(
                              realTimeDataShow0!.unit,
                              style: TextStyle(
                                fontSize: 10.sp,
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
                        height: 80.h,
                        child: displayValue(1),
                      ),
                      DashBoard(
                        minnum: 0,
                        maxnum: 200,
                        size: 280.w,
                        interval: 20,
                        endValue: 100,
                        centerWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1',
                              style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Get.theme.highlightColor,
                              ),
                            ),
                            Text(
                              realTimeDataShow1!.unit,
                              style: TextStyle(
                                fontSize: 10.sp,
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
                        height: 80.h,
                        child: displayValue(2),
                      ),
                      DashBoard(
                        minnum: 0,
                        maxnum: 200,
                        size: 280.w,
                        interval: 20,
                        endValue: 100,
                        centerWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1',
                              style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Get.theme.highlightColor,
                              ),
                            ),
                            Text(
                              realTimeDataShow2!.unit,
                              style: TextStyle(
                                fontSize: 10.sp,
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
                        height: 80.h,
                        child: displayValue(3),
                      ),
                      DashBoard(
                        minnum: 0,
                        maxnum: 200,
                        size: 280.w,
                        interval: 20,
                        endValue: 100,
                        centerWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1',
                              style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Get.theme.highlightColor,
                              ),
                            ),
                            Text(
                              realTimeDataShow3!.unit,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Get.theme.highlightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              inputGridview(parameterCon.real_time_data_list
                  .where((element) =>
                      (element.motId != realTimeDataShow0!.motId &&
                          element.motId != realTimeDataShow0!.motId &&
                          element.motId != realTimeDataShow1!.motId &&
                          element.motId != realTimeDataShow2!.motId &&
                          element.motId != realTimeDataShow3!.motId))
                  .toList()),
            ],
          ))
        ],
      ),
    );
  }

  Widget displayValue(index) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: Theme(
          data: ThemeData(
            focusColor: Colors.transparent,
          ),
          child: DropdownButton(
            focusColor: Colors.transparent,
            dropdownColor: Get.theme.dialogBackgroundColor,
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
            hint: Text(
              'display value',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                color: Get.theme.hintColor,
              ),
            ),
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
      ),
    );
  }

  // List<Widget> bottomItems() {
  //   List<Widget> list = [];
  //   for (var i = 0; i < 28; i++) {
  //     list.add(CustomPopMenu(
  //         title: i.toString(), width: 200, height: 66.h, value: i));
  //   }
  //   return list;
  // }
}

///输入框类型参数布局
Widget inputGridview(List<Parameter> list) {
  return Wrap(
    runSpacing: 30.h,
    spacing: 30.w,
    children: list
        .map(
          (e) => Tooltip(
            preferBelow: false,
            message: e.toolTip,
            child: CustomInput(
              title: e.parmName,
              hint: '',
              readOnly: true,
              width: 350,
              height: 66.w,
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
