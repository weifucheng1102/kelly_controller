import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/controller/connection_con.dart';
import 'package:libserialport/libserialport.dart';

import '../../common/common.dart';
import '../../config/config.dart';

class Serial extends StatefulWidget {
  const Serial({Key? key}) : super(key: key);

  @override
  State<Serial> createState() => _SerialState();
}

class _SerialState extends State<Serial> {
  double menuWidth() => 682.w;
  double menuHeight() => 66.h;
  double spaceHeight() => 30.w;

  ConnectionCon connectionCon = Get.put(ConnectionCon());

  List portList = [];
  String? selectPort;
  TextEditingController baudRateCon = TextEditingController(text: '19200');
  TextEditingController bitsCon = TextEditingController(text: '8');
  TextEditingController stopBitsCon = TextEditingController(text: '1');
  TextEditingController parityCon = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    portList = SerialPort.availablePorts;

    ///判断port 是否开启
    //
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: ScrollController(),
      children: [
        Column(
          children: [
            CustomPopMenu(
              width: menuWidth(),
              height: menuHeight(),
              title: 'Port',
              hint: 'Please enter the content here',
              value: null,
              items:
                  portList.map((e) => MenuItems(label: e, value: e)).toList(),
              valueChanged: (res) {
                selectPort = res;
              },
            ),
            SizedBox(height: 30.h),
            CustomInput(
              title: 'baudRate',
              hint: 'Please enter the content here',
              readOnly: true,
              fieldCon: baudRateCon,
              width: menuWidth(),
              height: menuHeight(),
            ),
            SizedBox(height: spaceHeight()),
            CustomInput(
              title: 'parity',
              hint: 'Please enter the content here',
              readOnly: true,
              fieldCon: parityCon,
              width: menuWidth(),
              height: menuHeight(),
            ),
            SizedBox(height: spaceHeight()),
            CustomInput(
              title: 'stopBits',
              hint: 'Please enter the content here',
              readOnly: true,
              fieldCon: stopBitsCon,
              width: menuWidth(),
              height: menuHeight(),
            ),
            SizedBox(height: spaceHeight()),
            CustomInput(
              title: 'bits',
              hint: 'Please enter the content here',
              readOnly: true,
              fieldCon: bitsCon,
              width: menuWidth(),
              height: menuHeight(),
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Scin',
                  width: buttonWidth(),
                  height: buttonHeight(),
                  onTap: () {
                    print(connectionCon.port);
                    connectionCon.port!
                        .write(Uint8List.fromList([0x5a]), timeout: 0);

                    // int a = connectionCon.port!.write(
                    //   Uint8List.fromList(
                    //       "hello1  hello2  hello3 hello4  hello5 ".codeUnits),
                    //   timeout: 0);
                  },
                ),
                const SizedBox(width: 30),
                CustomButton(
                  text: 'Connect',
                  width: buttonWidth(),
                  height: buttonHeight(),
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  bgColor: Get.theme.primaryColor,
                  onTap: () async {
                    if (selectPort == null) {
                      return;
                    }
                    connectionCon.portOpenAction(
                      portName: selectPort!,
                      baudRate: int.parse(baudRateCon.text),
                      bits: int.parse(bitsCon.text),
                      stopBits: int.parse(stopBitsCon.text),
                      paryty: int.parse(parityCon.text),
                    );
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
