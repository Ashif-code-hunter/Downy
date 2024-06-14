import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:downy/core/const/sized_boxes.dart';
import 'package:encrypt/encrypt.dart' as eny;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../core/const/color_manger.dart';
import '../../../../core/const/font_manager.dart';
import '../../../../core/const/string_manager.dart';
import '../../../../core/const/style_manager.dart';
import '../../../../core/const/values_manger.dart';
import '../../../../core/utils/local_location.dart';
import '../../../common_widgets/appbar_main_widget.dart';
import '../../../common_widgets/rounded_button_widget.dart';
import '../../../player_screen.dart';
import '../bloc/video_meta_data_bloc.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final _linkController = useTextEditingController(text: "https://www.youtube.com/watch?v=rhrD7as3KJg");
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
              BlocConsumer<VideoMetaDataBloc,VideoState>(
                builder: (context, state) {
                  if (state is VideoDownloadInProgressState) {
                    return const CircularProgressIndicator();
                  } else if (state is VideoDownloadProgressState) {
                    print(state.progress);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        LinearProgressIndicator(
                            value: state.progress,
                        color: ColorManager.secondary,
                          minHeight: 5,
                          backgroundColor: ColorManager.grey3,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        Text("${( state.progress*100).ceil().toString()}/100%"),
                     kSizedBox14,
                        Center(
                          child: CustomButton(onTap: (){
                            context.read<VideoMetaDataBloc>()
                                .add(CancelDownloadEvent());

                          }, title: "Cancel",height: 30.h,isCancel: true,),
                        )
                      ],
                    );
                  }
                  return CustomButton(onTap: () async {
                    context
                        .read<VideoMetaDataBloc>()
                        .add(DownloadVideoMetaDataEvent(videoUrl: _linkController.text.trim()));
                  },title: "Download",height: 30.h,);
                },

                listener: (BuildContext context, VideoState state) {
                  if(state is VideoMetaDataLoadedState ){
                    print("${state.metaData.videoUrl} ${state.metaData.title}");
                    context.read<VideoMetaDataBloc>()
                      .add(DownloadVideoDataEvent(fileName: state.metaData.fileName,streamInfo: state.metaData.muxedStreamInfo));
                  }
                },
              ) // Download and encrypt videos through this button
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MemoryPlayerPage()));
            },
          backgroundColor: ColorManager.secondary,
          child: Icon(Icons.file_download_outlined, color: ColorManager.white,)), //Navigate to downloaded videos list screen
    );

  }

}
