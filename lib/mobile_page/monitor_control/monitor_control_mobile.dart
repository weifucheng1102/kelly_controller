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
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MonitorControlMobile extends StatefulWidget {
  const MonitorControlMobile({Key? key}) : super(key: key);

  @override
  State<MonitorControlMobile> createState() => _MonitorControlMobileState();
}

class _MonitorControlMobileState extends State<MonitorControlMobile> {
  ///档位
  RxString gear = ''.obs;
  RxDouble sliderValue = 0.0.obs;

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
          DashBoard1(3.5),
          DashBoard2(3),
          DashBoard3(3.5),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashBoard1(2),
              DashBoard3(2),
            ],
          ),
          DashBoard2(2),
        ],
      );
    }
  }

  Widget infoWidget() {
    return Container(
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
          rowItem('Rotating speed', '80', 'Km/h'),
          rowItem('Voltage', '200', 'V'),
          rowItem('Current', '10', ' A'),
        ],
      ),
    );
  }

  Widget DashBoard1(double sizeratio) {
    return DashBoard(
      minnum: 0,
      maxnum: 200,
      interval: 20,
      size: (1.sw - getMobileLeftMargin()) / sizeratio,
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
            'Km/A',
            style: TextStyle(
              fontSize: 8,
              color: Get.theme.highlightColor,
            ),
          ),
        ],
      ),
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

  Widget bottomWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        CustomPopMenu(
          title: 'Battery',
          width: 1.sw - 40,
          height: 50,
          value: null,
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
          fieldCon: TextEditingController(text: 'ErrorCode：2021'),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: SfSliderTheme(
            data: SfSliderThemeData(
              activeTrackHeight: 25,
              inactiveTrackHeight: 25,
              activeTrackColor: Get.theme.primaryColor,
              inactiveTrackColor: Get.theme.hintColor,
              trackCornerRadius: 25,
              thumbRadius: 15,
            ),
            child: SfSlider(
              min: 0,
              max: 5,
              stepSize: 1,
              value: sliderValue.value,
              thumbIcon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Get.theme.focusColor,
                ),
                padding: EdgeInsets.all(4),
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
                      fontSize: 18,
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
          children: [
            gearButton('R'),
            gearButton('N'),
            gearButton('D'),
          ],
        ),
      ],
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
                fontSize: 10,
                color: Get.theme.hintColor,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: amount,
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
}
