part of 'selected_video_bloc.dart';

@immutable

abstract class SelectedVideoEvent extends Equatable {
  const SelectedVideoEvent();

  @override
  List<Object?> get props => [];
}

class VideoEvent extends SelectedVideoEvent {
  final String fileName;

  const VideoEvent({required this.fileName});

  @override
  List<Object?> get props => [fileName];
}