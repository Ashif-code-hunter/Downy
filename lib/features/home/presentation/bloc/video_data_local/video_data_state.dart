import 'package:equatable/equatable.dart';

import '../../../domain/entity/video_data_local_entity.dart';

abstract class VideoDataLocalState extends Equatable {
  const VideoDataLocalState();

  @override
  List<Object?> get props => [];
}

class VideoDataInitial extends VideoDataLocalState {}

class VideoDataLoading extends VideoDataLocalState {}

class VideoDataSaved extends VideoDataLocalState {
  final int id;

  const VideoDataSaved({required this.id});

  @override
  List<Object?> get props => [id];
}

class VideoDataList extends VideoDataLocalState {
  final List<VideoDataEntity> videoDataList;

  const VideoDataList({required this.videoDataList});

  @override
  List<Object?> get props => [videoDataList];
}

class VideoDataDeleted extends VideoDataLocalState {
  final bool id;

  const VideoDataDeleted({required this.id});

  @override
  List<Object?> get props => [id];
}

class VideoDataError extends VideoDataLocalState {
  final String errorMessage;

  const VideoDataError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}