import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:downy/core/const/sized_boxes.dart';
import 'package:encrypt/encrypt.dart' as eny;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../core/const/color_manger.dart';
import '../../../../core/const/font_manager.dart';
import '../../../../core/const/style_manager.dart';
import '../../../../core/const/values_manger.dart';
import '../../../../core/utils/local_location.dart';
import '../../../common_widgets/appbar_main_widget.dart';
import '../../../common_widgets/rounded_button_widget.dart';
import '../../../player_screen.dart';

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

    Future<void> encryptAndWriteVideo(
        {required Stream<List<int>> stream,required StreamInfo streamInfo,required IOSink output}) async {
      // Generate encryption key and initialization vector
      final key = eny.Key.fromUtf8('my 32 length key................');
      final iv = eny.IV.allZerosOfLength(16);
      final encrypter = eny.Encrypter(eny.AES(key));

      var count = 0;
      final len = streamInfo.size.totalBytes;

      await for (final data in stream) {
        // Keep track of the current downloaded data.
        count += data.length;

        // Calculate the current progress.
        final progress = ((count / len) * 100).ceil();

        print(progress.toStringAsFixed(2));

        // Encrypt the data
        final encrypted = encrypter.encryptBytes(data, iv: iv);
        // Write the encrypted data to file
        output.add(data);
      }
    }

    encryptFile({required String fileName}) async {
      var inFilePath = await LocalLocationUtils.getFileUrl(fileName);
      var outFilePath = await LocalLocationUtils.getFileUrl("${fileName.split(".").first}.aes");
      File inFile =  File(inFilePath);
      File outFile =  File(outFilePath);

      bool outFileExists = await outFile.exists();

      if(!outFileExists){
        await outFile.create();
      }
      final videoFileContents =  inFile.readAsStringSync(encoding: latin1);
      final key = eny.Key.fromUtf8('my 32 length key................');
      final iv = eny.IV.allZerosOfLength(16);
      final encrypter = eny.Encrypter(eny.AES(key));
      final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
      await outFile.writeAsBytes(encrypted.bytes);
    }

    decryptFile({required String fileName}) async {
     var inFilePath = await LocalLocationUtils.getFileUrl("${fileName.split(".").first}.aes");
     var outFilePath = await LocalLocationUtils.getFileUrl(fileName);
         File inFile =  File(inFilePath);
      File outFile =  File(outFilePath);
      bool outFileExists = await outFile.exists();
      if(!outFileExists){
        await outFile.create();
      }
      final videoFileContents =  inFile.readAsBytesSync();
      final key = eny.Key.fromUtf8('my 32 length key................');
      final iv = eny.IV.allZerosOfLength(16);
      final encrypter = eny.Encrypter(eny.AES(key));
      final encryptedFile = eny.Encrypted(videoFileContents);
      final decrypted = encrypter.decrypt(encryptedFile, iv: iv);
      final decryptedBytes = latin1.encode(decrypted);
      await outFile.writeAsBytes(decryptedBytes);
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
              CustomButton(onTap: () async {
                print("ki");
                final yt = YoutubeExplode();
                final id = VideoId('https://www.youtube.com/watch?v=rhrD7as3KJg'.trim());
                print("ff $id");
                var video = await yt.videos.get(id); // Returns a Video instance.
                var title = video.title;
                var author = video.author;
                var duration = video.duration;
                var streamManifest = await yt.videos.streamsClient.getManifest(id);
                var streamInfo = streamManifest.muxed.bestQuality;
                final fileName = '${video.id}.${streamInfo.container.name}';
                Directory directory = await getApplicationDocumentsDirectory();
                print("object444 ${directory.path}/$fileName");
                final file = File('${directory.path}/$fileName');
                if (file.existsSync()) {
                  print("ooiei8 ${directory.path}/$fileName");
                  file.deleteSync();
                }
                final output = file.openWrite(mode: FileMode.writeOnlyAppend);
                print("$title $author $duration");
                var stream = yt.videos.streamsClient.get(streamInfo);
                await encryptAndWriteVideo(stream: stream, streamInfo: streamInfo, output: output);
                await output.close();
                await encryptFile(fileName: fileName);
                file.deleteSync();
                yt.close();
              },title: "Download",height: 30.h,) // Download and encrypt videos through this button
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
           print("objectqqq222");
           await decryptFile(fileName: "rhrD7as3KJg.mp4");
           print("objectqqq");
            },
          backgroundColor: ColorManager.secondary,
          child: Icon(Icons.file_download_outlined, color: ColorManager.white,)), //Navigate to downloaded videos list screen
    );

  }

}
