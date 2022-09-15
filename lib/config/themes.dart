import 'package:flutter/material.dart';

class Themes {
  static final themeList = [
    black,
    white,
  ];

  static final black = ThemeData.light().copyWith(
    primaryColor: const Color(0xFF007CC4), //主要部分颜色

    // backgroundColor: const Color(0XFF222222), //背景色
    highlightColor: Colors.white, //选中高亮颜色
    //unselectedWidgetColor: const Color(0xffADB6C2), //未选中的颜色
    hintColor: const Color(0xffADB6C2), //提示颜色
    focusColor: const Color(0xff5AEDFF), //重点颜色
    dialogBackgroundColor: const Color(0xff01234e),
    dividerColor: const Color(0xff242E4B),
    errorColor: const Color(0xffFF0000),
    // appBarTheme: const AppBarTheme(
    //   backgroundColor: Color(0xFF007CC4),
    //   foregroundColor: Color(0xFF10A6E5),
    //   titleTextStyle: TextStyle(
    //     fontSize: 20,
    //     color: Colors.white,
    //   ),
    // ),
    // textTheme: const TextTheme(
    //   bodyText1: TextStyle(
    //     fontSize: 14,
    //     color: Colors.white,
    //   ),
    // ),
    // tabBarTheme: const TabBarTheme(
    //   labelStyle: TextStyle(
    //     fontSize: 15,
    //     fontWeight: FontWeight.bold,
    //     color: Colors.white,
    //   ),
    //   unselectedLabelStyle: TextStyle(
    //     fontSize: 15,
    //     color: Color(0xff202127),
    //   ),
    // ),
  );

  static final white = ThemeData.light().copyWith(
    primaryColor: const Color(0xFF007CC4), //主要部分颜色
    backgroundColor: Colors.white, //背景色
    highlightColor: const Color(0xFF007CC4), //选中高亮颜色
    unselectedWidgetColor: Colors.white, //未选中的颜色
    dialogBackgroundColor: const Color(0xff01234e),

    // appBarTheme: const AppBarTheme(
    //   backgroundColor: Color(0xFF007CC4),
    //   foregroundColor: Color(0xFF10A6E5),
    //   titleTextStyle: TextStyle(
    //     fontSize: 20,
    //     color: Colors.black,
    //   ),
    // ),
    // textTheme: const TextTheme(
    //   bodyText1: TextStyle(
    //     fontSize: 14,
    //     color: Colors.black,
    //   ),
    // ),
    // tabBarTheme: const TabBarTheme(
    //   labelStyle: TextStyle(
    //     fontSize: 15,
    //     fontWeight: FontWeight.bold,
    //     color: Colors.white,
    //   ),
    //   unselectedLabelStyle: TextStyle(
    //     fontSize: 15,
    //     color: Color(0xff202127),
    //   ),
    // ),
  );
}
