import 'package:dartz/dartz.dart';
import 'package:downy/features/home/domain/entity/video_entity.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/typedef.dart';

abstract class YouTubeMetaDataDataSource {
  Future<VideoMetaEntity>  getVideoMetadata({required String videoUrl});
}

class YouTubeDataSourceImpl implements YouTubeMetaDataDataSource {
  final YoutubeExplode youtubeExplode;

  YouTubeDataSourceImpl(this.youtubeExplode);

  @override
  Future<VideoMetaEntity> getVideoMetadata({required String videoUrl}) async {
   try{
     final id = VideoId(videoUrl.trim());
     final video = await youtubeExplode.videos.get(id);
     var streamManifest = await youtubeExplode.videos.streamsClient.getManifest(id);
     var streamInfo = streamManifest.muxed.bestQuality;
    return  VideoMetaEntity(
       id: video.id.toString(),
       title: video.title,
       duration: video.duration ?? const Duration(seconds: 0),
       videoUrl: videoUrl, downloadStatus: 'Downloading',
      fileName: '${video.id}.${streamInfo.container.name}',
      muxedStreamInfo: streamInfo,
      streamManifest: streamManifest
     );
   }catch(e){
     throw APIException(
         message: 'Unexpected error: ${e.toString()}', statusCode: 404);
   }

  }
}