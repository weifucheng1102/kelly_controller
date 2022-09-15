import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/app_bar_mobile.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/config/themes.dart';
import 'package:kelly_user_project/controller/theme_con.dart';

class UserSettingMobile extends StatefulWidget {
  const UserSettingMobile({Key? key}) : super(key: key);

  @override
  State<UserSettingMobile> createState() => _UserSettingMobileState();
}

class _UserSettingMobileState extends State<UserSettingMobile> {
  RxInt selectIndex = (box.read('theme') as int).obs;
  final themeCon = Get.put(ThemeCon());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar:
          isLandScape() ? const AppBarMobile(title: 'UserApp Settings') : null,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _themeList(),
            ),
          ),
          SafeArea(
            child: CustomButton(
              text: 'Modify',
              width: 1.sw - getMobileLeftMargin() - 60.w,
              height: 50,
              bgColor: Get.theme.primaryColor,
              borderColor: Colors.transparent,
              onTap: () =>
                  themeCon.updateTheme(Themes.themeList[selectIndex.value]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _themeList() {
    List<Widget> list = [
      _titleItem(),
    ];
    list.addAll(
      List.generate(
        Themes.themeList.length,
        (index) => _themeItem(index),
      ),
    );
    return list;
  }

  Widget _titleItem() {
    return ListTile(
      title: Text(
        'choose a topic',
        style: TextStyle(
          color: Get.theme.hintColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _themeItem(index) {
    return Obx(
      () => ListTile(
        onTap: () => selectIndex.value = index,
        title: Text(
          'theme$index',
          style: TextStyle(
            color: Get.theme.hintColor,
            fontSize: 14,
          ),
        ),
        trailing: Image.asset(
          selectIndex.value == index
              ? 'assets/images/theme${box.read("theme")}/select.png'
              : 'assets/images/theme${box.read("theme")}/un_select.png',
          width: 16,
        ),
      ),
    );
  }
}
