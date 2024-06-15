
import 'package:dartz/dartz.dart';
import 'package:downy/core/utils/typedef.dart';
import 'package:isar/isar.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entity/video_data_local_entity.dart';
import '../../domain/repostitory/video_data_local_repo.dart';
import '../models/video_data_model.dart';
import '../datasources/local_datasource/video_data_local_datasource.dart';

class VideoDataRepository implements VideoDataRepositoryAbstract {
  final VideoDataDao _videoDataDao;

  VideoDataRepository(this._videoDataDao);

  @override
  ResultFuture<int> saveVideoData({required VideoDataEntity videoDataEntity}) async {
 try{
   final result =  await _videoDataDao.insertVideoData(
     VideoDataModel(
       title: videoDataEntity.title,
       duration: videoDataEntity.duration,
       downloadStatus: videoDataEntity.downloadStatus,
       fileName: videoDataEntity.fileName,
       description: videoDataEntity.description,
       id:videoDataEntity.fileName
     ),
   );
   return Right(result);
 }on APIException catch (e) {
   return Left(APIFailure.fromException(e));
 } // saving to isra to local database

  }

  @override
  ResultFuture<List<VideoDataEntity>> getAllVideoData() async {
    try{
      final videoDataModels = await _videoDataDao.getAllVideoData();
      return Right(videoDataModels.map((model) => VideoDataEntity(
        id: model.fileName,
        title: model.title,
        duration: model.duration,
        downloadStatus: model.downloadStatus,
        fileName: model.fileName,
        description: model.description,
      )).toList());
    }on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }

  } // fetching from isra local database

  @override
  ResultFuture<bool> deleteVideoData({required int id}) async {
    try{
      final result = await _videoDataDao.deleteVideoData(id);
      return Right(result);
    }on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  // deleting from isra
  }
}