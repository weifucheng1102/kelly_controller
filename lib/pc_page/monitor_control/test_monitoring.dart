import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/back_widget.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/dash_board.dart';
import 'package:kelly_user_project/config/config.dart';

class TestMonitoring extends StatefulWidget {
  const TestMonitoring({Key? key}) : super(key: key);

  @override
  State<TestMonitoring> createState() => _TestMonitoringState();
}

class _TestMonitoringState extends State<TestMonitoring> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Config.left_menu_margin),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 90, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Error code',
                  style: TextStyle(
                    fontSize: 20,
                    color: Get.theme.hintColor,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                BackWidget(
                  width: 322,
                  height: 66,
                  child: TextFormField(
                    controller: TextEditingController(text: 'errorcode:2022'),
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      // hintText: widget.hint,
                    ),
                    style: TextStyle(
                      color: Get.theme.errorColor,
                      fontSize: 20,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashBoard(
                minnum: 0,
                maxnum: 200,
                size: 264,
                interval: 20,
                endValue: 100,
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
              DashBoard(
                minnum: 0,
                maxnum: 200,
                size: 264,
                interval: 20,
                endValue: 100,
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
              DashBoard(
                minnum: 0,
                maxnum: 200,
                size: 264,
                interval: 20,
                endValue: 100,
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
              DashBoard(
                minnum: 0,
                maxnum: 200,
                size: 264,
                interval: 20,
                endValue: 100,
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
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 50),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio:
                    (1.sw - Config.left_menu_margin - 100) / 7 / 115,
              ),
              itemBuilder: (context, index) {
                return CustomPopMenu(
                    title: index.toString(),
                    width: (1.sw - Config.left_menu_margin - 100) / 7,
                    height: 66,
                    value: index);
              },
              itemCount: 28,
            ),
          ),
        ],
      ),
    );
  }
}
