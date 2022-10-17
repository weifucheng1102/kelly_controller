import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/custom_button.dart';
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
    return dialogWidget();
  }

  filterListView() {
    return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 78.w, vertical: 42.h),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                parameterCon.property_list[index].motMetaKey,
                style: TextStyle(
                  color: Get.theme.highlightColor,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(
                height: 20.h,
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
                      mainAxisSpacing: 15.w,
                      crossAxisSpacing: 15.h,
                      children: gridViewList(
                        index,
                        parameterCon.property_list[index].motMetaValues,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    height: 44.h,
                    width: 90.w,
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
                        width: 1.w,
                      ),
                    ),
              child: Text(
                parameterCon.property_list[index].motMetaValues[i],
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18.sp,
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
              fontSize: 20.sp,
            ),
          ),
          SizedBox(
            width: 4.w,
          ),
          Image.asset(
            parameterCon.property_select_more[index]
                ? 'assets/images/theme${box.read("theme")}/filter_up.png'
                : 'assets/images/theme${box.read("theme")}/filter_down.png',
            width: 16.w,
          )
        ],
      ),
    );
  }

  Widget dialogWidget() {
    return Container(
      width: 1039.w,
      height: 1.sh - 220.h,
      decoration: BoxDecoration(
        color: Get.theme.dialogBackgroundColor,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        children: [
          Expanded(
            child: filterListView(),
          ),
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Verfy',
                width: 165.w,
                height: 64.h,
                onTap: () async {
                  await parameterCon.getDefaultProPertySelectList();
                  await parameterCon.getParameterWithProperty();

                  Navigator.pop(context);
                  // widget.voidCallback();
                },
              ),
              SizedBox(width: 30.w),
              CustomButton(
                text: 'Program',
                width: 165.w,
                height: 64.h,
                bgColor: Get.theme.primaryColor,
                borderWidth: 0,
                borderColor: Colors.transparent,
                onTap: () async {
                  await parameterCon.getParameterWithProperty();
                  Navigator.pop(context);
                  //widget.voidCallback();
                },
              ),
            ],
          ),
          SizedBox(height: 40.h),
          //filterButton(),
        ],
      ),
    );
  }
}
