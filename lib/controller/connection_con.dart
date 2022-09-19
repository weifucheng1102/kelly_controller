import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:libserialport/libserialport.dart';

class ConnectionCon extends GetxController {
  SerialPort? port;
  String? connectPort;

  List<int> readerData = [];

  Timer? timers;
  int millsecondtime = 500;

  ///打开串口
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
      ///插件bug  收数据有时候会通过两次收到完整数据 处理了数据500ms 以内接受的数据拼成一个完整的数据
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
      timers = Timer.periodic(const Duration(microseconds: 10), (timer) {
        millsecondtime = millsecondtime - 10;
        if (millsecondtime <= 0) {
          timers!.cancel();
          // String string = String.fromCharCodes(readerData);
          // print('received: $string');
          pushNotice(Uint8List.fromList(readerData));
        }
      });
    });
  }

  ///发送通知 去更新
  pushNotice(Uint8List uint8list) {
    print(uint8list);
    print(uint8list.first.toRadixString(16));
    ///修改仪表 的测试指令
    if (uint8list.first.toRadixString(16) == 'f1') {
      bus.emit('control', Uint8List.sublistView(uint8list, 2, 5));
    }

    ///修改参数的 测试指令 （测试16个数据）
    if (uint8list.first.toRadixString(16) == 'f2') {
      bus.emit(
          'updateParameterWithSerial', Uint8List.sublistView(uint8list, 2, 18));
    }
    // Uint8List sublist = Uint8List.sublistView(uint8list, 2, 5);
    // print(readerData);
    // print(uint8list);
    // int m = hexToInt(sublist.first.toString());
    // print(m);
  }
}
