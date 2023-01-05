import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class BatteryView extends StatefulWidget {
  final double electricQuantity;

  BatteryView({
    Key? key,
    required this.electricQuantity,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BatteryViewState();
  }
}

class BatteryViewState extends State<BatteryView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
          size: Size(50.w, 25.w),
          painter:
              BatteryViewPainter(electricQuantity: widget.electricQuantity)),
    );
  }
}

class BatteryViewPainter extends CustomPainter {
  double electricQuantity;
  Paint? mPaint;
  double mStrokeWidth = 1.0;
  double mPaintStrokeWidth = 1.5;

  BatteryViewPainter({required this.electricQuantity}) {
    this.electricQuantity = electricQuantity;
    mPaint = Paint()..strokeWidth = mPaintStrokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //电池头部位置
    double batteryHeadLeft = 0;
    double batteryHeadTop = size.height / 4;
    double batteryHeadRight = size.width / 15;
    double batteryHeadBottom = batteryHeadTop + (size.height / 2);

    //电池框位置
    double batteryLeft = batteryHeadRight + mStrokeWidth;
    double batteryTop = 0;
    double batteryRight = size.width;
    double batteryBottom = size.height;

    //电量位置
    double electricQuantityTotalWidth =
        size.width - batteryHeadRight - 4 * mStrokeWidth; //电池减去边框减去头部剩下的宽度

    double electricQuantityLeft = batteryHeadRight +
        2 * mStrokeWidth +
        electricQuantityTotalWidth * (1 - electricQuantity);
    double electricQuantityTop = mStrokeWidth * 2;
    double electricQuantityRight = size.width - 2 * mStrokeWidth;
    double electricQuantityBottom = size.height - 2 * mStrokeWidth;

    mPaint!.style = PaintingStyle.fill;
    mPaint!.color = Get.theme.primaryColor;
    //画电池头部
    canvas.drawRRect(
        RRect.fromLTRBR(batteryHeadLeft, batteryHeadTop, batteryHeadRight,
            batteryHeadBottom, Radius.circular(mStrokeWidth)),
        mPaint!);
    mPaint!.style = PaintingStyle.stroke;
    //画电池框
    canvas.drawRRect(
        RRect.fromLTRBR(batteryLeft, batteryTop, batteryRight, batteryBottom,
            Radius.circular(mStrokeWidth)),
        mPaint!);
    mPaint!.style = PaintingStyle.fill;
    mPaint!.color = Get.theme.primaryColor;
    //画电池电量
    canvas.drawRRect(
        RRect.fromLTRBR(
            electricQuantityLeft,
            electricQuantityTop,
            electricQuantityRight,
            electricQuantityBottom,
            Radius.circular(mStrokeWidth)),
        mPaint!);
  }

  @override
  bool shouldRepaint(BatteryViewPainter other) {
    return true;
  }
}
