import 'package:downy/core/const/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/const/color_manger.dart';
import '../../../../core/const/font_manager.dart';
import '../../../../core/const/style_manager.dart';
import '../../../../core/const/values_manger.dart';
import '../../../common_widgets/appbar_main_widget.dart';
import '../../../common_widgets/rounded_button_widget.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final _linkController = useTextEditingController();
    void _pasteFromClipboard() async {
      ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData != null) {
        String pastedText = clipboardData.text!;
        _linkController.text = pastedText;
      }
    }

    return Scaffold(
      appBar:  PreferredSize(
        preferredSize:  Size(double.infinity, 60.h),
        child: MainAppBarWidget(isFirstPage: true,title: "Welcome to downy"),
      ),
      body: SafeArea(
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hi, paste your youtube link below for downloading videos.",style: getSemiBoldStyle(color: ColorManager.secondary,fontSize: AppSize.s18),textAlign: TextAlign.center,),
            kSizedBox30,
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorManager.primary.withOpacity(.2), // Background color
                  hintText: 'https://www.youtube.com/',
                  hintStyle: getSemiBoldStyle(color: ColorManager.grey3,fontSize: FontSize.s14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Border radius
                    borderSide: BorderSide.none, // Remove border
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p16), // Padding
                  suffixIcon: InkWell(
                    onTap: _pasteFromClipboard,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                      decoration: BoxDecoration(
                        gradient:  LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorManager.secondary,
                            ColorManager.primary
                          ],
                        ),// Button color
                        borderRadius: BorderRadius.circular(8.0), // Button border radius
                      ),
                      child: Icon(Icons.paste_rounded,color: ColorManager.white,)
                    ),
                  ),
                ),
              ),
              kSizedBox30,
              CustomButton(onTap: (){

              },title: "Download",height: 30.h,) // Download and encrypt videos through this button
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
          backgroundColor: ColorManager.secondary,
          child: Icon(Icons.file_download_outlined, color: ColorManager.white,)), //Navigate to downloaded videos list screen
    );

  }

}
