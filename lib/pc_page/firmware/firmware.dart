import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              height: 70,
            ),
            Text(
              'Version Information',
              style: TextStyle(
                fontSize: 20,
                color: Get.theme.hintColor,
              ),
            ),
            SizedBox(
              height: 38,
            ),
            CustomInput(
              title: 'name',
              hint: 'content here',
              readOnly: false,
              width: 462,
              height: 66,
              onTap: () async {},
            ),
            SizedBox(
              height: 38,
            ),
            CustomInput(
              title: 'Production Date',
              hint: 'content here',
              readOnly: false,
              width: 462,
              height: 66,
              onTap: () async {},
            ),
            SizedBox(
              height: 38,
            ),
            CustomInput(
              title: 'serial number',
              hint: 'content here',
              readOnly: false,
              width: 462,
              height: 66,
              onTap: () async {},
            ),
            SizedBox(height: 38),
            CustomSelectButton(
              width: 462,
              height: 66,
              title: 'Select File',
              text: file == null ? 'Please enter the content here' : file!.name,
              textColor: file == null ? null : Get.theme.highlightColor,
              onTap: () async {
                if (canClick) {
                  canClick = false;
                 PlatformFile? selectFile = await ParameterCon().readFile();
                 if (selectFile!=null) {
                   file = selectFile;
                 }
                  canClick = true;
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 57),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomButton(
                  text: 'Verfy',
                  width: 165,
                  height: 64,
                ),
                const SizedBox(width: 30),
                CustomButton(
                  text: 'Program',
                  width: 165,
                  height: 64,
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
