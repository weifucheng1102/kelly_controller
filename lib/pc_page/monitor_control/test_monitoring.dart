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
      padding: EdgeInsets.only(left: 320.w),
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
                          'Km/A',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Get.theme.highlightColor,
                          ),
                        ),
                      ],
                    ),
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
                          'Km/A',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Get.theme.highlightColor,
                          ),
                        ),
                      ],
                    ),
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
                          'Km/A',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Get.theme.highlightColor,
                          ),
                        ),
                      ],
                    ),
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
                          'Km/A',
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
                height: 20.h,
              ),
              Wrap(
                spacing: 20.w,
                runSpacing: 20.h,
                children: bottomItems(),
              ),
              // Expanded(
              //   child: GridView.builder(
              //     padding: EdgeInsets.symmetric(horizontal: 50.w),
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 7,
              //       mainAxisSpacing: 20,
              //       crossAxisSpacing: 20,
              //       childAspectRatio: (1.sw - 320.w - 100) / 7 / 115,
              //     ),
              //     itemBuilder: (context, index) {
              //       return CustomPopMenu(
              //           title: index.toString(),
              //           width: (1.sw - 320.w - 100) / 7,
              //           height: 66,
              //           value: index);
              //     },
              //     itemCount: 28,
              //   ),
              // ),
            ],
          ))
        ],
      ),
    );
  }

  List<Widget> bottomItems() {
    List<Widget> list = [];
    for (var i = 0; i < 28; i++) {
      list.add(CustomPopMenu(
          title: i.toString(), width: 200, height: 66.h, value: i));
    }
    return list;
  }
}
