import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:downy/core/const/sized_boxes.dart';
import 'package:downy/core/const/string_manager.dart';
import 'package:downy/features/home/presentation/bloc/selected_video/selected_video_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:encrypt/encrypt.dart' as eny;

import '../../../common_widgets/appbar_main_widget.dart';
import '../../../../core/utils/local_location.dart';

class ViewScreenPlayer extends HookWidget {
  const ViewScreenPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final _betterPlayerController = useMemoized(
          () {
        BetterPlayerConfiguration betterPlayerConfiguration =
        const BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
        );

        return BetterPlayerController(betterPlayerConfiguration);
      },
      [key],
    ); // configuration of better player

    Future<Uint8List> decryptFile({required String fileName}) async {
      var inFilePath =
      await LocalLocationUtils.getFileUrl("${fileName.split(".").first}.aes");
      File inFile = File(inFilePath);
      final videoFileContents = inFile.readAsBytesSync();
      final key = eny.Key.fromUtf8(AppStrings.key);
      final iv = eny.IV.allZerosOfLength(16);
      final encrypter = eny.Encrypter(eny.AES(key));
      final encryptedFile = eny.Encrypted(videoFileContents);
      final decrypted = encrypter.decrypt(encryptedFile, iv: iv);
      final decryptedBytes = latin1.encode(decrypted);
      return decryptedBytes;
    }

    void _setupDataSource(Uint8List data) async {
      Uint8List decryptedVideo = data;
      BetterPlayerDataSource dataSource =
      BetterPlayerDataSource.memory(decryptedVideo, videoExtension: "mp4");
      _betterPlayerController.setupDataSource(dataSource);
    } // function used for playing video from device itself using Uint8List data type

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60.h),
        child: const MainAppBarWidget(isFirstPage: false, title: "Downloaded List"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          BlocConsumer<SelectedVideoBloc, SelectedVideoState>(
            listener: (BuildContext context, SelectedVideoState state) {
              if (state is SelectedVideoLoaded) {
                _setupDataSource(state.videoDataList); // if the data is loaded we are triggering better player for visualizing video
              }
            },
            builder: (context, state) {
              if (state is SelectedVideoLoaded) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(controller: _betterPlayerController),
                );
              } else if (state is SelectedVideoLoading || state is SelectedVideoInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return kSizedBox;
            },
          ),
        ],
      ),
    );
  }
}