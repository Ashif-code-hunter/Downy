
import 'package:downy/core/utils/typedef.dart';

import '../entity/video_data_local_entity.dart';

abstract class VideoDataRepositoryAbstract {
  ResultFuture<int> saveVideoData({required VideoDataEntity videoDataEntity});
  ResultFuture<List<VideoDataEntity>> getAllVideoData();
  ResultFuture<bool> deleteVideoData({required int id});
}