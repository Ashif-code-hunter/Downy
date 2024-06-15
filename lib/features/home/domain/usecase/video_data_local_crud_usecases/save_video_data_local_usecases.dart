import 'package:downy/core/usecase/usecase.dart';
import 'package:downy/core/utils/typedef.dart';
import 'package:equatable/equatable.dart';
import '../../entity/video_data_local_entity.dart';
import '../../repostitory/video_data_local_repo.dart';

class SaveVideoDataLocalUseCase extends UseCaseWithParams<int,SaveVideoParams>{
  final VideoDataRepositoryAbstract _videoDataRepository;

  SaveVideoDataLocalUseCase(this._videoDataRepository);
  @override
  ResultFuture<int> call(SaveVideoParams params) async {
    return await _videoDataRepository.saveVideoData(videoDataEntity: params.videoDataEntity);
  }
}
class SaveVideoParams extends Equatable{
  const SaveVideoParams({required this.videoDataEntity});
  final VideoDataEntity videoDataEntity;

  @override
  List<Object?> get props => [videoDataEntity];

}