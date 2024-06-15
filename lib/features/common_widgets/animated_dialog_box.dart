


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/const/color_manger.dart';
import '../../../../core/const/font_manager.dart';
import '../../../../core/const/style_manager.dart';
import '../../../../core/const/values_manger.dart';
import 'custom_animated_popup_widget.dart';
import 'custom_button_widget.dart';

void showCustomDialog({
  required BuildContext context,
  String? title,
  required String desc,
  void Function()? onOkTap,
  void Function()? onCancelTap,
  String? okButtonText,
  String? cancelButtonText,
  bool? isDismissible,
  bool? showCancelButton,
  String? header,
  Color? okColor,
  Color? cancelColor,

}) {
  showDialog(
    context: context,
    barrierDismissible:isDismissible??true,

    builder: (BuildContext context) {
      return
        AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: VerticalStackDialog(
            width: null,
            header: header != null ? Lottie.asset(
              header,
              fit: BoxFit.contain,
              repeat: true,
              height: 400.h,
            ): null,
            padding: const EdgeInsets.all(AppPadding.p16),
            title: title,
            titleStyle: getBoldStyle(color:ColorManager.black,fontSize: FontSize.s16,),
            desc: desc,
            descStyle: getSemiBoldStyle(color: ColorManager.black,fontSize: FontSize.s14 ),
            btnOk:
            CustomButton(
              text:okButtonText?? "Ok",
              onTap:  onOkTap??()=>Navigator.pop(context),
              width: 70.w,
              height:20.h ,
              color: okColor ?? ColorManager.green,
            ),
            btnCancel:showCancelButton ?? false ? CustomButton(
              text:cancelButtonText?? "Cancel",
              onTap:  onCancelTap??()=>Navigator.pop(context),
              width: 70.w,
              height:20.h ,
              color: cancelColor ?? ColorManager.red,
            ):null,
          ),

        );
    },
  );
}