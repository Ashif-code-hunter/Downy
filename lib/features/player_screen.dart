import 'dart:convert';
import 'dart:io';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:downy/core/const/string_manager.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../core/utils/local_location.dart';
import 'package:encrypt/encrypt.dart' as eny;


class MemoryPlayerPage extends StatefulWidget {
  @override
  _MemoryPlayerPageState createState() => _MemoryPlayerPageState();
}

class _MemoryPlayerPageState extends State<MemoryPlayerPage> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
    BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _setupDataSource();
    super.initState();
  }

  void _setupDataSource() async {

    Uint8List decryptedVideo = await decryptFile(fileName: "rhrD7as3KJg.mp4",);
    // List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
    BetterPlayerDataSource dataSource =
    BetterPlayerDataSource.memory(decryptedVideo, videoExtension: "mp4");
    _betterPlayerController.setupDataSource(dataSource);
  }

  Future<Uint8List> decryptFile({required String fileName}) async {
    var inFilePath = await LocalLocationUtils.getFileUrl("${fileName.split(".").first}.aes");
    File inFile =  File(inFilePath);
    final videoFileContents =  inFile.readAsBytesSync();
    final key = eny.Key.fromUtf8(AppStrings.key);
    final iv = eny.IV.allZerosOfLength(16);
    final encrypter = eny.Encrypter(eny.AES(key));
    final encryptedFile = eny.Encrypted(videoFileContents);
    final decrypted = encrypter.decrypt(encryptedFile, iv: iv);
    final decryptedBytes = latin1.encode(decrypted);
    return decryptedBytes;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memory player"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Memory player with plays video from bytes list. In this example"
                  "file bytes are read to list and then used in player.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
        ],
      ),
    );
  }
}