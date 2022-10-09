import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:kelly_user_project/common/app_bar_mobile.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/filter_button_mobile.dart';
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
  double leftMenuMargin = isLandScape() ? 1.sw / 4 : 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isLandScape() ? const AppBarMobile(title: 'Parameters') : null,
      body: SafeArea(
        left: false,
        right: false,
        child: Column(
          children: [
            topView(),
            Expanded(child: lsitview()),
            FilterButtonMobile(),
          ],
        ),
      ),
    );
  }

  lsitview() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10),
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
            return inputGridview(values[index]);
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
        topButton('Read file'),
        topButton('Write file'),
        topButton('Modify'),
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

  Widget inputGridview(List<Parameter> list) {
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
                    await parameterCon.updateParameterValue(e, res);
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
          .map((e) => SizedBox(
                width: (1.sw - leftMenuMargin - 40) / 2,
                child: CustomPopMenu(
                  title: e.parmName,
                  width: (1.sw - leftMenuMargin - 40) / 2,
                  height: 40,
                  value: -1,
                ),
              ))
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
                    onChanged: (res) {
                      parameterCon.all_parameter_value[e.parmName] =
                          !parameterCon.all_parameter_value[e.parmName];
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
    return StatefulBuilder(builder: (context, switchbuild) {
      return Wrap(
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
                    children: [
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
                            min: 0,
                            max: 5,
                            stepSize: 1,
                            value: 2,
                            trackShape: _SfTrackShape(),
                            thumbIcon: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: Get.theme.focusColor,
                              ),
                              padding: EdgeInsets.all(4),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                            ),
                            onChanged: (res) {},
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        width: 50,
                        child: TextFormField(),
                      ),
                    ],
                  ),
                ],
              ),
            )
            .toList(),
      );
    });
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
