part of 'video_meta_data_bloc.dart';

abstract class VideoState extends Equatable {
  const VideoState();
  @override
  List<Object> get props => [];
}

class VideoMetaInitial extends VideoState {}
class VideoDownloadEmpty extends VideoState {}




class VideoMetaDataLoadedState extends VideoState {
  const VideoMetaDataLoadedState({required this.metaData});

  final VideoMetaEntity metaData;

  @override
  List<Object> get props => [metaData];
}


class VideoDownloadInProgressState extends VideoState {}



class VideoDownloadProgressState extends VideoState {
  final double progress;

  const VideoDownloadProgressState({required this.progress});

  @override
  List<Object> get props => [progress];
}

class VideoDownloadSuccessState extends VideoState {}


class VideoDownloadFailureState extends VideoState {
  final String errorMessage;

  const VideoDownloadFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}