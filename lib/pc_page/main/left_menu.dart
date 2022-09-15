import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/controller/menu_controller.dart';


class LeftMenu extends StatefulWidget {
  const LeftMenu({Key? key}) : super(key: key);

  @override
  State<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  final menuController = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Image.asset(
            'assets/images/theme${box.read("theme")}/menu_logo.png',
            width: 201,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(),
            itemBuilder: (context, index) {
              return Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        if (menuController.selectIndex.value != index) { 
                          menuController.selectIndex.value = index;
                          menuController.bottomMenuIndex.value = 0;
                        }
                      },
                      child: Container(
                        height: 64,
                        width: 201,
                        decoration: menuController.selectIndex.value == index
                            ? BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/theme${box.read("theme")}/menu_bg.png'),
                                  fit: BoxFit.fill,
                                ),
                              )
                            : null,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Image.asset(
                              menuController.selectIndex.value == index
                                  ? 'assets/images/theme${box.read("theme")}/${menuController.image[index]}'
                                  : 'assets/images/theme${box.read("theme")}/${menuController.unImage[index]}',
                              width: 20,
                            ),
                            const SizedBox(
                              width: 17,
                            ),
                            Text(
                              menuController.title[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: menuController.selectIndex.value == index
                                    ? Get.theme.highlightColor
                                    : Get.theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: menuController.title.length,
          ),
        ),
      ],
    );
  }
}
