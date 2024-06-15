import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

class VideoDataEntity extends Equatable {
  final String title;
  final String description;
  final String duration;
  final String downloadStatus;
  final String fileName;
  final String id;

  const VideoDataEntity({
    required this.title,
    required this.description,
    required this.duration,
    required this.downloadStatus,
    required this.fileName,
    required this.id
  });

  @override
  List<Object?> get props => [id, title, duration, downloadStatus, fileName, description];
}