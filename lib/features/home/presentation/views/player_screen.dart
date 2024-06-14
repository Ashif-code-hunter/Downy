import 'dart:convert';
import 'dart:io';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:downy/core/const/sized_boxes.dart';
import 'package:downy/core/const/string_manager.dart';
import 'package:downy/core/const/values_manger.dart';
import 'package:downy/features/home/presentation/bloc/selected_video/selected_video_bloc.dart';
import 'package:downy/features/home/presentation/bloc/video_data_local/video_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:typed_data';
import '../../../../core/utils/local_location.dart';
import 'package:encrypt/encrypt.dart' as eny;

import '../../../common_widgets/appbar_main_widget.dart';

class ViewScreenPlayer extends StatefulWidget {
  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreenPlayer> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        const BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    super.initState();
  }

  void _setupDataSource(Uint8List data) async {
    Uint8List decryptedVideo = data;
    BetterPlayerDataSource dataSource =
        BetterPlayerDataSource.memory(decryptedVideo, videoExtension: "mp4");
    _betterPlayerController.setupDataSource(dataSource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60.h),
        child: const MainAppBarWidget(
            isFirstPage: false, title: "Downloaded List"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          BlocConsumer<SelectedVideoBloc, SelectedVideoState>(
              listener: (BuildContext context, SelectedVideoState state) {
            if (state is SelectedVideoLoaded) {
              _setupDataSource(state.videoDataList);
            }
          }, builder: (context, state) {
            if (state is SelectedVideoLoaded) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppPadding.p12,vertical: AppPadding.p8),

                    child: BetterPlayer(controller: _betterPlayerController)),
              );
            } else if (state is SelectedVideoLoading || state is SelectedVideoInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return kSizedBox;
          }),
        ],
      ),
    );
  }
}
