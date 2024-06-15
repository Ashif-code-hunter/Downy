part of 'selected_video_bloc.dart';

@immutable

abstract class SelectedVideoState extends Equatable {
  const SelectedVideoState();

  @override
  List<Object?> get props => [];
}

class SelectedVideoInitial extends SelectedVideoState {}
class SelectedVideoLoading extends SelectedVideoState {}
class SelectedVideoLoaded extends SelectedVideoState {
  final Uint8List videoDataList;

  const SelectedVideoLoaded({required this.videoDataList});

  @override
  List<Object?> get props => [videoDataList];
}

class SelectedVideoError extends SelectedVideoState {
final String errorMessage;

const SelectedVideoError({required this.errorMessage});

@override
List<Object?> get props => [errorMessage];
}

