part of 'video_meta_data_bloc.dart';

abstract class VideoState extends Equatable {
  final VideoMetaEntity metaData;

  const VideoState({required this.metaData});
  @override
  List<Object> get props => [metaData];
}

class VideoMetaInitial extends VideoState {
  const VideoMetaInitial({required super.metaData});

  @override
  List<Object> get props => [metaData];
}
class VideoDownloadEmpty extends VideoState {
  const VideoDownloadEmpty({required super.metaData});

  @override
  List<Object> get props => [metaData];
}




class VideoMetaDataLoadedState extends VideoState {
  const VideoMetaDataLoadedState({required super.metaData});


  @override
  List<Object> get props => [metaData];
}


class VideoDownloadInProgressState extends VideoState {
  const VideoDownloadInProgressState({required super.metaData});

  @override
  List<Object> get props => [metaData];
}



class VideoDownloadProgressState extends VideoState {
  final double progress;

  const VideoDownloadProgressState({required this.progress,required super.metaData});

  @override
  List<Object> get props => [progress,metaData];
}

class VideoDownloadSuccessState extends VideoState {
  const VideoDownloadSuccessState({required super.metaData});

  @override
  List<Object> get props => [metaData];
}


class VideoDownloadFailureState extends VideoState {
  final String errorMessage;

  const VideoDownloadFailureState({required this.errorMessage,required super.metaData});

  @override
  List<Object> get props => [errorMessage,metaData];
}