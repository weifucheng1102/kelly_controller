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
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MonitorControl extends StatefulWidget {
  const MonitorControl({Key? key}) : super(key: key);

  @override
  State<MonitorControl> createState() => _MonitorControlState();
}

class _MonitorControlState extends State<MonitorControl> {
  //RxBool showFilter = false.obs;
  final connectionCon = Get.put(ConnectionCon());

  ///档位(前进 后退)
  RxString gear = 'N'.obs;
  RxDouble sliderValue = 0.0.obs;
  RxDouble firstDashValue = 0.0.obs;
  RxDouble secondDashValue = 0.0.obs;
  RxDouble thirdDashValue = 0.0.obs;

  Timer? timer;

  @override
  void initState() {
    bus.on('updateControl', (arg) {
      print(arg);
      Uint8List list = arg;
      dashValueChange(list.first, secondDashValue);

      ///第5位 前进开关   第6位 后退开关
      getGearData(list[4], list[5]);
    });
    super.initState();
    print('=======');
    bus.on('control', (arg) {
      print(arg);
      Uint8List list = arg;
      dashValueChange(list.first, firstDashValue);
      dashValueChange(list[1], secondDashValue);
      dashValueChange(list.last, thirdDashValue);
    });

    ///发送指令 每100ms 发送一次
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (connectionCon.port != null) {
        ///发送指令
        connectionCon.port!.write(
            Uint8List.fromList(
                [hexToInt('63'), hexToInt('00'), hexToInt('63')]),
            timeout: 0);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off('control');
    bus.off('updateControl');
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, top: 50.h),
      child: Obx(
        () => ListView(
          controller: ScrollController(),
          children: [
            Column(
              children: widgetList(),
            ),
            // _filterButton(),
          ],
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
                    text: amount,
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
          DashBoard(
            minnum: 0,
            maxnum: 200,
            interval: 20,
            size: 330.w,
            endValue: firstDashValue.value > 200 ? 200 : firstDashValue.value,
            centerWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  firstDashValue.value > 200
                      ? '200'
                      : firstDashValue.value.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.highlightColor,
                  ),
                ),
                Text(
                  'A',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Get.theme.highlightColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 25.w,
          ),
          DashBoard(
            minnum: 0,
            maxnum: 240,
            size: 400.w,
            interval: 20,
            bottomPadding: 23.h,
            endValue: secondDashValue.value > 240 ? 240 : secondDashValue.value,
            centerWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  secondDashValue.value > 240
                      ? '240'
                      : secondDashValue.value.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.highlightColor,
                  ),
                ),
                Text(
                  'Km/h',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Get.theme.highlightColor,
                  ),
                ),
              ],
            ),
            bottomWidget: Text(
              gear.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Get.theme.focusColor,
                fontSize: 52.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 25.w,
          ),
          DashBoard(
            maxnum: 10,
            minnum: 0,
            interval: 1,
            endValue: thirdDashValue.value > 10 ? 10 : thirdDashValue.value,
            size: 330.w,
            centerWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  thirdDashValue.value > 10
                      ? '10'
                      : thirdDashValue.value.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.highlightColor,
                  ),
                ),
                Text(
                  'x 1000rpm',
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
      SizedBox(
        height: 25.h,
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
            rowItem('Rotating speed', '80', 'Km/h'),
            rowItem('Voltage', '200', 'V'),
            rowItem('Current', '10', ' A'),
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
        fieldCon: TextEditingController(text: 'ErrorCode：2021'),
      ),
      SizedBox(
        height: 25.h,
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     const CustomPopMenu(
      //       title: 'Battery',
      //       width: 472,
      //       height: 66,
      //       value: null,
      //     ),
      //     const SizedBox(
      //       width: 95,
      //     ),
      //     CustomInput(
      //       title: 'Error code',
      //       hint: '',
      //       readOnly: true,
      //       textColor: Get.theme.errorColor,
      //       width: 472,
      //       height: 66,
      //       fieldCon: TextEditingController(text: 'ErrorCode：2021'),
      //     ),
      //   ],
      // ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          gearButton('R'),
          gearButton('N'),
          gearButton('D'),
        ],
      ),
      SizedBox(
        height: 25.h,
      ),
      Container(
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
            min: 0,
            max: 5,
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
                    fontSize: 30.sp,
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
      ),
    ];

    return list;
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
      padding: EdgeInsets.symmetric(horizontal: 45.w),
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

  getGearData(int D, int R) {
    print('d' + D.toString() + 'r' + R.toString());
    if (D == 0) {
      gear.value = 'D';
    } else if (R == 0) {
      gear.value = 'R';
    } else {
      gear.value = 'N';
    }
  }
}
