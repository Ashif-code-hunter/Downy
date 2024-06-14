import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:encrypt/encrypt.dart' as eny;

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entity/video_entity.dart';
import '../../domain/repostitory/video_meta_data_repos.dart';
import '../datasources/remote_datasource/video_meta_datasource.dart';

class VideoRepositoryImpl implements VideoMetaDataRepository {
  final YouTubeMetaDataDataSource _youTubeDataSource;

  VideoRepositoryImpl(this._youTubeDataSource);

  @override
  ResultFuture<VideoMetaEntity>  getVideoMetadata({required String videoUrl}) async {
    try{
      final videoData = await _youTubeDataSource.getVideoMetadata(videoUrl: videoUrl);
      return Right(videoData);
    }on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  // @override
  // Stream<double> downloadVideoWithProgress(Video video, StreamInfo streamInfo) async* {
  //   final fileName = '${video.id}.${streamInfo.container.name}';
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/$fileName');
  //
  //   if (file.existsSync()) {
  //     file.deleteSync();
  //   }
  //
  //   final output = file.openWrite(mode: FileMode.writeOnlyAppend);
  //   final stream = youTubeDataSource.getVideoStream(streamInfo);
  //
  //   var count = 0;
  //   final len = streamInfo.size.totalBytes;
  //
  //   await for (final data in stream) {
  //     count += data.length;
  //     final progress = (count / len);
  //     yield progress;
  //     output.add(data);
  //   }
  //
  //   await output.close();
  //
  //   video = video.copyWith(filePath: file.path);
  // }
  //
  // @override
  // Future<void> encryptVideo(String filePath) async {
  //   final fileName = filePath.split('/').last;
  //   final inFilePath = filePath;
  //   final outFilePath = filePath.replaceAll(fileName, '${fileName.split('.').first}.aes');
  //
  //   final inFile = File(inFilePath);
  //   final outFile = File(outFilePath);
  //
  //   if (!outFile.existsSync()) {
  //     await outFile.create();
  //   }
  //
  //   final videoFileContents = inFile.readAsStringSync(encoding: latin1);
  //   final key = eny.Key.fromUtf8('my 32 length key................');
  //   final iv = eny.IV.allZerosOfLength(16);
  //   final encrypter = eny.Encrypter(eny.AES(key));
  //   final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
  //   await outFile.writeAsBytes(encrypted.bytes);
  // }
}