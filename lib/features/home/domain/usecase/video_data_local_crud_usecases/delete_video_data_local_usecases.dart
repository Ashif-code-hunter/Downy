
import 'package:downy/core/usecase/usecase.dart';
import 'package:downy/core/utils/typedef.dart';
import 'package:equatable/equatable.dart';

import '../../repostitory/video_data_local_repo.dart';

class DeleteVideoDataLocalUseCase extends UseCaseWithParams<bool,DeleteVideoParams>{
  final VideoDataRepositoryAbstract _videoDataRepository;

  DeleteVideoDataLocalUseCase(this._videoDataRepository);
@override
  ResultFuture<bool> call(DeleteVideoParams params) async {
    return await _videoDataRepository.deleteVideoData(id:params.id);
  }
}

class DeleteVideoParams extends Equatable{
  const DeleteVideoParams({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];

}