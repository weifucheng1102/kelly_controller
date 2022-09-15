import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';

class SerialMobile extends StatefulWidget {
  const SerialMobile({Key? key}) : super(key: key);

  @override
  State<SerialMobile> createState() => _SerialMobileState();
}

class _SerialMobileState extends State<SerialMobile> {
  @override
  Widget build(BuildContext context) {
    double width = 1.sw - getMobileLeftMargin() - 60.w;
    double height = 50;
    return ListView(
      padding: const EdgeInsets.only(top: 26),
      children: [
        Column(
          children: [
            CustomPopMenu(
              width: width,
              height: height,
              title: 'Port',
              hint: 'Please ebter the content here',
              value: null,
              items: [
                MenuItem(label: '111', value: 1),
                MenuItem(label: '222', value: 2),
                MenuItem(label: '333333333333', value: 3),
                MenuItem(label: '444', value: 4),
              ],
            ),
            SizedBox(height: 26),
            CustomPopMenu(
              width: width,
              height: height,
              title: 'Set1',
              hint: 'Please ebter the content here',
              value: 2,
              items: [
                MenuItem(label: '111', value: 1),
                MenuItem(label: '222', value: 2),
                MenuItem(label: '333333333333', value: 3),
                MenuItem(label: '444', value: 4),
              ],
            ),
            SizedBox(height: 26),
            CustomPopMenu(
              width: width,
              height: height,
              title: 'Set2',
              hint: 'Please ebter the content here',
              value: 2,
              items: [
                MenuItem(label: '111', value: 1),
                MenuItem(label: '222', value: 2),
                MenuItem(label: '333333333333', value: 3),
                MenuItem(label: '444', value: 4),
              ],
            ),
            const SizedBox(height: 125),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomButton(
                  text: 'Scin',
                  width: 166,
                  height: 50,
                ),
                const SizedBox(width: 12),
                CustomButton(
                  text: 'Connect',
                  width: 166,
                  height: 50,
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  bgColor: Get.theme.primaryColor,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
