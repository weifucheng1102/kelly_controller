import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';

class FilterViewMobile extends StatefulWidget {
  const FilterViewMobile({Key? key}) : super(key: key);

  @override
  State<FilterViewMobile> createState() => _FilterViewMobileState();
}

class _FilterViewMobileState extends State<FilterViewMobile> {
  final parameterCon = Get.put(ParameterCon());
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                parameterCon.property_list[index].motMetaKey,
                style: TextStyle(
                  color: Get.theme.highlightColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: gridViewList(
                  index,
                  parameterCon.property_list[index].motMetaValues,
                ),
              ),
              // GridView.count(
              //   padding: const EdgeInsets.only(),
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   crossAxisCount: 6,
              //   childAspectRatio: 120 / 40,
              //   mainAxisSpacing: 15,
              //   crossAxisSpacing: 15,
              //   children: gridViewList(r
              //     index,
              //     parameterCon.property_list[index].motMetaValues,
              //   ),
              // ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 20,
          );
        },
        itemCount: parameterCon.property_list.length);
  }

  List<Widget> gridViewList(int index, List array) {
    List<Widget> list = [];

    for (var i = 0; i < array.length; i++) {
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
              padding: const EdgeInsets.all(7),
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
                  fontSize: 13,
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

    return list;
  }
}
