import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/config/themes.dart';
import 'package:kelly_user_project/controller/theme_con.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final themeCon = Get.put(ThemeCon());
  RxInt selectIndex = (box.read('theme') as int).obs;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 109),
      child: Column(
        children: [
          _title(),
          const SizedBox(height: 38),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _themeList(),
          ),
          const SizedBox(height: 95),
          CustomButton(
            text: 'Confirm',
            width: 165,
            height: 64,
            bgColor: Get.theme.primaryColor,
            borderColor: Colors.transparent,
            borderWidth: 0,
            onTap: () =>
                themeCon.updateTheme(Themes.themeList[selectIndex.value]),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return Text(
      'Choose a topic',
      style: TextStyle(
        fontSize: 20,
        color: Get.theme.hintColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Widget> _themeList() {
    return List.generate(
      Themes.themeList.length,
      (index) => _themeItem(index),
    );
  }

  Widget _themeItem(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: InkWell(
        onTap: () {
          selectIndex.value = index;
        },
        child: Row(
          children: [
            Obx(
              () => Image.asset(
                selectIndex.value == index
                    ? 'assets/images/theme${box.read("theme")}/select.png'
                    : 'assets/images/theme${box.read("theme")}/un_select.png',
                width: 28,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'theme$index',
              style: TextStyle(
                color: Get.theme.hintColor,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
