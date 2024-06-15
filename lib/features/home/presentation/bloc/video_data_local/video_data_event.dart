import 'package:equatable/equatable.dart';

import '../../../domain/entity/video_data_local_entity.dart';

abstract class VideoDataLocalEvent extends Equatable {
  const VideoDataLocalEvent();

  @override
  List<Object?> get props => [];
}

class SaveVideoDataEvent extends VideoDataLocalEvent {
  final VideoDataEntity videoDataEntity;

  const SaveVideoDataEvent(this.videoDataEntity);

  @override
  List<Object?> get props => [videoDataEntity];
}

class GetAllVideoDataEvent extends VideoDataLocalEvent {}

class DeleteVideoDataEvent extends VideoDataLocalEvent {
  final int id;

  const DeleteVideoDataEvent(this.id);

  @override
  List<Object?> get props => [id];
}