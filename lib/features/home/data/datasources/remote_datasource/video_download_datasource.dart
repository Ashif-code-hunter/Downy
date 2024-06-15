import 'package:dartz/dartz.dart';
import 'package:downy/features/home/domain/entity/video_entity.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/typedef.dart';

abstract class YouTubeDownloadDataSource {
  Stream<List<int>> getVideoStream(StreamInfo streamInfo);
  void dispose();
}

class YouTubeDownloadDataSourceImpl implements YouTubeDownloadDataSource {
  final YoutubeExplode _youtubeExplode;


  YouTubeDownloadDataSourceImpl(this._youtubeExplode);


  @override
  Stream<List<int>> getVideoStream(StreamInfo streamInfo) {
    return _youtubeExplode.videos.streamsClient.get(streamInfo);
  }


  @override
  void dispose() {
    _youtubeExplode.close(); // Close the YoutubeExplode instance
  }
}