import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:bloc/bloc.dart';
import 'package:downy/features/home/domain/entity/video_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:encrypt/encrypt.dart' as eny;
import '../../../../core/const/string_manager.dart';
import '../../../../core/utils/local_location.dart';
import '../../domain/usecase/video_download_usecases.dart';
import '../../domain/usecase/video_meta_data_usecases.dart';

part 'video_meta_data_event.dart';
part 'video_meta_data_state.dart';

class VideoMetaDataBloc extends Bloc<VideoMetaDataEvent, VideoState> {

  VideoMetaDataBloc({
    required VideoMetaDataUseCase videoMetaDataUseCase,
    required VideoDownloadUseCase videoDownloadUseCase
  })
      :_videoMetaDataUseCase = videoMetaDataUseCase,
        _videoDownloadUseCase = videoDownloadUseCase,
        super(VideoMetaInitial()) {
    on<DownloadVideoMetaDataEvent>(_onMetaDownloadVideo);
    on<DownloadVideoDataEvent>(_onDownloadVideo);
  }
  final VideoMetaDataUseCase _videoMetaDataUseCase;
  final VideoDownloadUseCase _videoDownloadUseCase;

  Future<void> _onMetaDownloadVideo(
      DownloadVideoMetaDataEvent event,
      Emitter<VideoState> emit,
      ) async {
    emit(VideoDownloadInProgressState());
    print("dddddd");

    final result = await _videoMetaDataUseCase(
      MetaDataParams(url:event.videoUrl,)
    );
    result.fold((failure) => emit(VideoDownloadFailureState(failure.errorMessage)),
            (data) => emit(VideoMetaDataLoadedState(metaData: data)));
  }
  Future<void> _onDownloadVideo(
      DownloadVideoDataEvent event,
      Emitter<VideoState> emit,
      ) async {
    emit(VideoDownloadInProgressState());
    try {
      final progressStream = _videoDownloadUseCase(
          VideoDownloadParams(fileName: event.fileName,streamInfo: event.streamInfo)
      );
      await for (final progress in progressStream) {
        emit(VideoDownloadProgressState(progress: progress));
      }
      emit(VideoDownloadInProgressState());
    final filePath =  await LocalLocationUtils.getFileUrl( event.fileName);
    final status = await HeavyTask().useIsolate(filePath: filePath);
    if(status =="Ok"){
      print("lll");
      emit(VideoDownloadSuccessState());
    }else{
      emit(VideoDownloadFailureState(status[0] ?? ""));
    }
    } catch (e) {
      emit(VideoDownloadFailureState(e.toString()));
    }
  }
}


class HeavyTask {
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

    final status = await encryptVideo(filePath: args[1]);
    List value = [status];
    print("ssss $value");
    Isolate.exit(resultPort, value);
  }


  Future<String?> encryptVideo({required String filePath}) async {
    final inFile = File(filePath);
    final outFile = File("${filePath.split(".mp4").first}.aes");
    try{
      if (!outFile.existsSync()) {
        await outFile.create();
      }
      final videoFileContents = inFile.readAsStringSync(encoding: latin1);
      final key = eny.Key.fromUtf8(AppStrings.key);
      final iv = eny.IV.allZerosOfLength(16);
      final encrypter = eny.Encrypter(eny.AES(key));
      final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
      await outFile.writeAsBytes(encrypted.bytes);
      inFile.deleteSync();
      print("dddddddddd");

      return "Ok";
    }catch(e){
      print(e);
      inFile.deleteSync();
      return "Something Went Wrong, $e";

    }

  }
}
