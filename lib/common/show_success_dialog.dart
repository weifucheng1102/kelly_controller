import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/get_box.dart';

class ShowSuccessDialog extends StatefulWidget {
  const ShowSuccessDialog({Key? key}) : super(key: key);

  @override
  State<ShowSuccessDialog> createState() => _ShowSuccessDialogState();
}

class _ShowSuccessDialogState extends State<ShowSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.all(50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:  Get.theme.dialogBackgroundColor,
      ),
      child: dialogView(),
    );
  }

  Widget dialogView() {
    return Column(
      children: [
        Column(
          children: [
            Image.asset(
              'assets/images/theme${box.read("theme")}/sucess.png',
            
            ),
            SizedBox(
              height: 28,
            ),
            Text(
              'modify successfully',
              style: TextStyle(
                fontSize: 30,
                color: Get.theme.highlightColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 30,),
          CustomButton(
                text: 'Modify',
                width: 165,
                height: 64,
                bgColor: Get.theme.primaryColor,
                borderWidth: 0,
                borderColor: Colors.transparent,
                onTap: () async {
                 
                  Navigator.pop(context);
                
                },
              ),
      ],
    );
  }
}
