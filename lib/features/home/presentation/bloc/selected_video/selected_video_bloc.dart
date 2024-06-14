import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as eny;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/const/string_manager.dart';
import '../../../../../core/utils/local_location.dart';

part 'selected_video_event.dart';
part 'selected_video_state.dart';

class SelectedVideoBloc extends Bloc<SelectedVideoEvent, SelectedVideoState> {
  SelectedVideoBloc() : super(SelectedVideoInitial()) {
    on<VideoEvent>((event, emit) async {
      emit(SelectedVideoLoading());
      final filePath =  await LocalLocationUtils.getFileUrl( event.fileName);
      final result = await HeavyTaskDecryption().useIsolate(filePath: filePath);
      if(result[0] is! String){
        print("xxxxxxxxxxxxxs111 $result");

        emit(SelectedVideoLoaded(videoDataList: result[0]));
      }else{
        print("xxxxxxxxxxxxx ${result.runtimeType}");
        emit(SelectedVideoError(errorMessage: "Could not decrypt the file, please try again later"));
      }
    });
  }
}

class HeavyTaskDecryption {
  Future<List> useIsolate({
    required String filePath,
  }) async
  {
    final ReceivePort receivePort = ReceivePort();
    try {
      await Isolate.spawn(
          processingData, [receivePort.sendPort, filePath]);
    } on Object {
      receivePort.close();
    }
    final response = await receivePort.first;
    return response;
  }

  Future<int> processingData(List<dynamic> args) async {
    SendPort resultPort = args[0];
    print("ssss ${args[1]}");

    final result = await decryptFile(filePath: args[1]);
    List value = [result];

    Isolate.exit(resultPort, value);
  }


  Future<dynamic> decryptFile({required String filePath}) async {
    File inFile =  File("${filePath.split(".mp4").first}.aes");
    try{
      final videoFileContents =  inFile.readAsBytesSync();
      final key = eny.Key.fromUtf8(AppStrings.key);
      final iv = eny.IV.allZerosOfLength(16);
      final encrypter = eny.Encrypter(eny.AES(key));
      final encryptedFile = eny.Encrypted(videoFileContents);
      final decrypted = encrypter.decrypt(encryptedFile, iv: iv);
      final decryptedBytes = latin1.encode(decrypted);
      print("lksks");
      return decryptedBytes;
    }catch(e){
      return "Something Went Wrong, $e";
    }
  }
}
