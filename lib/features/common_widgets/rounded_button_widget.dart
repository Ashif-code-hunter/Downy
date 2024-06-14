import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/const/color_manger.dart';
import '../../core/const/font_manager.dart';
import '../../core/const/style_manager.dart';




class RoundButtonWidget extends StatelessWidget {
  const RoundButtonWidget({super.key,
    required this.onTap,
    this.height =60,
    this.width =200,

    this.isCancel,
    required this.title});
  final void Function()? onTap;
  final String title;
  final double height;
  final double width;
  final bool? isCancel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            height: height.h,
            width:width.w,
            decoration: BoxDecoration(
              gradient:  LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [

                 isCancel ?? false ? ColorManager.onError : ColorManager.secondary,
                  isCancel ?? false ? ColorManager.red : ColorManager.primary
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                      color: ColorManager.white, fontSize: FontSize.s16)),
            ),
            ),
    );
    }
}