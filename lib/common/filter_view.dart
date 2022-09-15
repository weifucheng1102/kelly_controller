import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';

class FilterView extends StatefulWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final parameterCon = Get.put(ParameterCon());
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 78, vertical: 42),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                parameterCon.property_list[index].motMetaKey,
                style: TextStyle(
                  color: Get.theme.highlightColor,
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.only(),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 6,
                      childAspectRatio: 120 / 40,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      children: gridViewList(
                        index,
                        parameterCon.property_list[index].motMetaValues,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 44,
                    width: 90,
                    alignment: Alignment.centerLeft,
                    child:
                        parameterCon.property_list[index].motMetaValues.length >
                                    6 &&
                                !parameterCon.property_select_more[index]
                            ? foldButton(index)
                            : SizedBox(),
                  ),
                ],
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 25,
          );
        },
        itemCount: parameterCon.property_list.length);
  }

  List<Widget> gridViewList(int index, List array) {
    List<Widget> list = [];
    List dataArr = [];
    if (!parameterCon.property_select_more[index] && array.length > 6) {
      dataArr = array.sublist(0, 6);
    } else {
      dataArr = array;
    }

    for (var i = 0; i < dataArr.length; i++) {
      list.add(
        Tooltip(
          message: parameterCon.property_list[index].motMetaValues[i],
          showDuration: const Duration(seconds: 0),
          preferBelow: false,
          child: InkWell(
            onTap: () {
              if (parameterCon.property_isSelect_list[index] != i) {
                parameterCon.property_isSelect_list[index] = i;
              } else {
                parameterCon.property_isSelect_list[index] = -1;
              }

              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: parameterCon.property_isSelect_list[index] == i
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Get.theme.primaryColor,
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.transparent,
                      border: Border.all(
                        color: Get.theme.hintColor,
                        width: 1,
                      ),
                    ),
              child: Text(
                parameterCon.property_list[index].motMetaValues[i],
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                  color: parameterCon.property_isSelect_list[index] == i
                      ? Get.theme.highlightColor
                      : Get.theme.hintColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (parameterCon.property_select_more[index] && dataArr.length > 6) {
      list.add(
        foldButton(index),
      );
    }

    return list;
  }

  Widget foldButton(index) {
    return InkWell(
      onTap: () {
        parameterCon.property_select_more[index] =
            !parameterCon.property_select_more[index];
        setState(() {});
      },
      child: Row(
        children: [
          Text(
            parameterCon.property_select_more[index] ? 'Fold' : 'Unfold',
            style: TextStyle(
              color: Get.theme.hintColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Image.asset(
            parameterCon.property_select_more[index]
                ? 'assets/images/theme${box.read("theme")}/filter_up.png'
                : 'assets/images/theme${box.read("theme")}/filter_down.png',
            width: 16,
          )
        ],
      ),
    );
  }
}
