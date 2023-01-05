import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intel_hex/intel_hex.dart';
import 'package:intel_hex/intel_hex.dart';
import 'package:kelly_user_project/common/back_widget.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/custom_select_button.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/connection_con.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';

import '../../config/config.dart';

class Firmware extends StatefulWidget {
  const Firmware({Key? key}) : super(key: key);

  @override
  State<Firmware> createState() => _FirmwareState();
}

class _FirmwareState extends State<Firmware> {
  ///更新固件步骤（-2:擦除，-1:写入init, 0,1,2,3.....:固件步骤）;
  ///update_stepIndex 不能大于数组数量
  int update_stepIndex = -3;

  bool canClick = true;
  final connectionCon = Get.put(ConnectionCon());

  PlatformFile? file;
  int fileByteLength = 0;

  List? fileDataList;
  int? startAddress;
  @override
  void dispose() {
    super.dispose();
    bus.off('updateFirmware');
  }

  @override
  void initState() {
    super.initState();

    bus.on('updateFirmware', (arg) {
      updateFirmware();
    });
  }

  updateFirmware() {
    update_stepIndex++;
    if (update_stepIndex == -2) {
      connectionCon.firmware_opdate_erase(startAddress!, fileByteLength);
    } else if (update_stepIndex == -1) {
      connectionCon.firmware_opdate_write_init(startAddress!, fileByteLength);
    } else {
      if (update_stepIndex < fileDataList!.length) {
        Future.delayed(Duration(seconds: 3), () {
          connectionCon
              .firmware_opdate_write_repeat(fileDataList![update_stepIndex]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: left_menu_margin()),
      child: ListView(
        children: [
          SizedBox(
            height: 70.h,
          ),
          Center(
            child: Text(
              'Version Information',
              style: TextStyle(
                fontSize: 20,
                color: Get.theme.hintColor,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
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
                    CustomInput(
                      title: 'version number',
                      hint: 'content here',
                      readOnly: false,
                      width: 462.w,
                      height: 66.h,
                      onTap: () async {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 38.h,
                    ),
                    CustomSelectButton(
                      width: 462.w,
                      height: 66.h,
                      title: 'Select File',
                      text: file == null
                          ? 'Please enter the content here'
                          : file!.name,
                      textColor: file == null ? null : Get.theme.highlightColor,
                      onTap: () async {
                        if (canClick) {
                          canClick = false;
                          PlatformFile? selectFile = await firmwareReadFile();
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
                          width: buttonWidth(),
                          height: buttonHeight(),
                          onTap: () {
                            if (file != null) {
                              verfyFile();
                            }
                          },
                        ),
                        SizedBox(width: 30.w),
                        CustomButton(
                          text: 'Program',
                          width: buttonWidth(),
                          height: buttonHeight(),
                          bgColor: Get.theme.primaryColor,
                          borderWidth: 0,
                          borderColor: Colors.transparent,
                          onTap: () async {
                            if (fileDataList != null) {
                              updateFirmware();
                              // connectionCon.firmware_opdate_erase(
                              //     startAddress!, fileByteLength);
                              // connectionCon.firmware_opdate_write_init(
                              //     startAddress!, fileByteLength);

                              // connectionCon.firmware_opdate_write_repeat(
                              //     fileDataList![0]);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  verfyFile() {
    try {
      final fileData = File(file!.path!).readAsStringSync();
      var hex = IntelHexFile.fromString(fileData);
//77824
      startAddress = hex.segments.first.address;
      fileByteLength = hex.segments.first.byteData.buffer.lengthInBytes;
      fileDataList =
          constructList(32, hex.segments.first.byteData.buffer.asUint8List());
      print(hex.segments.first.address);

      print(hex.segments.first.endAddress);
      print(fileByteLength);
      print(hex.segments.first.byteData.buffer.asUint8List().length);
      // connectionCon.firmware_opdate_erase(
      //     hex.segments.first.address, file!.size);

      // for (final seg in hex.segments) {
      //   //print(seg.address);
      //   //print(seg.endAddress);
      //   //print(seg.byteData.buffer.lengthInBytes);
      //   // for (var i = seg.address; i < count; i++) {

      //   // }

      //   print(seg.byteData.buffer.asUint8List(0, 16));
      // }

    } catch (e) {}
  }
}
