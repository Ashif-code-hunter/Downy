import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/const/color_manger.dart';
import '../../../../core/const/font_manager.dart';
import '../../../../core/const/style_manager.dart';
import '../../../../core/const/values_manger.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: AppPadding.p6),
          child: Text(
            'Howdy, pal',
            style: getSemiBoldStyle(
                color: ColorManager.black, fontSize: FontSize.s16),
          ),
        ),
      ),
      body: Column(),
    );
  }
}
