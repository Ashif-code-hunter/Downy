import 'package:downy/core/const/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/const/color_manger.dart';
import '../../core/const/font_manager.dart';
import '../../core/const/style_manager.dart';
import '../../core/const/values_manger.dart';


class MainAppBarWidget extends StatelessWidget {
  const MainAppBarWidget({
    super.key,
    required this.isFirstPage,
    required this.title
  });
  final bool isFirstPage;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.secondary,
            ColorManager.primary
          ],
        ),
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12.r),
            bottomLeft: Radius.circular(12.r)),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      height: 80.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
                 children: [
                 !isFirstPage ?  InkWell(
                     onTap: () => Navigator.pop(context),
                     child: const Icon(Icons.arrow_back_rounded),
                   ):kSizedBox,
                   kSizedW10,
                   Text(
                     title ,
                     style: getBoldStyle(
                         color: ColorManager.white,
                         fontSize: FontSize.s20),
                   ),
                 ],
               ),
            kSizedBox20,
          ],
        ),
      ),
    );
  }
}
