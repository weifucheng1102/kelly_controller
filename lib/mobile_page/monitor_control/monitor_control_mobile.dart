import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/app_bar_mobile.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/dash_board.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/common/top_tabbar_item_mobile.dart';
import 'package:kelly_user_project/config/config.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../config/event.dart';
import '../../controller/connection_con.dart';

class MonitorControlMobile extends StatefulWidget {
  const MonitorControlMobile({Key? key}) : super(key: key);

  @override
  State<MonitorControlMobile> createState() => _MonitorControlMobileState();
}

class _MonitorControlMobileState extends State<MonitorControlMobile> {
  final parameterCon = Get.put(ParameterCon());
  final connectionCon = Get.put(ConnectionCon());

  ///档位
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

  Parameter? realTimeDataShow0;
  Parameter? realTimeDataShow1;
  Parameter? realTimeDataShow2;
  Timer? timer;

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
  void dispose() {
    super.dispose();
    bus.off('updateRealParameter');
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return listView();
  }

  Widget listView() {
    return Obx(() => ListView(
          children: listViewItems(),
        ));
  }

  List<Widget> listViewItems() {
    return [
      dashboardWidget(),
      infoWidget(),
      bottomWidget(),
    ];
  }

  Widget dashboardWidget() {
    if (isLandScape()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dashBoardWidget(
              dashValue: firstDashValue.value,
              parameter: dashParameter0!,
              size: (1.sw - getMobileLeftMargin()) / 3.5,
              interval: 20,
              valueFont: 15,
              unitFont: 8),
          dashBoardWidget(
            dashValue: secondDashValue.value,
            parameter: dashParameter1!,
            size: (1.sw - getMobileLeftMargin()) / 3,
            interval: 20,
            valueFont: 20,
            unitFont: 10,
            bottomPadding: 20,
            bottomWidget: Text(
              gear.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Get.theme.focusColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          dashBoardWidget(
              dashValue: thirdDashValue.value,
              parameter: dashParameter2!,
              size: (1.sw - getMobileLeftMargin()) / 3.5,
              interval: 20,
              valueFont: 15,
              unitFont: 8),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dashBoardWidget(
                  dashValue: firstDashValue.value,
                  parameter: dashParameter0!,
                  size: (1.sw - getMobileLeftMargin()) / 2,
                  interval: 20,
                  valueFont: 20,
                  unitFont: 10),
              dashBoardWidget(
                  dashValue: thirdDashValue.value,
                  parameter: dashParameter2!,
                  size: (1.sw - getMobileLeftMargin()) / 2,
                  interval: 20,
                  valueFont: 20,
                  unitFont: 10),
            ],
          ),
          dashBoardWidget(
            dashValue: secondDashValue.value,
            parameter: dashParameter1!,
            size: (1.sw - getMobileLeftMargin()) / 2,
            interval: 20,
            valueFont: 20,
            unitFont: 10,
            bottomPadding: 20,
            bottomWidget: Text(
              gear.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Get.theme.focusColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget infoWidget() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              displayValue(0),
              SizedBox(
                width: 20,
              ),
              displayValue(1),
              SizedBox(
                width: 20,
              ),
              displayValue(2),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
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
                  realTimeDataShow0!.unit),
              rowItem(
                  realTimeDataShow2!.parmName,
                  parameterCon.real_time_data_value[realTimeDataShow2?.motId],
                  realTimeDataShow0!.unit),
            ],
          ),
        ),
      ],
    );
  }

  Widget DashBoard2(double sizeratio) {
    return DashBoard(
      minnum: 0,
      maxnum: 240,
      interval: 20,
      size: (1.sw - getMobileLeftMargin()) / sizeratio,
      endValue: 100,
      bottomPadding: 20,
      centerWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '1',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Get.theme.highlightColor,
            ),
          ),
          Text(
            'Km/h',
            style: TextStyle(
              fontSize: 10,
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
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget DashBoard3(double sizeratio) {
    return DashBoard(
      minnum: 0,
      maxnum: 10,
      interval: 1,
      size: (1.sw - getMobileLeftMargin()) / sizeratio,
      endValue: 5,
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
            'x 1000rpm',
            style: TextStyle(
              fontSize: 8,
              color: Get.theme.highlightColor,
            ),
          ),
        ],
      ),
    );
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

  Widget bottomWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        CustomInput(
          title: 'Battery',
          hint: '',
          readOnly: true,
          width: 1.sw - 40,
          height: 50,
          fieldCon: TextEditingController(
            text: 'Electricity：' +
                (electricity == null
                    ? '0'
                    : (electricity! * 100).toStringAsFixed(0)) +
                '%',
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        CustomInput(
          title: 'Error code',
          hint: '',
          readOnly: true,
          textColor: Get.theme.errorColor,
          width: 1.sw - 40,
          height: 50,
          fieldCon: TextEditingController(
              text: 'ErrorCode：' + (errorCode == null ? '-' : '$errorCode')),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: SfSliderTheme(
            data: SfSliderThemeData(
              activeTrackHeight: 30,
              inactiveTrackHeight: 30,
              activeTrackColor: Get.theme.primaryColor,
              inactiveTrackColor: Get.theme.hintColor,
              trackCornerRadius: 30,
              thumbRadius: 20,
            ),
            child: SfSlider(
              min: Config.acceleratorMin,
              max: Config.acceleratorMax,
              stepSize: 1,
              value: sliderValue.value,
              thumbIcon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Get.theme.focusColor,
                ),
                padding: EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Get.theme.primaryColor,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    sliderValue.value.toStringAsFixed(0),
                    style: TextStyle(
                      color: Get.theme.highlightColor,
                      fontSize: 10,
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
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: gearButtonList(),
        ),
      ],
    );
  }

  List<Widget> gearButtonList() {
    return Config.gearList.map((e) => gearButton(e)).toList();
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
                fontSize: 10,
                color: Get.theme.hintColor,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: amount == null ? '0' : amount.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      color: Get.theme.highlightColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 13,
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

  ///档位
  Widget gearButton(str) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: InkWell(
        onTap: () {
          if (gear.value != str) {
            gear.value = str;
          }
        },
        child: Text(
          str,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color:
                gear.value == str ? Get.theme.focusColor : Get.theme.hintColor,
          ),
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
              isExpanded: true,
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
}
