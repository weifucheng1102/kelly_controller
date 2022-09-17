import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:libserialport/libserialport.dart';

class ConnectionCon extends GetxController {
  SerialPort? port;
  String? connectPort;

  List<int> readerData = [];

  Timer? timers;
  int millsecondtime = 500;

  portOpenAction({
    required String portName,
    required int baudRate,
    required int bits,
    required int stopBits,
    required int paryty,
  }) async {
    if (port != null && port!.isOpen) {
      port!.close();
    }
    port = SerialPort(portName);
    port!.config.baudRate = baudRate;
    port!.config.bits = bits;
    port!.config.stopBits = stopBits;
    port!.config.parity = paryty;
    port!.open(mode: 3);
    connectPort = portName;
    print('串口是否开启${port!.isOpen}');
    final reader = SerialPortReader(port!, timeout: 50000);
    reader.stream.listen((data) {
      if (millsecondtime > 0) {
        readerData = readerData + data;
        print('1');
      } else {
        readerData = data;
        print('2');
      }

      millsecondtime = 500;
      if (timers != null) {
        timers!.cancel();
      }
      timers = Timer.periodic(Duration(microseconds: 10), (timer) {
        millsecondtime = millsecondtime - 10;
        if (millsecondtime <= 0) {
          timers!.cancel();
          String string = String.fromCharCodes(readerData);
          print('received: $string');
      
        }
      });
    });
  }

  // int a = port!.write(
  //                       Uint8List.fromList(
  //                           "hello1  hello2  hello3 hello4  hello5 ".codeUnits),
  //                       timeout: 0);

}
