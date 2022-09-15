import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';

class Serial extends StatefulWidget {
  const Serial({Key? key}) : super(key: key);

  @override
  State<Serial> createState() => _SerialState();
}

class _SerialState extends State<Serial> {
  SerialPort? port;
  List portList = [];
  String? selectPort;
  TextEditingController baudRateCon = TextEditingController(text: '9600');
  TextEditingController bitsCon = TextEditingController(text: '8');
  TextEditingController stopBitsCon = TextEditingController(text: '1');
  TextEditingController parityCon = TextEditingController(text: 'none');
  @override
  void initState() {
    super.initState();
    portList = SerialPort.availablePorts;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 128),
      children: [
        Column(
          children: [
            CustomPopMenu(
              width: 682,
              height: 66,
              title: 'Port',
              hint: 'Please ebter the content here',
              value: null,
              items: portList.map((e) => MenuItem(label: e, value: e)).toList(),
              valueChanged: (res) {
                selectPort = res;
              },
            ),
            SizedBox(height: 43),
            CustomInput(
              title: 'baudRate',
              hint: 'Please ebter the content here',
              readOnly: true,
              fieldCon: baudRateCon,
              width: 682,
              height: 66,
            ),
            SizedBox(height: 43),
            CustomInput(
              title: 'parity',
              hint: 'Please ebter the content here',
              readOnly: true,
              fieldCon: parityCon,
              width: 682,
              height: 66,
            ),
            SizedBox(height: 43),
            CustomInput(
              title: 'stopBits',
              hint: 'Please ebter the content here',
              readOnly: true,
              fieldCon: stopBitsCon,
              width: 682,
              height: 66,
            ),
            SizedBox(height: 43),
            CustomInput(
              title: 'bits',
              hint: 'Please ebter the content here',
              readOnly: true,
              fieldCon: bitsCon,
              width: 682,
              height: 66,
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Scin',
                  width: 165,
                  height: 64,
                  onTap: () {
                    int a = port!.write(Uint8List.fromList("hello  hello  hello hello  hello ".codeUnits),
                        timeout: 0);
                  },
                ),
                const SizedBox(width: 30),
                CustomButton(
                  text: 'Connect',
                  width: 165,
                  height: 64,
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  bgColor: Get.theme.primaryColor,
                  onTap: () {
                    if (selectPort == null) {
                      return;
                    }
                    port = SerialPort(selectPort!);
                    port!.config.baudRate = int.parse(baudRateCon.text);
                    port!.config.bits = int.parse(bitsCon.text);
                    port!.config.stopBits = int.parse(stopBitsCon.text);
                    port!.config.parity = 0;
                    if (!port!.isOpen) {
                      port!.open(mode: 3);
                    }
                    print('串口是否开启${port!.isOpen}');

                    final reader = SerialPortReader(port!, timeout: 50000);
                    reader.stream.listen((data) {
                      String string = String.fromCharCodes(data);

                      print('received: $string');
                    });
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
