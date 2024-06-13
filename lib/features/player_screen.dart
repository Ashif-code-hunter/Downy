import 'dart:io';

import 'package:better_player_plus/better_player_plus.dart';
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

  // void _setupDataSource() async {
  //   var filePath = await LocalLocationUtils.getFileUrl("JILC7sCpilo.aes");
  //   File file = File(filePath);
  //
  //   List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
  //   BetterPlayerDataSource dataSource =
  //   BetterPlayerDataSource.memory(bytes, videoExtension: "mp4");
  //   _betterPlayerController.setupDataSource(dataSource);
  // }


  Future<Uint8List> decryptVideoData(String inputFilePath) async {
    // Generate encryption key and initialization vector (IV)
    final key = eny.Key.fromUtf8('my 32 length key................');
    final iv = eny.IV.allZerosOfLength(16);
    final encrypter = eny.Encrypter(eny.AES(key));
    // Open the encrypted file
    final inputFile = File(inputFilePath);
    final videoFileContents =  inputFile.readAsBytesSync();
    final encryptedFile = eny.Encrypted(videoFileContents);
    final decrypted = encrypter.decryptBytes(encryptedFile, iv: iv);
    return Uint8List.fromList(decrypted);
  }

  void _setupDataSource() async {
    var filePath = await LocalLocationUtils.getFileUrl("JILC7sCpilo.aes");

    // Decrypt the video data
    Uint8List decryptedBytes = await decryptVideoData(filePath);

    // Set up BetterPlayer data source with decrypted bytes
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.memory,
      "",
      bytes: decryptedBytes,
      videoExtension: "mp4",
    );

    // Assuming _betterPlayerController is already initialized
    _betterPlayerController.setupDataSource(dataSource);
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