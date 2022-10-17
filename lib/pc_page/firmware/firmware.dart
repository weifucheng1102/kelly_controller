import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/back_widget.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/custom_select_button.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';

class Firmware extends StatefulWidget {
  const Firmware({Key? key}) : super(key: key);

  @override
  State<Firmware> createState() => _FirmwareState();
}

class _FirmwareState extends State<Firmware> {
  bool canClick = true;

  PlatformFile? file;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(
              height: 70.h,
            ),
            Text(
              'Version Information',
              style: TextStyle(
                fontSize: 20,
                color: Get.theme.hintColor,
              ),
            ),
            SizedBox(
              height: 38.h,
            ),
            CustomInput(
              title: 'name',
              hint: 'content here',
              readOnly: false,
              width: 462.w,
              height: 66.h,
              onTap: () async {},
            ),
            SizedBox(
              height: 38.h,
            ),
            CustomInput(
              title: 'Production Date',
              hint: 'content here',
              readOnly: false,
              width: 462.w,
              height: 66.h,
              onTap: () async {},
            ),
            SizedBox(
              height: 38.h,
            ),
            CustomInput(
              title: 'serial number',
              hint: 'content here',
              readOnly: false,
              width: 462.w,
              height: 66.h,
              onTap: () async {},
            ),
            SizedBox(height: 38.h),
            CustomSelectButton(
              width: 462.w,
              height: 66.h,
              title: 'Select File',
              text: file == null ? 'Please enter the content here' : file!.name,
              textColor: file == null ? null : Get.theme.highlightColor,
              onTap: () async {
                if (canClick) {
                  canClick = false;
                  PlatformFile? selectFile = await ParameterCon().readFile();
                  if (selectFile != null) {
                    file = selectFile;
                  }
                  canClick = true;
                  setState(() {});
                }
              },
            ),
            SizedBox(height: 57.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Verfy',
                  width: 165.w,
                  height: 64.h,
                ),
                SizedBox(width: 30.w),
                CustomButton(
                  text: 'Program',
                  width: 165.w,
                  height: 64.h,
                  bgColor: Get.theme.primaryColor,
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  onTap: () async {
                    if (file != null) {
                      String contents = await File(file!.path!).readAsString();
                      print('读取到文件内容：' + contents);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
