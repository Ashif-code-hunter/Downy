import 'package:downy/core/usecase/cancel.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../core/utils/typedef.dart';
import '../entity/video_entity.dart';

abstract class VideoDownloadRepository {
  Stream<double> downloadVideoWithProgress(
      {required String fileName,required StreamInfo streamInfo, required CancellationToken cancel});
// Future<void> encryptVideo(String filePath);
}