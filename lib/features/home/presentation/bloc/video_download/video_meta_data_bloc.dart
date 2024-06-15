import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:bloc/bloc.dart';
import 'package:downy/features/home/domain/entity/video_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:encrypt/encrypt.dart' as eny;
import '../../../../../core/const/string_manager.dart';
import '../../../../../core/usecase/cancel.dart';
import '../../../../../core/utils/local_location.dart';
import '../../../domain/usecase/video_download_usecases.dart';
import '../../../domain/usecase/video_meta_data_usecases.dart';

part 'video_meta_data_event.dart';
part 'video_meta_data_state.dart';

class VideoMetaDataBloc extends Bloc<VideoMetaDataEvent, VideoState> {

  VideoMetaDataBloc({
    required VideoMetaDataUseCase videoMetaDataUseCase,
    required VideoDownloadUseCase videoDownloadUseCase
  })
      :_videoMetaDataUseCase = videoMetaDataUseCase,
        _videoDownloadUseCase = videoDownloadUseCase,
        _cancellationToken = CancellationToken(),
        super(const VideoMetaInitial(metaData:VideoMetaEntity(description: "",fileName: "",downloadStatus: "",duration: Duration(seconds: 0),title: "",id: "",videoUrl: "",streamManifest: null,muxedStreamInfo: null))) {
    on<DownloadVideoMetaDataEvent>(_onMetaDownloadVideo);
    on<DownloadVideoDataEvent>(_onDownloadVideo);
    on<CancelDownloadEvent>(_onCancelDownload);
  }
  final VideoMetaDataUseCase _videoMetaDataUseCase;
  final VideoDownloadUseCase _videoDownloadUseCase;
  final CancellationToken _cancellationToken;
  double percentCheck =0.00;

  Future<void> _onCancelDownload(
      CancelDownloadEvent event,
      Emitter<VideoState> emit,
      ) async {
    _cancellationToken.cancel(); // Request cancellation function for downloading video
  }


  Future<void> _onMetaDownloadVideo(
      DownloadVideoMetaDataEvent event,
      Emitter<VideoState> emit,
      ) async {
    emit(VideoDownloadInProgressState(metaData:state.metaData));
    final result = await _videoMetaDataUseCase(
      MetaDataParams(url:event.videoUrl,)
    );
    result.fold((failure) => emit(VideoDownloadFailureState(errorMessage:failure.errorMessage,metaData:state.metaData)),
            (data) => emit(VideoMetaDataLoadedState(metaData: data)));
  }// The meta data for downloading video is obtained from this function


  Future<void> _onDownloadVideo(
      DownloadVideoDataEvent event,
      Emitter<VideoState> emit,
      ) async {
    emit(VideoDownloadInProgressState(metaData:state.metaData));
    try {
      percentCheck =0.00;
      _cancellationToken.reset();
      final progressStream = _videoDownloadUseCase(
          VideoDownloadParams(fileName: event.fileName,streamInfo: event.streamInfo,cancellationToken: _cancellationToken ),
      ); //triggers  the stream for downloading video
      await for (final progress in progressStream) {
        percentCheck =progress; // data for showing linear percentage

          emit(VideoDownloadProgressState(progress: progress,metaData:state.metaData));
      }
      if (percentCheck >= 1.00){ // if download is successfully done we will start encrypting
        emit(VideoDownloadInProgressState(metaData:state.metaData));
        final filePath =  await LocalLocationUtils.getFileUrl( event.fileName);
        final status = await HeavyTaskEncryption().useIsolate(filePath: filePath); // we use the help of isolates because encrypting and decrypting videos are expensive tasks
        if(status[0] =="Ok"){
          emit(VideoDownloadSuccessState(metaData:state.metaData));
        }else{
          emit(VideoDownloadFailureState(errorMessage:status[0] ?? "",metaData:state.metaData));
        }
      }else{
        emit(VideoDownloadFailureState(errorMessage: "Download is canceled",metaData:state.metaData));

      }
    } catch (e) {
      emit(VideoDownloadFailureState(errorMessage:e.toString(),metaData:state.metaData));
    }
  }
}


class HeavyTaskEncryption {
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
      return "Ok";
    }catch(e){
      print(e);
      inFile.deleteSync();
      return "Something Went Wrong, $e";

    }

  }
}
