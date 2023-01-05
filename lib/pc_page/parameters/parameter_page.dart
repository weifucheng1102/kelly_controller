import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_dialog.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/filter_button.dart';
import 'package:kelly_user_project/common/filter_view.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/common/show_success_dialog.dart';
import 'package:kelly_user_project/config/config.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/connection_con.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../common/custom_button.dart';

class ParameterPage extends StatefulWidget {
  const ParameterPage({Key? key}) : super(key: key);

  @override
  State<ParameterPage> createState() => _ParameterPageState();
}

class _ParameterPageState extends State<ParameterPage> {
  final parameterCon = Get.put(ParameterCon());
  final connectionCon = Get.put(ConnectionCon());
  var sliderBuild;

  double wrapSpace() => 30.w;
  double wrapRunSpace() => 30.h;
  double displayFont() => 18.sp;
  double inputWidth() => 350;
  double inputHeight() => 66.w;
  double parNameFont() => 20.sp;

  @override
  void initState() {
    //设置滑块参数显示方式：   slider 滑块，  input 输入框
    if (box.read('sliderDisplay') == null) {
      box.write('sliderDisplay', 'slider');
    }

    ///读取文件更新数据
    bus.on('updateParameterWithFile', (arg) {
      setState(() {});
    });
    bus.on('updateParameterSuccess', (arg) {
      if (mounted) {
        CustomDialog.showCustomDialog(context, child: ShowSuccessDialog());
      }
    });

    ///指令处理数据
    bus.on('updateParameterWithSerial', (arg) {
      setState(() {});
    });
    super.initState();

    ///发送 获取参数指令
    if (connectionCon.port != null) {
      connectionCon.sendParameterInstruct(257);
    }
  }

  @override
  void dispose() {
    super.dispose();
    bus.off('updateParameterWithFile');
    bus.off('updateParameterWithSerial');
    bus.off('updateParameterSuccess');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: left_menu_margin()),
              child: ListView.separated(
                  padding: EdgeInsets.all(10),
                  controller: ScrollController(),
                  itemBuilder: (context, index) {
                    List<String> keys = parameterCon
                        .filter_parameter_maplist.keys
                        .where((element) => true)
                        .toList();
                    List<List<Parameter>> values = parameterCon
                        .filter_parameter_maplist.values
                        .where((element) => true)
                        .toList();

                    switch (keys[index]) {
                      case 'input':
                        return inputGridview(values[index], false);
                      case 'enum':
                        return enumGridview(values[index]);
                      case 'switcher':
                        return switcherGridview(values[index]);
                      case 'slider':
                        return sliderGridview(values[index]);
                      default:
                        return SizedBox();
                    }
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 30,
                    );
                  },
                  itemCount: parameterCon.filter_parameter_maplist.keys.length),
            ),
          ),
          FilterButton(
            voidCallback: () {
              CustomDialog.showCustomDialog(context, child: FilterView(
                voidCallback: () {
                  setState(() {});
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  ///输入框类型参数布局
  Widget inputGridview(List<Parameter> list, bool isSlider) {
    return Wrap(
      runSpacing: wrapRunSpace(),
      spacing: wrapSpace(),
      children: list
          .map(
            (e) => Tooltip(
              preferBelow: false,
              message: e.toolTip,
              child: CustomInput(
                title: e.parmName,
                hint: 'hint',
                readOnly: false,
                width: inputWidth(),
                height: inputHeight(),
                fieldCon: TextEditingController(
                    text: parameterCon.all_parameter_value[e.parmName]
                        .toString()),
                onChanged: (res) async {
                  if (isSlider) {
                    await parameterCon.updateParameterValue(
                        e, res.isEmpty ? 0 : double.parse(res));
                  } else {
                    await parameterCon.updateParameterValue(e, res);
                  }
                },
              ),
            ),
          )
          .toList(),
    );
  }

  ///选择框参数类型布局
  Widget enumGridview(List<Parameter> list) {
    return Wrap(
      runSpacing: wrapRunSpace(),
      spacing: wrapSpace(),
      children: list
          .map(
            (e) => Tooltip(
              preferBelow: false,
              message: e.toolTip,
              child: CustomPopMenu(
                title: e.parmName,
                items: e.enumValue
                    .map((value) => MenuItems(label: value, value: value))
                    .toList(),
                width: inputWidth(),
                height: inputHeight(),
                value: e.enumValue.length == 0 ||
                        parameterCon.all_parameter_value[e.parmName].length == 0
                    ? null
                    : parameterCon.all_parameter_value[e.parmName],
                valueChanged: (res) async {
                  await parameterCon.updateParameterValue(e, res);
                },
              ),
            ),
          )
          .toList(),
    );
  }

  ///开关类型参数布局
  Widget switcherGridview(List<Parameter> list) {
    return StatefulBuilder(builder: (context, switchbuild) {
      return Wrap(
        runSpacing: wrapRunSpace(),
        spacing: wrapSpace(),
        children: list
            .map(
              (e) => Tooltip(
                preferBelow: false,
                message: e.toolTip,
                child: SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          e.parmName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Get.theme.hintColor,
                            fontSize: parNameFont(),
                          ),
                        ),
                      ),
                      CupertinoSwitch(
                        activeColor: Get.theme.primaryColor,
                        value: parameterCon.all_parameter_value[e.parmName],
                        onChanged: (res) async {
                          await parameterCon.updateParameterValue(e, res);
                          switchbuild(() {});
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    });
  }

  ///滑块类型参数布局
  Widget sliderGridview(List<Parameter> list) {
    return StatefulBuilder(
      builder: (context, sliderbuild) {
        sliderBuild = sliderbuild;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            displayValue(),
            box.read('sliderDisplay') == 'slider'
                ? Wrap(
                    runSpacing: wrapRunSpace(),
                    spacing: wrapSpace(),
                    children: list
                        .map(
                          (e) => Tooltip(
                            preferBelow: false,
                            message: e.toolTip,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 21.w, bottom: 9.h),
                                  child: Text(
                                    e.parmName,
                                    style: TextStyle(
                                      color: Get.theme.hintColor,
                                      fontSize: parNameFont(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 400,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SfSliderTheme(
                                          data: SfSliderThemeData(
                                            activeTrackHeight: 40.h,
                                            inactiveTrackHeight: 40.h,
                                            activeTrackColor:
                                                Get.theme.primaryColor,
                                            inactiveTrackColor:
                                                Get.theme.hintColor,
                                            trackCornerRadius: 20.h,
                                            thumbRadius: 25.h,
                                          ),
                                          child: SfSlider(
                                            min: e.sliderMin,
                                            max: e.sliderMax,
                                            stepSize: 1,
                                            value: parameterCon
                                                    .all_parameter_value[
                                                e.parmName],
                                            thumbIcon: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.h),
                                                color: Get.theme.focusColor,
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.h),
                                                  color: Get.theme.primaryColor,
                                                ),
                                              ),
                                            ),
                                            onChanged: (res) async {
                                              await parameterCon
                                                  .updateParameterValue(e, res);
                                              sliderbuild(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                      Text(
                                        parameterCon
                                            .all_parameter_value[e.parmName]
                                            .toStringAsFixed(1),
                                        style: TextStyle(
                                          color: Get.theme.highlightColor,
                                          fontSize: parNameFont(),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: 160.w,
                                      //   child: TextFormField(
                                      //     onChanged: (res) async {
                                      //       if (double.parse(res) > e.sliderMax) {
                                      //         await parameterCon.updateParameterValue(
                                      //             e, e.sliderMax);
                                      //         sliderbuild(() {});
                                      //       }
                                      //       if (double.parse(res) < e.sliderMin) {
                                      //         await parameterCon.updateParameterValue(
                                      //             e, e.sliderMin);
                                      //         sliderbuild(() {});
                                      //       }
                                      //     },
                                      //     onFieldSubmitted: (res) async {
                                      //       parameterCon
                                      //               .all_parameter_value[e.parmName] =
                                      //           double.parse(res);
                                      //       await parameterCon.updateParameterValue(
                                      //           e, double.parse(res));
                                      //       sliderbuild(() {});
                                      //     },
                                      //     controller: TextEditingController(
                                      //       text: parameterCon
                                      //           .all_parameter_value[e.parmName]
                                      //           .toStringAsFixed(1),
                                      //     ),
                                      //     style: TextStyle(
                                      //       color: Get.theme.highlightColor,
                                      //       fontSize: parNameFont(),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
                : inputGridview(list, true),
          ],
        );
      },
    );
  }

  Widget displayValue() {
    return DropdownButtonHideUnderline(
      child: Theme(
        data: ThemeData(
          focusColor: Colors.transparent,
        ),
        child: DropdownButton(
          focusColor: Colors.transparent,
          dropdownColor: Get.theme.dialogBackgroundColor,
          icon: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Image.asset(
              'assets/images/theme${box.read("theme")}/point_down.png',
              width: 19.w,
            ),
          ),
          alignment: AlignmentDirectional.center,
          items: [
            DropdownMenuItem(
              alignment: AlignmentDirectional.center,
              value: 'slider',
              child: Text(
                'slider',
                style: TextStyle(
                  color: Get.theme.highlightColor,
                  fontSize: displayFont(),
                ),
              ),
            ),
            DropdownMenuItem(
              alignment: AlignmentDirectional.center,
              value: 'input',
              child: Text(
                'input',
                style: TextStyle(
                  color: Get.theme.highlightColor,
                  fontSize: displayFont(),
                ),
              ),
            )
          ],
          hint: Text(
            'Select the display mode',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: displayFont(),
              color: Get.theme.hintColor,
            ),
          ),
          onChanged: (value) {
            box.write('sliderDisplay', value);
            sliderBuild(() {});
          },
        ),
      ),
    );
  }
}
