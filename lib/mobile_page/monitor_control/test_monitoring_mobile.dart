import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/dash_board.dart';
import 'package:kelly_user_project/config/config.dart';

import '../../common/common.dart';

class TestMonitoringMobile extends StatefulWidget {
  const TestMonitoringMobile({Key? key}) : super(key: key);

  @override
  State<TestMonitoringMobile> createState() => _TestMonitoringMobileState();
}

class _TestMonitoringMobileState extends State<TestMonitoringMobile> {
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
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isLandScape() ? 3 : 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio:
                (1.sw - getMobileLeftMargin()) / (isLandScape() ? 3 : 2) / 115,
          ),
          itemBuilder: (context, index) {
            return CustomPopMenu(
                title: index.toString(),
                width: (1.sw - getMobileLeftMargin()) / (isLandScape() ? 3 : 2),
                height: 50,
                value: index);
          },
          itemCount: 28,
        ),
      ],
    );
  }

  Widget dashboardWidget() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: [
        DashBoard(
          minnum: 0,
          maxnum: 200,
          interval: 20,
          size: (1.sw - getMobileLeftMargin()) / 2,
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
        ),
        DashBoard(
          minnum: 0,
          maxnum: 200,
          interval: 20,
          size: (1.sw - getMobileLeftMargin()) / 2,
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
        ),
        DashBoard(
          minnum: 0,
          maxnum: 200,
          interval: 20,
          size: (1.sw - getMobileLeftMargin()) / 2,
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
        ),
        DashBoard(
          minnum: 0,
          maxnum: 200,
          interval: 20,
          size: (1.sw - getMobileLeftMargin()) / 2,
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
        ),
      ],
    );
  }
}
