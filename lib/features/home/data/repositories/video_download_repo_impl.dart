import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:downy/core/const/string_manager.dart';
import 'package:encrypt/encrypt.dart' as eny;
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../core/utils/local_location.dart';
import '../../domain/repostitory/video_download_repos.dart';
import '../datasources/remote_datasource/video_download_datasource.dart';


class VideoDownloadRepositoryImpl implements VideoDownloadRepository {
  final YouTubeDownloadDataSource youTubeDownloadDataSource;

  VideoDownloadRepositoryImpl(this.youTubeDownloadDataSource);



  @override
  Stream<double> downloadVideoWithProgress({required String fileName,required StreamInfo streamInfo}) async* {
    Directory directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    if (file.existsSync()) {
      file.deleteSync();
    }

    final output = file.openWrite(mode: FileMode.writeOnlyAppend);
    final stream = youTubeDownloadDataSource.getVideoStream(streamInfo);
    var count = 0;
    final len = streamInfo.size.totalBytes;
    await for (final data in stream) {
      count += data.length;
      final progress = (count / len) ;
      yield progress;
      output.add(data);
    }
    await output.close();


  }


}