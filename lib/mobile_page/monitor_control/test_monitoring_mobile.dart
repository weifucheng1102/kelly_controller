import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/dash_board.dart';

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
              width: 1.sw - 40,
              height: 50,
              fieldCon: TextEditingController(text: 'ErrorCode：2021'),
            ),
          ],
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
          size: 1.sw / 2,
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
          size: 1.sw / 2,
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
          size: 1.sw / 2,
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
          size: 1.sw / 2,
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
