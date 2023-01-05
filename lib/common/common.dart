import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///读文件
Future<PlatformFile?> firmwareReadFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    dialogTitle: 'Select File',
  );
  PlatformFile? file;
  if (result != null && result.files.isNotEmpty) {
    file = result.files.first;
  }
  return file;
}

///横屏
bool isLandScape() {
  return 1.sw > 1.sh;
}

///竖屏
bool isportiait() {
  return 1.sh > 1.sw;
}

///获取移动端左侧距离
double getMobileLeftMargin() {
  return isLandScape() ? 1.sw / 4 : 0;
}

//随机颜色
Color randomColor() {
  return Color.fromRGBO(
    Random().nextInt(256),
    Random().nextInt(256),
    Random().nextInt(256),
    1,
  );
}

///16进制转10进制
int hexToInt(String hex) {
  int val = 0;
  int len = hex.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = hex.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("Invalid hexadecimal value");
    }
  }
  return val;
}

///获取校验码
getCheckCode(List<int> list) {
  int num = 0;
  for (int element in list) {
    num = num + element;
  }
}

//刷固件 校验码生成
String getCrc(List list) {
  int lengthInBytes = list.length;
  int crc = 0;
  int j;
  for (j = 0; j < lengthInBytes; ++j) {
    int i;
    int byte = list[j];
    crc ^= (byte << 8);
    crc = crc;
    for (i = 0; i < 8; ++i) {
      int temp = (crc << 1);
      if (crc & 0x8000 != 0) {
        temp ^= 0x1021;
      }
      crc = temp;
    }
  }

  return crc.toUnsigned(16).toRadixString(16);
}

///固定长度分割数组
List constructList(int len, List list) {
  var length = list.length; //列表数组数据总条数
  List result = []; //结果集合
  int index = 1;
  //循环 构造固定长度列表数组
  while (true) {
    if (index * len < length) {
      List temp = list.skip((index - 1) * len).take(len).toList();
      result.add(temp);
      index++;
      continue;
    }
    List temp = list.skip((index - 1) * len).toList();
    result.add(temp);
    break;
  }
  return result;
}
