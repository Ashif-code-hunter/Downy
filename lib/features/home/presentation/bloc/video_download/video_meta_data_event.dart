part of 'video_meta_data_bloc.dart';

abstract class VideoMetaDataEvent extends Equatable {
  const VideoMetaDataEvent();

  @override
  List<Object> get props => [];
}

class DownloadVideoMetaDataEvent extends VideoMetaDataEvent {
  final String videoUrl;

  const DownloadVideoMetaDataEvent({required this.videoUrl});

  @override
  List<Object> get props => [videoUrl];
}

class DownloadVideoDataEvent extends VideoMetaDataEvent {
  final String fileName;
  final StreamInfo streamInfo;

  const DownloadVideoDataEvent({required this.fileName,required this.streamInfo});

  @override
  List<Object> get props => [fileName,streamInfo];
}

class CancelDownloadEvent extends VideoMetaDataEvent {}