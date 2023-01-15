import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/dash_board.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/connection_con.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';
import 'package:kelly_user_project/pc_page/monitor_control/battery_view.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../config/config.dart';

class MonitorControl extends StatefulWidget {
  final int index;
  const MonitorControl({Key? key, required this.index}) : super(key: key);

  @override
  State<MonitorControl> createState() => _MonitorControlState();
}

class _MonitorControlState extends State<MonitorControl> {
  //RxBool showFilter = false.obs;
  final connectionCon = Get.put(ConnectionCon());
  final parameterCon = Get.put(ParameterCon());

  ///档位(前进 后退)
  RxString gear = 'N'.obs;

  ///油门
  RxDouble sliderValue = 0.0.obs;
  ///仪表盘参数值
  RxDouble firstDashValue = 0.0.obs;
  RxDouble secondDashValue = 0.0.obs;
  RxDouble thirdDashValue = 0.0.obs;

  ///三个仪表盘参数
  Parameter? dashParameter0;
  Parameter? dashParameter1;
  Parameter? dashParameter2;
  Timer? timer;

  ///
  Parameter? realTimeDataShow0;
  Parameter? realTimeDataShow1;
  Parameter? realTimeDataShow2;

  ///电池电量  (0~1)
  double? electricity;

  ///错误码
  int? errorCode;

  @override
  void initState() {
    ///默认显示前三个参数  可修改
    dashParameter0 = parameterCon.real_time_data_list[0];
    dashParameter1 = parameterCon.real_time_data_list[1];
    dashParameter2 = parameterCon.real_time_data_list[2];

    ///默认显示前三个参数  可修改
    realTimeDataShow0 = parameterCon.real_time_data_list[0];
    realTimeDataShow1 = parameterCon.real_time_data_list[1];
    realTimeDataShow2 = parameterCon.real_time_data_list[2];

    super.initState();

    bus.on('updateRealParameter', (arg) {
      dashValueChange(arg, firstDashValue);
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
  void dispose() {
    super.dispose();
    bus.off('updateRealParameter');
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, top: 50.h),
      child: Obx(
        () => Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 90.w, bottom: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BatteryView(electricQuantity: electricity ?? 0),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    'Electricity：' +
                        (electricity == null
                            ? '0'
                            : (electricity! * 100).toStringAsFixed(0)) +
                        '%',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Get.theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: left_menu_margin()),
                controller: ScrollController(),
                children: [
                  Column(
                    children: widgetList(),
                  ),
                  // _filterButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayValue(index) {
    return Expanded(
      child: Center(
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
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget rowItem(title, amount, unit) {
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                color: Get.theme.hintColor,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: amount == null ? '0' : amount.toString(),
                    style: TextStyle(
                      fontSize: 60.sp,
                      color: Get.theme.highlightColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 26.sp,
                      color: Get.theme.highlightColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> list = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dashBoardWidget(
            dashValue: firstDashValue.value,
            parameter: dashParameter0!,
            size: 330.w,
            interval: 20,
            valueFont: 25.sp,
            unitFont: 10.sp,
          ),
          SizedBox(
            width: 25.w,
          ),
          dashBoardWidget(
              dashValue: secondDashValue.value,
              parameter: dashParameter1!,
              size: 440.w,
              interval: 20,
              valueFont: 40.sp,
              unitFont: 13.sp,
              bottomPadding: 23.h,
              bottomWidget: Text(
                gear.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Get.theme.focusColor,
                  fontSize: 52.sp,
                  fontWeight: FontWeight.bold,
                ),
              )),
          SizedBox(
            width: 25.w,
          ),
          dashBoardWidget(
            dashValue: firstDashValue.value,
            parameter: dashParameter0!,
            size: 330.w,
            interval: 20,
            valueFont: 25.sp,
            unitFont: 10.sp,
          ),
        ],
      ),
      SizedBox(
        height: 25.h,
      ),
      widget.index == 0
          ? Column(
              children: [
                realTimeDataWidget(),
                SizedBox(
                  height: 25.w,
                ),
                gearWidget(),
                SizedBox(
                  height: 25.w,
                ),
                acceleratorWidget(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                realTimeDataWidget(),
                gearWidget(),
                acceleratorWidget(),
              ],
            ),
    ];

    return list;
  }

  dashBoardWidget({
    required double dashValue,
    required Parameter parameter,
    required double size,
    required double interval,
    required double valueFont,
    required double unitFont,
    Widget? bottomWidget,
    double bottomPadding = 0,
  }) {
    return DashBoard(
      minnum: parameter.sliderMin,
      maxnum: parameter.sliderMax,
      interval: interval,
      size: size,
      endValue:
          dashValue > parameter.sliderMax ? parameter.sliderMax : dashValue,
      centerWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dashValue > parameter.sliderMax
                ? parameter.sliderMax.toStringAsFixed(0)
                : dashValue.toStringAsFixed(0),
            style: TextStyle(
              fontSize: valueFont,
              fontWeight: FontWeight.bold,
              color: Get.theme.highlightColor,
            ),
          ),
          Text(
            parameter.unit,
            style: TextStyle(
              fontSize: unitFont,
              color: Get.theme.highlightColor,
            ),
          ),
        ],
      ),
      bottomWidget: bottomWidget,
      bottomPadding: bottomPadding,
    );
  }

  realTimeDataWidget() {
    return Column(
      children: [
        SizedBox(
          width: 664.w,
          child: Row(
            children: [
              displayValue(0),
              displayValue(1),
              displayValue(2),
            ],
          ),
        ),
        Container(
          width: 664.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(
                  'assets/images/theme${box.read("theme")}/control_bg.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Row(
            children: [
              rowItem(
                  realTimeDataShow0!.parmName,
                  parameterCon.real_time_data_value[realTimeDataShow0?.motId],
                  realTimeDataShow0!.unit),
              rowItem(
                  realTimeDataShow1!.parmName,
                  parameterCon.real_time_data_value[realTimeDataShow1?.motId],
                  realTimeDataShow1!.unit),
              rowItem(
                  realTimeDataShow2!.parmName,
                  parameterCon.real_time_data_value[realTimeDataShow2?.motId],
                  realTimeDataShow2!.unit),
            ],
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        CustomInput(
          title: 'Error code',
          hint: '',
          readOnly: true,
          textColor: Get.theme.errorColor,
          width: 472.w,
          height: 66.h,
          fieldCon: TextEditingController(
              text: 'ErrorCode：' + (errorCode == null ? '-' : '$errorCode')),
        ),
        SizedBox(
          height: 25.h,
        ),
      ],
    );
  }

  ///档位
  gearWidget() {
    if (widget.index == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: gearButtonList(),
      );
    } else {
      return Column(
        children: gearButtonList(),
      );
    }
    // return [
    //   SizedBox(
    //     height: 25.h,
    //   ),
    // ];
  }

  List<Widget> gearButtonList() {
    return Config.gearList.map((e) => gearButton(e)).toList();
  }

  ///油门
  Widget acceleratorWidget() {
    if (widget.index == 0) {
      return SizedBox(
        width: 606.w,
        child: SfSliderTheme(
          data: SfSliderThemeData(
            activeTrackHeight: 50.h,
            inactiveTrackHeight: 50.h,
            activeTrackColor: Get.theme.primaryColor,
            inactiveTrackColor: Get.theme.hintColor,
            trackCornerRadius: 25.h,
            thumbRadius: 30.h,
          ),
          child: SfSlider(
            min: Config.acceleratorMin,
            max: Config.acceleratorMax,
            stepSize: 1,
            value: sliderValue.value,
            thumbIcon: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.w),
                color: Get.theme.focusColor,
              ),
              padding: EdgeInsets.all(4.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Get.theme.primaryColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  sliderValue.value.toStringAsFixed(0),
                  style: TextStyle(
                    color: Get.theme.highlightColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onChanged: (res) {
              sliderValue.value = res;
            },
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 406.h,
        child: SfSliderTheme(
          data: SfSliderThemeData(
            activeTrackHeight: 50.w,
            inactiveTrackHeight: 50.w,
            activeTrackColor: Get.theme.primaryColor,
            inactiveTrackColor: Get.theme.hintColor,
            trackCornerRadius: 25.w,
            thumbRadius: 30.w,
          ),
          child: SfSlider.vertical(
            min: Config.acceleratorMin,
            max: Config.acceleratorMax,
            stepSize: 1,
            value: sliderValue.value,
            thumbIcon: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.h),
                color: Get.theme.focusColor,
              ),
              padding: EdgeInsets.all(4.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Get.theme.primaryColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  sliderValue.value.toStringAsFixed(0),
                  style: TextStyle(
                    color: Get.theme.highlightColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onChanged: (res) {
              sliderValue.value = res;
            },
          ),
        ),
      );
    }
  }
  // Widget _filterButton() {
  //   return InkWell(
  //     highlightColor: Colors.transparent,
  //     onTap: () {
  //       showFilter.value = !showFilter.value;
  //       setState(() {});
  //     },
  //     child: Container(
  //       width: 1039,
  //       height: 79,
  //       decoration: BoxDecoration(
  //         color: Get.theme.dialogBackgroundColor,
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             'Hide',
  //             style: TextStyle(
  //               fontSize: 22,
  //               color: Get.theme.highlightColor,
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Image.asset(
  //             showFilter.value
  //                 ? 'assets/images/theme${box.read("theme")}/filter_up.png'
  //                 : 'assets/images/theme${box.read("theme")}/filter_down.png',
  //             width: 19,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  ///档位
  Widget gearButton(str) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.index == 0 ? 45.w : 0,
          vertical: widget.index == 1 ? 45.w : 0),
      child: InkWell(
        onTap: () {
          if (gear.value != str) {
            gear.value = str;
          }
        },
        child: Text(
          str,
          style: TextStyle(
            fontSize: 37.sp,
            fontWeight: FontWeight.bold,
            color:
                gear.value == str ? Get.theme.focusColor : Get.theme.hintColor,
          ),
        ),
      ),
    );
  }

  dashValueChange(int newCount, RxDouble dashValue) async {
    int oldValue = dashValue.value.toInt();
    if (newCount > oldValue) {
      for (var i = oldValue; i < newCount + 1; i++) {
        dashValue.value = i.toDouble();
        await Future.delayed(const Duration(milliseconds: 1));
      }
    } else if (newCount < oldValue) {
      for (var i = oldValue; i > newCount - 1; i--) {
        dashValue.value = i.toDouble();
        await Future.delayed(const Duration(milliseconds: 1));
      }
    }
  }

  // getGearData(int D, int R) {
  //   print('d' + D.toString() + 'r' + R.toString());
  //   if (D == 0) {
  //     gear.value = 'D';
  //   } else if (R == 0) {
  //     gear.value = 'R';
  //   } else {
  //     gear.value = 'N';
  //   }
  // }
}
