import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'back_widget.dart';
import 'get_box.dart';

class CustomPopMenu extends StatefulWidget {
  final String title;
  final double width;
  final double height;
  final List<MenuItems> items; // 显示的内容
  final String hint;
  final Color? hintColor;
  final dynamic value;
  final ValueChanged<dynamic>? valueChanged; // 选中数据的回调事件
  final VoidCallback? labelTap;
  const CustomPopMenu({
    Key? key,
    required this.title,
    this.items = const [],
    this.hint = 'Please select',
    this.hintColor,
    this.valueChanged,
    this.labelTap,
    required this.width,
    required this.height,
    required this.value,
  }) : super(key: key);

  @override
  State<CustomPopMenu> createState() => _CustomPopMenuState();
}

class _CustomPopMenuState extends State<CustomPopMenu> {
  var valueData;
  @override
  void initState() {
    super.initState();
    valueData = widget.value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: GetPlatform.isDesktop ? 21.w : 0, bottom: 9),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Get.theme.hintColor,
              fontSize: GetPlatform.isDesktop ? 24.sp : 16,
            ),
          ),
        ),
        BackWidget(
          width: widget.width, // 682,
          height: widget.height, // 66,
          child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: DropdownButtonHideUnderline(
                child: Theme(
                  data: ThemeData(
                    focusColor: Colors.transparent,
                  ),
                  child: DropdownButton(
                    focusColor: Colors.transparent,
                    dropdownColor: Get.theme.dialogBackgroundColor,
                    icon: Image.asset(
                      'assets/images/theme${box.read("theme")}/point_down.png',
                      width: 19.w,
                    ),
                    isExpanded: true,
                    items: widget.items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.value,
                            child: Text(
                              item.label,
                              style: TextStyle(
                                color: Get.theme.highlightColor,
                                fontSize: GetPlatform.isDesktop ? 24.sp : 16,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    hint: Text(
                      widget.hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: GetPlatform.isDesktop ? 24.sp : 16,
                        color: widget.hintColor ?? Get.theme.hintColor,
                      ),
                    ),
                    onChanged: (Object? value) {
                      valueData = value;
                      setState(() {});
                      if (widget.valueChanged != null) {
                        widget.valueChanged!.call(value);
                      }
                    },
                    onTap: () {
                      if (widget.labelTap != null) {
                        widget.labelTap!.call();
                      }
                    },
                    value: valueData,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}

class MenuItems {
  String label; // 显示的文本
  dynamic value; // 选中的值

  // bool checked; // 是否选中

  MenuItems({
    this.label = '',
    this.value,
    //this.checked = false,
  });
}
