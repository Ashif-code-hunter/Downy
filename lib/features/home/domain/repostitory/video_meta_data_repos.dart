import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../core/utils/typedef.dart';
import '../entity/video_entity.dart';

abstract class VideoMetaDataRepository {
  ResultFuture<VideoMetaEntity> getVideoMetadata({required String videoUrl});
  // Future<void> encryptVideo(String filePath);
}