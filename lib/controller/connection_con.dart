import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';
import 'package:libserialport/libserialport.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/config/event.dart';

class ConnectionCon extends GetxController {
  SerialPort? port;
  String? connectPort;

  List<int> readerData = [];

  Timer? timers;
  int millsecondtime = 100;

  BluetoothConnection? bluetoothConnection;

  final parameterCon = Get.put(ParameterCon());

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
    port!.openReadWrite();
    print(baudRate);
    print(bits);
    print(stopBits);

    port!.config = SerialPortConfig()
      ..baudRate = baudRate
      ..parity = SerialPortParity.none
      ..bits = bits
      ..stopBits = stopBits
      ..setFlowControl(SerialPortFlowControl.none);

    print('串口是否开启${port!.isOpen}');

    final reader = SerialPortReader(port!, timeout: 50000);

    ///数据监听
    reader.stream.listen(_receiveData);
  }

  ///发送通知 去更新
  pushNotice(Uint8List uint8list) {
    print('接收数据');
    print(uint8list);
    uint8list.forEach((element) {
      print(element.toRadixString(16));
    });

    ///获取命令
    if (uint8list.length <= 1) {
      return;
    }
    String radix16String = uint8list[1].toRadixString(16);
    //print(radix16String);

    ///读取参数信息
    if (radix16String == 'd1') {
      ///参数值传过去  ：演示： 更新参数id 为275
      updateParameterWithSerial(getRealNumber(Uint8List.sublistView(
        uint8list,
        uint8list.length - 4,
        uint8list.length,
      )));
    }

    ///写入参数成功
    if (radix16String == 'd2') {
      bus.emit('updateParameterSuccess');
      // if (uint8list.join(',') == '98,1,0,99') {
      //   print('写入成功');
      //   bus.emit('updateParameterSuccess');
      // } else {
      //   print('写入失败');
      // }
    }

    ///刷新固件
    if ((uint8list[0].toRadixString(16) == '5a' &&
            uint8list[1].toRadixString(16) == 'a1') ||
        (uint8list[0].toRadixString(16) == 'a1')) {
      print('发送 5a a1');
      port!.write(Uint8List.fromList([0x5a, 0xa1]), timeout: 0);

      bus.emit('updateFirmware');
    }
  }

  blueConnect(String address) {
    BluetoothConnection.toAddress(address).then((_connection) {
      print('Connected to the device');
      bluetoothConnection = _connection;
      bluetoothConnection!.input!.listen(_receiveData);
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  ///收到指令
  _receiveData(Uint8List data) {
    // print(data);

    //插件bug  收数据有时候会通过两次收到完整数据 处理了数据50ms 以内接受的数据拼成一个完整的数据
    if (millsecondtime > 0) {
      readerData = readerData + data;
    } else {
      readerData = data;
    }

    millsecondtime = 100;
    if (timers != null) {
      timers!.cancel();
    }
    timers = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      millsecondtime = millsecondtime - 10;
      if (millsecondtime <= 0) {
        timers!.cancel();
        // String string = String.fromCharCodes(readerData);
        // print('received: $string');
        if (readerData.isNotEmpty) {
          pushNotice(Uint8List.fromList(readerData));
        }
      }
    });
  }

  ///发送 获取参数指令 id：参数id
  sendParameterInstruct(int id) async {
    Uint8List list = Uint8List.fromList(
      getIntInstroct(
        getHexInstroct(
          ['A5', 'D1', '0A', '00', '00', '00'],
          getHexNumList(id, 2),
        ),
      ),
    );

    if (GetPlatform.isDesktop) {
      port!.write(list, timeout: 0);
      print('串口发送指令');
    } else {
      bluetoothConnection!.output.add(list);
      await bluetoothConnection!.output.allSent;
      print('蓝牙发送指令');
    }
  }

  ///发送 保存参数指令  id :参数id
  sendParameterSaveInstruct(int id) async {
    Uint8List list = Uint8List.fromList(
      getIntInstroct(
        getHexInstroct(
          ['A5', 'D2', '0e', '00', '00', '00'],
          getHexNumList(id, 2) + getHexNumList(1, 4),
        ),
      ),
    );
    if (GetPlatform.isDesktop) {
      port!.write(list, timeout: 0);
      print('串口发送指令');
    } else {
      bluetoothConnection!.output.add(list);
      await bluetoothConnection!.output.allSent;
      print('蓝牙发送指令');
    }
  }

  ///10进制数字  转16进制 数组   高低位(根据字符 补全0)
  List<String> getHexNumList(int num, int byte) {
    List<String> numList = [];
    String str = num.toRadixString(16).padLeft(byte * 2, '0');
    print(str);
    for (var i = 0; i < byte; i++) {
      String oneStr = str.substring(i * 2, i * 2 + 2);
      print(oneStr);
      numList.insert(0, oneStr);
    }

    return numList;
  }

  ///16进制数组转10进制数字  (低位)
  int getRealNumber(List<int> numList) {
    String str = '';
    numList.forEach((element) {
      String a = element.toRadixString(16).padLeft(2, '0');
      str = a + str;
    });

    return hexToInt(str);
  }

  ///组装指令（16进制）
  List<String> getHexInstroct(List<String> hexHeader, List<String> payload) {
    List<String> newHeader = hexHeader + payload;

    ///校验码 （所有数 的和）
    int checkNum = 0;

    ///计算所有的和
    for (String element in newHeader) {
      checkNum = checkNum + hexToInt(element);
    }

    ///16进制校验码
    List<String> checkHexList = getHexNumList(checkNum, 2);
    print(checkHexList);
    print('16进制指令：${hexHeader + checkHexList + payload}');

    return hexHeader + checkHexList + payload;
  }

  ///获取发送的Uint8List数组
  List<int> getIntInstroct(List<String> hexList) {
    List<int> intList = [];
    for (String e in hexList) {
      intList.add(hexToInt(e));
    }
    return intList;
  }

  ///更新参数
  updateParameterWithSerial(int num) {
   
    List li = parameterCon.all_parameterList
        .where((element) => element.parmName == 'InputMode')
        .toList();
    if (li.isNotEmpty) {
      Parameter par = li.first;
      parameterCon.all_parameter_value[par.parmName] = par.enumValue[num];

    
    }

    List real_li = parameterCon.real_time_data_list
        .where((element) => element.motId == 'InputMode')
        .toList();
    if (li.isNotEmpty) {
      Parameter par = li.first;
      parameterCon.all_parameter_value[par.parmName] = par.enumValue[num];
    }
    bus.emit('updateRealParameter', num);

    bus.emit('updateParameterWithSerial');
  }

  ///刷固件 擦除

  firmware_opdate_erase(int startAddress, int byteCount) async {
    List<String> addressHex = getHexNumList(startAddress, 4);

    List<int> addressNum = List.generate(
        addressHex.length, (index) => hexToInt(addressHex[index]));

    List<String> byteCountHex = getHexNumList(byteCount, 4);
    List<int> byteCountNum = List.generate(
        byteCountHex.length, (index) => hexToInt(byteCountHex[index]));
    List<int> list = [
          0x5A,
          0XA4,
          0X0C,
          0X00,
          0X02,
          0X00,
          0X00,
          0X02,
        ] +
        addressNum +
        byteCountNum;

    String checkStr = getCrc(list);

    List checkHexList = getHexNumList(hexToInt(checkStr), 2);
    final checkNum = List.generate(
        checkHexList.length, (index) => hexToInt(checkHexList[index]));

    list.insertAll(4, checkNum);
    list.forEach((element) {
      print('16进制' + element.toRadixString(16));
    });
    // Uint8List tolist = Uint8List.fromList(
    //   [
    //     hexToInt('5a'),
    //     hexToInt('a4'),
    //     hexToInt('0c'),
    //     hexToInt('00'),
    //     hexToInt(checkHexList[0]),
    //     hexToInt(checkHexList[1]),
    //     hexToInt('02'),
    //     hexToInt('00'),
    //     hexToInt('00'),
    //     hexToInt('02'),
    //     hexToInt('00'),
    //     hexToInt('40'),
    //     hexToInt('00'),
    //     hexToInt('00'),
    //     hexToInt('00'),
    //     hexToInt('08'),
    //     hexToInt('00'),
    //     hexToInt('00'),
    //   ],
    // );
    port!.write(Uint8List.fromList(list), timeout: 0);
    print('串口发送指令');
    // print(list.hashCode);
    // bluetoothConnection!.output.add(list);
    // await bluetoothConnection!.output.allSent;
    // print('蓝牙发送指令');
  }

  ///刷固件 写入
  firmware_opdate_write_init(int startAddress, int byteCount) async {
    print('firmware_opdate_write_init');
    List<String> addressHex = getHexNumList(startAddress, 4);

    List<int> addressNum = List.generate(
        addressHex.length, (index) => hexToInt(addressHex[index]));

    List<String> byteCountHex = getHexNumList(byteCount, 4);
    List<int> byteCountNum = List.generate(
        byteCountHex.length, (index) => hexToInt(byteCountHex[index]));

    List<int> list = [
          0x5A,
          0XA4,
          0X0C,
          0X00,
          0X04,
          0X00,
          0X00,
          0X02,
        ] +
        addressNum +
        byteCountNum;

    String checkStr = getCrc(list);
    print(checkStr);
    List checkHexList = getHexNumList(hexToInt(checkStr), 2);
    final checkNum = List.generate(
        checkHexList.length, (index) => hexToInt(checkHexList[index]));
    list.insertAll(4, checkNum);
    // Uint8List list = Uint8List.fromList(
    //   [
    //     hexToInt('5a'),
    //     hexToInt('a4'),
    //     hexToInt('0c'),
    //     hexToInt('00'),
    //     hexToInt(checkHexList[0]),
    //     hexToInt(checkHexList[1]),
    //     hexToInt('04'),
    //     hexToInt('00'),
    //     hexToInt('00'),
    //     hexToInt('02'),
    //     hexToInt('00'),
    //     hexToInt('40'),
    //     hexToInt('00'),
    //     hexToInt('00'),
    //     hexToInt('20'),
    //     hexToInt('00'),
    //     hexToInt('00'),
    //     hexToInt('00'),
    //   ],
    // );
    list.forEach((element) {
      print('16进制' + element.toRadixString(16));
    });
    port!.write(Uint8List.fromList(list), timeout: 0);
    print('串口发送指令');
    // print(list.hashCode);
    // bluetoothConnection!.output.add(list);
    // await bluetoothConnection!.output.allSent;
    // print('蓝牙发送指令');
  }

  ///刷固件 写数据
  firmware_opdate_write_repeat(List<int> data) {
    List<String> lengthHex = getHexNumList(data.length, 2);
    List<int> lengthNum =
        List.generate(lengthHex.length, (index) => hexToInt(lengthHex[index]));

    List<int> list = [
          0x5A,
          0XA5,
        ] +
        lengthNum +
        data;

    String checkStr = getCrc(list);
    print(checkStr);
    List checkHexList = getHexNumList(hexToInt(checkStr), 2);

    final checkNum = List.generate(
        checkHexList.length, (index) => hexToInt(checkHexList[index]));

    list.insertAll(4, checkNum);
    list.forEach((element) {
      print('16进制' + element.toRadixString(16));
    });
    port!.write(Uint8List.fromList(list), timeout: 0);
    print('串口发送指令');
  }
}
