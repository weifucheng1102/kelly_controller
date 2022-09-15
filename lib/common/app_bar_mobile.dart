import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:kelly_user_project/common/common.dart';

import 'get_box.dart';

class AppBarMobile extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final void Function()? leadingOnTap;
  const AppBarMobile({
    Key? key,
    this.title = '',
    this.leadingOnTap,
  }) : super(key: key);

  @override
  State<AppBarMobile> createState() => _AppBarMobileState();

  @override
  Size get preferredSize => Size.fromHeight(45);
}

class _AppBarMobileState extends State<AppBarMobile> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Get.theme.dialogBackgroundColor,
      title: Text(
        widget.title!,
        textScaleFactor: 1,
        style: TextStyle(
          color: Get.theme.highlightColor,
          fontSize: 18,
        ),
      ),
      leading: isLandScape()
          ? null
          : IconButton(
              onPressed: widget.leadingOnTap,
              enableFeedback: false,
              highlightColor: Colors.transparent,
              //splashColor: Colors.transparent,
              icon: Image.asset(
                'assets/images/theme${box.read("theme")}/mobile_left_menu.png',
                width: 44.w,
              ),
            ),
    );
  }
}
