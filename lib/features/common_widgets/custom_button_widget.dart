import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/const/color_manger.dart';
import '../../core/const/font_manager.dart';
import '../../core/const/style_manager.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({super.key,
    required this.onTap,
    this.height,
    this.width ,
    this.fontSize =FontSize.s14,

    this.color ,
    required this.text});
  final void Function()? onTap;
  final String text;
  final Color? color;
  final double? height;
  final double? width;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: 10,
      shadowColor: ColorManager.black,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: (height??46).h,
          width:(width??164).w,
          decoration: BoxDecoration(
            color: color??ColorManager.primary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                    color: ColorManager.white, fontSize: fontSize)),
          ),
        ),
      ),
    );
  }
}
