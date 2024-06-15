import 'package:downy/features/home/presentation/bloc/video_data_local/video_data_event.dart';
import 'package:downy/features/home/presentation/bloc/video_data_local/video_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/video_data_local_entity.dart';
import '../../../domain/usecase/video_data_local_crud_usecases/delete_video_data_local_usecases.dart';
import '../../../domain/usecase/video_data_local_crud_usecases/get_video_data_local_usecases.dart';
import '../../../domain/usecase/video_data_local_crud_usecases/save_video_data_local_usecases.dart';

class VideoDataLocalBloc extends Bloc<VideoDataLocalEvent, VideoDataLocalState> {
  final SaveVideoDataLocalUseCase  _saveVideoDataUseCase;
  final GetAllVideoDataLocalUseCase _getAllVideoDataUseCase;
  final DeleteVideoDataLocalUseCase _deleteVideoDataUseCase;

  VideoDataLocalBloc({
    required SaveVideoDataLocalUseCase saveVideoDataUseCase,
    required GetAllVideoDataLocalUseCase getAllVideoDataUseCase,
    required DeleteVideoDataLocalUseCase deleteVideoDataUseCase,
  }) : _deleteVideoDataUseCase = deleteVideoDataUseCase,
       _getAllVideoDataUseCase = getAllVideoDataUseCase,
       _saveVideoDataUseCase = saveVideoDataUseCase,
        super(VideoDataInitial()) {
    on<SaveVideoDataEvent>(_onSaveVideoData);
    on<GetAllVideoDataEvent>(_onGetAllVideoData);
    on<DeleteVideoDataEvent>(_onDeleteVideoData);
  }

  void _onSaveVideoData(
      SaveVideoDataEvent event,
      Emitter<VideoDataLocalState> emit,
      ) async {
    emit(VideoDataLoading());
    try {
      final result = await _saveVideoDataUseCase(SaveVideoParams(videoDataEntity: event.videoDataEntity));
      result.fold((failure) {
        print(failure);

           emit(VideoDataError(errorMessage: failure.toString()));},
              (data) {
        print(data);
                    emit(VideoDataSaved(id: data));
              });
    } catch (e) {
      print(e);
      emit(VideoDataError(errorMessage: e.toString()));
    }
  } // save and update data in isra

  void _onGetAllVideoData(
      GetAllVideoDataEvent event,
      Emitter<VideoDataLocalState> emit,
      ) async {
    emit(VideoDataLoading());
    try {
      final result = await _getAllVideoDataUseCase();
      result.fold((failure) => emit(VideoDataError(errorMessage: failure.toString())),
              (List<VideoDataEntity> data) => emit(VideoDataList(videoDataList: data)));
    } catch (e) {
      emit(VideoDataError(errorMessage: e.toString()));
    }
  } // get all data from isra

  void _onDeleteVideoData(
      DeleteVideoDataEvent event,
      Emitter<VideoDataLocalState> emit,
      ) async {
    emit(VideoDataLoading());
    try {
      final result = await _deleteVideoDataUseCase(DeleteVideoParams(id: event.id));
      result.fold((failure) => emit(VideoDataError(errorMessage: failure.toString())),
              (data) => emit(VideoDataDeleted(id: data)));
    } catch (e) {
      emit(VideoDataError(errorMessage: e.toString()));
    }
  } //delete data in isra
}