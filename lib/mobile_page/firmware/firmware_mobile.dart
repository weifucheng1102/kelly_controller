import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/app_bar_mobile.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_select_button.dart';
import 'package:kelly_user_project/config/config.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/connection_con.dart';

class FirmwareMobile extends StatefulWidget {
  const FirmwareMobile({Key? key}) : super(key: key);

  @override
  State<FirmwareMobile> createState() => _FirmwareMobileState();
}

class _FirmwareMobileState extends State<FirmwareMobile> {
  PlatformFile? file;
  final connectionCon = Get.put(ConnectionCon());
  int stepIndex = 1;
  @override
  void initState() {
    super.initState();
    bus.on('updateFirmware', (arg) {
      stepIndex++;
      updateFirmware();
    });
  }

  updateFirmware() {
    switch (stepIndex) {
      case 1:
        //connectionCon.firmware_opdate_erase();
        break;
      case 2:
        //connectionCon.firmware_opdate_write_init();
        break;
        // case 3:
        //   connectionCon.firmware_opdate_erase();
        //   break;
        // case 4:
        //   connectionCon.firmware_opdate_erase();
        //   break;
        // case 5:
        //   connectionCon.firmware_opdate_erase();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = 1.sw - getMobileLeftMargin() - 60.w;
    double height = 50;
    double spaceHeight = 26;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isLandScape() ? const AppBarMobile(title: 'Firmware') : null,
      body: SafeArea(
        left: false,
        right: false,
        child: ListView(
          padding: EdgeInsets.only(top: 19, bottom: 20),
          children: [
            Column(
              children: [
                CustomInput(
                  title: 'Factory serial number',
                  hint: 'content here',
                  readOnly: false,
                  width: width,
                  height: height,
                ),
                SizedBox(
                  height: spaceHeight,
                ),
                CustomInput(
                  title: 'Factory serial number',
                  hint: 'content here',
                  readOnly: false,
                  width: width,
                  height: height,
                ),
                SizedBox(
                  height: spaceHeight,
                ),
                CustomInput(
                  title: 'Factory serial number',
                  hint: 'content here',
                  readOnly: false,
                  width: width,
                  height: height,
                ),
                SizedBox(
                  height: spaceHeight,
                ),
                CustomInput(
                  title: 'Version number',
                  hint: 'content here',
                  readOnly: false,
                  width: width,
                  height: height,
                ),
                SizedBox(
                  height: spaceHeight,
                ),
                CustomSelectButton(
                  width: width,
                  height: height,
                  title: 'Select File',
                  text: file == null
                      ? 'Please enter the content here'
                      : file!.name,
                  textColor: file == null ? null : Get.theme.highlightColor,
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      dialogTitle: 'Select File',
                    );

                    if (result != null && result.files.isNotEmpty) {
                      file = result.files.first;
                      setState(() {});
                    }
                  },
                ),
                SizedBox(
                  height: 125,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'Verfy',
                      width: 166,
                      height: 50,
                      onTap: () {
                        updateFirmware();
                      },
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      text: 'Program',
                      width: 166,
                      height: 50,
                      bgColor: Get.theme.primaryColor,
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
