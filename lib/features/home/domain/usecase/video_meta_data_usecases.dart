import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entity/video_entity.dart';
import '../repostitory/video_meta_data_repos.dart';

class VideoMetaDataUseCase extends UseCaseWithParams<void,MetaDataParams> {
  final VideoMetaDataRepository _videoRepository;

  VideoMetaDataUseCase(this._videoRepository);

  @override
  ResultFuture<VideoMetaEntity> call(MetaDataParams params) async{
    return _videoRepository.getVideoMetadata(videoUrl:params.url);
  }

  // Stream<double> call(String videoUrl, StreamInfo streamInfo) async* {
  //   await videoRepository.getVideoMetadata(videoUrl);
  //   final fileStream = videoRepository.downloadVideoWithProgress(video, streamInfo);
  //
  //   await for (final progress in fileStream) {
  //     yield progress;
  //   }
  //   await videoRepository.encryptVideo(video.filePath);
  // }
}

class MetaDataParams extends Equatable{
  const MetaDataParams({required this.url});
  final String url;

  @override
  List<Object?> get props => [url];

}
