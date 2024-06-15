import 'package:isar/isar.dart';

import '../../../../core/usecase/fast_hash.dart';

part 'video_data_model.g.dart';

@Collection()
class VideoDataModel {
  String? id;
  Id get isarId => fastHash(id!);
  late String title;
  late String duration;
  late String downloadStatus;
  late String fileName;
  late String description;

  VideoDataModel({
    required this.title,
    required this.duration,
    required this.downloadStatus,
    required this.fileName,
    required this.description,
    required this.id,
  });
}

