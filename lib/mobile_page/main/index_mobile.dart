import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kelly_user_project/common/app_bar_mobile.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/common/nav_key.dart';
import 'package:kelly_user_project/controller/menu_controller.dart';
import 'package:kelly_user_project/mobile_page/connect/connect_mobile.dart';
import 'package:kelly_user_project/mobile_page/data_bisualization/visualization_mobile.dart';
import 'package:kelly_user_project/mobile_page/firmware/firmware_mobile.dart';
import 'package:kelly_user_project/mobile_page/monitor_control/monitor_control_mobile.dart';
import 'package:kelly_user_project/mobile_page/monitor_control/monitor_page_mobile.dart';
import 'package:kelly_user_project/mobile_page/parameters/parameter_page_mobile.dart';
import 'package:kelly_user_project/mobile_page/user_setting/user_setting_mobile.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class IndexMobile extends StatefulWidget {
  const IndexMobile({Key? key}) : super(key: key);

  @override
  State<IndexMobile> createState() => _IndexMobileState();
}

class _IndexMobileState extends State<IndexMobile> {
  final menuCon = Get.put(MenuController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NativeDeviceOrientedWidget(
        fallback: (context) => const SizedBox(),

        ///横屏
        landscape: (context) => landscapeWidget(),

        ///竖屏
        portrait: (context) => portraitWidget(),
      ),
    );
  }

  ///横屏
  landscapeWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ListView.separated(
            itemBuilder: (context, index) => const SizedBox(),
            separatorBuilder: (context, index) => InkWell(
              onTap: () {
                menuCon.selectIndex.value = index;
              },
              child: Obx(
                () => Text(
                  menuCon.title[index],
                  style: TextStyle(
                      color: menuCon.selectIndex.value == index
                          ? Colors.red
                          : Colors.black),
                ),
              ),
            ),
            itemCount: menuCon.title.length,
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.black,
            child: ParameterPageMobile(),
          ),
        ),
      ],
    );
  }

  ///竖屏
  portraitWidget() {
    return Obx(
      () => Scaffold(
        key: _scaffoldKey,
        appBar: AppBarMobile(
          title: menuCon.title[menuCon.selectIndex.value],
          leadingOnTap: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        drawer: Drawer(
          backgroundColor: Get.theme.dialogBackgroundColor,
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.only(left: 56.w, top: 80.w),
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/theme${box.read("theme")}/menu_logo.png',
                      width: 300.w,
                    )
                  ],
                ),
                portraitLeftMenuWidget(),
              ],
            ),
          ),
        ),
        body: indexBgWidget(),
      ),
    );
  }

  ///背景
  indexBgWidget() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/theme${box.read("theme")}/mobile_main_bg.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: currentPage(),
    );
  }

  Widget currentPage() {
    switch (menuCon.selectIndex.value) {
      case 0:
        return Container();
      case 1:
        return ConnectMobile();

      case 2:
        return ParameterPageMobile();
      case 3:
        return MonitorPageMobile();
      case 4:
        return VisualizationMobile();
      case 5:
        return FirmwareMobile();
      case 6:
        return UserSettingMobile();
      default:
        return Container();
    }
  }

  ///左侧菜单
  portraitLeftMenuWidget() {
    return ListView.separated(
      padding: EdgeInsets.only(top: 90.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => portraitMenuItemWidget(index),
      separatorBuilder: (context, index) => SizedBox(height: 82.w),
      itemCount: menuCon.title.length,
    );
  }

  ///菜单item
  portraitMenuItemWidget(index) {
    return GestureDetector(
      onTap: () {
        menuCon.selectIndex.value = index;
        if (_scaffoldKey.currentState!.isDrawerOpen) Navigator.pop(context);
      },
      child: Row(
        children: [
          Image.asset(
            menuCon.selectIndex.value == index
                ? 'assets/images/theme${box.read("theme")}/${menuCon.image[index]}'
                : 'assets/images/theme${box.read("theme")}/${menuCon.unImage[index]}',
            width: 40.w,
          ),
          SizedBox(
            width: 22.w,
          ),
          Text(
            menuCon.title[index],
            style: TextStyle(
              color: menuCon.selectIndex.value == index
                  ? Get.theme.highlightColor
                  : Get.theme.hintColor,
              fontSize: 30.sp,
            ),
          )
        ],
      ),
    );
  }
}
