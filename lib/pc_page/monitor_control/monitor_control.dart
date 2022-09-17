import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/dash_board.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MonitorControl extends StatefulWidget {
  const MonitorControl({Key? key}) : super(key: key);

  @override
  State<MonitorControl> createState() => _MonitorControlState();
}

class _MonitorControlState extends State<MonitorControl> {
  RxBool showFilter = false.obs;

  ///档位
  RxString gear = ''.obs;
  RxDouble sliderValue = 0.0.obs;
  RxDouble firstDashValue = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: 100),
      child: Obx(
        () => Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widgetList(),
              ),
            ),
            _filterButton(),
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
                fontSize: 20,
                color: Get.theme.hintColor,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: amount,
                    style: TextStyle(
                      fontSize: 60,
                      color: Get.theme.highlightColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 26,
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
            size: showFilter.value ? 198 : 264,
            endValue: firstDashValue.value,
            centerWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.highlightColor,
                  ),
                ),
                Text(
                  'Km/A',
                  style: TextStyle(
                    fontSize: 10,
                    color: Get.theme.highlightColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 25,
          ),
          DashBoard(
            minnum: 0,
            maxnum: 240,
            size: showFilter.value ? 288 : 385,
            interval: 20,
            bottomPadding: 23,
            endValue: 110,
            centerWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.highlightColor,
                  ),
                ),
                Text(
                  'Km/h',
                  style: TextStyle(
                    fontSize: 13,
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
                fontSize: 52,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          DashBoard(
            maxnum: 10,
            minnum: 0,
            interval: 1,
            endValue: 5,
            size: showFilter.value ? 198 : 264,
            centerWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.highlightColor,
                  ),
                ),
                Text(
                  'x 1000rpm',
                  style: TextStyle(
                    fontSize: 10,
                    color: Get.theme.highlightColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Container(
        width: 664,
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomPopMenu(
            title: 'Battery',
            width: 472,
            height: 66,
            value: null,
          ),
          const SizedBox(
            width: 95,
          ),
          CustomInput(
            title: 'Error code',
            hint: '',
            readOnly: true,
            textColor: Get.theme.errorColor,
            width: 472,
            height: 66,
            fieldCon: TextEditingController(text: 'ErrorCode：2021'),
          ),
        ],
      ),
    ];
    if (showFilter.value) {
      list.addAll([
        Container(
          width: 606,
          child: SfSliderTheme(
            data: SfSliderThemeData(
              activeTrackHeight: 50,
              inactiveTrackHeight: 50,
              activeTrackColor: Get.theme.primaryColor,
              inactiveTrackColor: Get.theme.hintColor,
              trackCornerRadius: 25,
              thumbRadius: 30,
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
                      fontSize: 30,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gearButton('R'),
            gearButton('N'),
            gearButton('D'),
          ],
        ),
      ]);
    }
    return list;
  }

  Widget _filterButton() {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        showFilter.value = !showFilter.value;
        setState(() {});
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
              'Hide',
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

  ///档位
  Widget gearButton(str) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: InkWell(
        onTap: () {
          firstValueChange(100);

          if (gear.value != str) {
            gear.value = str;
          }
        },
        child: Text(
          str,
          style: TextStyle(
            fontSize: 37,
            fontWeight: FontWeight.bold,
            color:
                gear.value == str ? Get.theme.focusColor : Get.theme.hintColor,
          ),
        ),
      ),
    );
  }

  firstValueChange(int newCount) async {
    int oldValue = firstDashValue.value.toInt();

    if (newCount > oldValue) {
      for (var i = oldValue; i < newCount; i++) {
        firstDashValue.value = i.toDouble();
        await Future.delayed(const Duration(milliseconds: 1));
      }
    } else if (newCount < oldValue) {
      for (var i = oldValue; i > newCount; i--) {
        firstDashValue.value = i.toDouble();
        await Future.delayed(const Duration(milliseconds: 1));
      }
    }
  }
}
