import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:kelly_user_project/common/app_bar_mobile.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_dialog.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/filter_button_mobile.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/common/show_success_dialog.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/connection_con.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ParameterPageMobile extends StatefulWidget {
  const ParameterPageMobile({Key? key}) : super(key: key);

  @override
  State<ParameterPageMobile> createState() => _ParameterPageMobileState();
}

class _ParameterPageMobileState extends State<ParameterPageMobile> {
  final parameterCon = Get.put(ParameterCon());
  final ConnectionCon connectionCon = Get.put(ConnectionCon());
  double leftMenuMargin = isLandScape() ? 1.sw / 4 : 0;
  var sliderBuild;

  @override
  void initState() {
    //设置滑块参数显示方式：   slider 滑块，  input 输入框
    if (box.read('sliderDisplay') == null) {
      box.write('sliderDisplay', 'slider');
    }

    ///读取文件更新数据
    bus.on('updateParameterWithFile', (arg) {
      if (mounted) {
        setState(() {});
      }
    });
    bus.on('updateParameterSuccess', (arg) {
      print('2222');
      if (mounted) {
        CustomDialog.showCustomDialog(context, child: ShowSuccessDialog());
      }
    });

    ///指令处理数据
    bus.on('updateParameterWithSerial', (arg) {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
    if (connectionCon.bluetoothConnection != null &&
        connectionCon.bluetoothConnection!.isConnected) {
      ///发送指令
      connectionCon.sendParameterInstruct(257);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: isLandScape() ? const AppBarMobile(title: 'Parameters') : null,
      body: SafeArea(
        left: false,
        right: false,
        child: Column(
          children: [
            topView(),
            Expanded(child: lsitview()),
          ],
        ),
      ),
      bottomNavigationBar: FilterButtonMobile(
        voidCallback: () {
          setState(() {});
        },
      ),
    );
  }

  lsitview() {
    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemBuilder: (context, index) {
        List<String> keys = parameterCon.filter_parameter_maplist.keys
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
      itemCount: parameterCon.filter_parameter_maplist.keys.length,
    );
  }

  topView() {
    return Row(
      children: [
        topButton('Read file', onTap: () async {
          ///读文件
          await parameterCon.parameterReadFile();
        }),
        topButton('Write file', onTap: () {
          parameterCon.writeFile(context);
        }),
        topButton('Modify', onTap: () {
          ///保存参数指令
          connectionCon.sendParameterSaveInstruct(257);
        }),
      ],
    );
  }

  topButton(
    String title, {
    void Function()? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: Get.theme.highlightColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget inputGridview(List<Parameter> list, bool isSlider) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: list
          .map((e) => SizedBox(
                width: (1.sw - leftMenuMargin - 40) / 2,
                child: CustomInput(
                  title: e.parmName,
                  hint: 'hint',
                  readOnly: false,
                  width: (1.sw - leftMenuMargin - 40) / 2,
                  height: 40,
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
              ))
          .toList(),
    );
  }

  Widget enumGridview(List<Parameter> list) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: list
          .map(
            (e) => SizedBox(
              width: (1.sw - leftMenuMargin - 40) / 2,
              child: CustomPopMenu(
                title: e.parmName,
                width: (1.sw - leftMenuMargin - 40) / 2,
                height: 40,
                items: e.enumValue
                    .map((value) => MenuItems(label: value, value: value))
                    .toList(),
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

  Widget switcherGridview(List<Parameter> list) {
    return StatefulBuilder(builder: (context, switchbuild) {
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: list
            .map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.parmName,
                    style: TextStyle(
                      color: Get.theme.hintColor,
                      fontSize: 16,
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
            )
            .toList(),
      );
    });
  }

  Widget sliderGridview(List<Parameter> list) {
    return StatefulBuilder(builder: (context, sliderbuild) {
      sliderBuild = sliderbuild;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          displayValue(),
          box.read('sliderDisplay') == 'slider'
              ? Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: list
                      .map(
                        (e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.parmName,
                              style: TextStyle(
                                color: Get.theme.hintColor,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SfSliderTheme(
                                    data: SfSliderThemeData(
                                      activeTrackHeight: 25,
                                      inactiveTrackHeight: 25,
                                      activeTrackColor: Get.theme.primaryColor,
                                      inactiveTrackColor: Get.theme.hintColor,
                                      trackCornerRadius: 12.5,
                                      thumbRadius: 16,
                                    ),
                                    child: SfSlider(
                                      min: e.sliderMin,
                                      max: e.sliderMax,
                                      stepSize: 1,
                                      value: parameterCon
                                          .all_parameter_value[e.parmName],
                                      trackShape: _SfTrackShape(),
                                      thumbIcon: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          color: Get.theme.focusColor,
                                        ),
                                        padding: EdgeInsets.all(4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            color: Get.theme.primaryColor,
                                          ),
                                        ),
                                      ),
                                      onChanged: (res) async {
                                        await parameterCon.updateParameterValue(
                                            e, res);
                                        sliderbuild(() {});
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  parameterCon.all_parameter_value[e.parmName]
                                      .toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Get.theme.highlightColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      .toList(),
                )
              : inputGridview(list, true),
        ],
      );
    });
  }

  Widget displayValue() {
    double textFont = 18;
    return DropdownButtonHideUnderline(
      child: Theme(
        data: ThemeData(
          focusColor: Colors.transparent,
        ),
        child: DropdownButton(
          focusColor: Colors.transparent,
          dropdownColor: Get.theme.dialogBackgroundColor,
          icon: Padding(
            padding: EdgeInsets.only(left: 10),
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
                  fontSize: textFont,
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
                  fontSize: textFont,
                ),
              ),
            )
          ],
          hint: Text(
            'Select the display mode',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: textFont,
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

class _SfTrackShape extends SfTrackShape {
  @override
  Rect getPreferredRect(
      RenderBox parentBox, SfSliderThemeData themeData, Offset offset,
      {bool? isActive}) {
    final double? trackHeight = themeData.activeTrackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    // 让轨道宽度等于 Slider 宽度
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
