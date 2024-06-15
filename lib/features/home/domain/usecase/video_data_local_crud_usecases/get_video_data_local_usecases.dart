import 'package:downy/core/usecase/usecase.dart';
import 'package:downy/core/utils/typedef.dart';

import '../../entity/video_data_local_entity.dart';
import '../../repostitory/video_data_local_repo.dart';

class GetAllVideoDataLocalUseCase extends UseCaseWithoutParams<List<VideoDataEntity>>{
  final VideoDataRepositoryAbstract _videoDataRepository;

  GetAllVideoDataLocalUseCase(this._videoDataRepository);

  @override
  ResultFuture<List<VideoDataEntity>> call() async {
    return await _videoDataRepository.getAllVideoData();
  }
}