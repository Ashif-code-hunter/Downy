import 'package:equatable/equatable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoMetaEntity extends Equatable {
  final String id;
  final String title;
  final Duration duration;
  final String videoUrl;
  final String downloadStatus;
  final String fileName;
  final MuxedStreamInfo muxedStreamInfo;
  final StreamManifest streamManifest;

  const VideoMetaEntity( {
    required this.id,
    required this.title,
    required this.duration,
    required this.videoUrl,
    required this.downloadStatus,
    required this.fileName,
    required this.muxedStreamInfo,
    required this.streamManifest,
  });


  @override
  List<Object?> get props => [id,title,duration,videoUrl,downloadStatus,
    fileName,muxedStreamInfo,streamManifest];
}