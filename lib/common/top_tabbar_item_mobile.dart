import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/controller/menu_controller.dart';

class TopTabbarItemMobile extends StatefulWidget {
  final String title;
  final int index;
  final VoidCallback? indexTap;
  const TopTabbarItemMobile(
    this.title,
    this.index, {
    this.indexTap,
    Key? key,
  }) : super(key: key);

  @override
  State<TopTabbarItemMobile> createState() => _TopTabbarItemMobileState();
}

class _TopTabbarItemMobileState extends State<TopTabbarItemMobile> {
  final menuController = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.indexTap != null) {
            widget.indexTap!();
          }
          if (menuController.bottomMenuIndex.value != widget.index) {
            menuController.bottomMenuIndex.value = widget.index;
          }
        },
        child: Obx(() => Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: menuController.bottomMenuIndex.value == widget.index
                        ? Get.theme.focusColor
                        : Get.theme.hintColor,
                    fontWeight:
                        menuController.bottomMenuIndex.value == widget.index
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: menuController.bottomMenuIndex.value == widget.index
                        ? Get.theme.focusColor
                        : Colors.transparent,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
