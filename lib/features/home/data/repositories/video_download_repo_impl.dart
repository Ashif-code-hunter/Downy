import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:downy/core/const/string_manager.dart';
import 'package:encrypt/encrypt.dart' as eny;
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../core/usecase/cancel.dart';
import '../../../../core/utils/local_location.dart';
import '../../domain/repostitory/video_download_repos.dart';
import '../datasources/remote_datasource/video_download_datasource.dart';


class VideoDownloadRepositoryImpl implements VideoDownloadRepository {
  final YouTubeDownloadDataSource youTubeDownloadDataSource;

  VideoDownloadRepositoryImpl(this.youTubeDownloadDataSource);



  @override
  Stream<double> downloadVideoWithProgress({required String fileName,required StreamInfo streamInfo,required CancellationToken cancel,}) async* {
    Directory directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    if (file.existsSync()) {
      file.deleteSync();
    }

    final output = file.openWrite(mode: FileMode.writeOnlyAppend);
    print("ddd4");

    final stream = youTubeDownloadDataSource.getVideoStream(streamInfo);
    var count = 0;
    final len = streamInfo.size.totalBytes;
    await for (final data in stream) {
      if (cancel.isCancellationRequested) {
        // Handle cancellation logic here
        print("Download is cancelled");
        output.close(); // cancellation of download
        break;
      }
      count += data.length;// keep track of the total number of bytes downloaded so far.
      final progress = (count / len) ;
      yield progress; //calculating the progress by checking streams length and downloaded bytes
      output.add(data);
    }
    await output.close();


  }


}