import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/errors/exception.dart';
import '../../models/video_data_model.dart';

class VideoDataDao {
  static late Isar isar;


  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    isar = await Isar.open([VideoDataModelSchema], directory: directory.path);

  } // initializing function for isra in main.dart

  Future<int> insertVideoData(VideoDataModel videoData) async {
    try{

      return await isar.writeTxn(() => isar.videoDataModels.put(videoData));
    }catch(e){
      throw APIException(message: 'Unexpected error: ${e.toString()}', statusCode: 404);
    }
  }

  Future<List<VideoDataModel>> getAllVideoData() async {
    try{
      return await isar.videoDataModels.where().findAll();

    }catch(e){
    throw APIException(
    message: 'Unexpected error: ${e.toString()}', statusCode: 404);
    }
  }


  Future<bool> deleteVideoData(int id) async {
    try{
      return await isar.writeTxn(() =>isar.videoDataModels.delete(id)) ;

    }catch(e){
        throw APIException(
          message: 'Unexpected error: ${e.toString()}', statusCode: 404);
    }
  }

}