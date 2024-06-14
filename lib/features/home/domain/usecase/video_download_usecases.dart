import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../../../core/usecase/cancel.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entity/video_entity.dart';
import '../repostitory/video_download_repos.dart';
import '../repostitory/video_meta_data_repos.dart';

class VideoDownloadUseCase extends UseCaseWithParamsStream<double,VideoDownloadParams> {
  final VideoDownloadRepository _videoDownloadRepository;
  VideoDownloadUseCase(this._videoDownloadRepository);

  @override

  Stream<double> call(VideoDownloadParams params) async* {
    try {
      final fileStream = _videoDownloadRepository.downloadVideoWithProgress(
        fileName: params.fileName,
        streamInfo: params.streamInfo,
        cancel: params.cancellationToken
      );
      await for (final progress in fileStream) {
        if (params.cancellationToken.isCancellationRequested) {
          // Handle cancellation logic here
          break;
        }
        yield progress;
      }
    } catch (e) {
      throw Exception('Failed to download video: $e');
    }
  }
}

class VideoDownloadParams extends Equatable{
  const VideoDownloadParams({required this.fileName,required this.streamInfo,required this.cancellationToken});
  final String fileName;
  final StreamInfo streamInfo;
  final CancellationToken cancellationToken;


  @override
  List<Object?> get props => [fileName,streamInfo];

}
