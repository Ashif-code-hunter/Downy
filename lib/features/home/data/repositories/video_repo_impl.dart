import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:encrypt/encrypt.dart' as eny;

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entity/video_entity.dart';
import '../../domain/repostitory/video_meta_data_repos.dart';
import '../datasources/remote_datasource/video_meta_datasource.dart';

class VideoMetaDataRepositoryImpl implements VideoMetaDataRepository {
  final YouTubeMetaDataDataSource _youTubeDataSource;

  VideoMetaDataRepositoryImpl(this._youTubeDataSource);

  @override
  ResultFuture<VideoMetaEntity>  getVideoMetadata({required String videoUrl}) async {
    try{
      final videoData = await _youTubeDataSource.getVideoMetadata(videoUrl: videoUrl);
      return Right(videoData);
    }on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}