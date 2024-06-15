import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../features/home/data/datasources/local_datasource/video_data_local_datasource.dart';
import '../../features/home/data/datasources/remote_datasource/video_download_datasource.dart';
import '../../features/home/data/datasources/remote_datasource/video_meta_datasource.dart';
import '../../features/home/data/repositories/video_data_local_repo_impl.dart';
import '../../features/home/data/repositories/video_download_repo_impl.dart';
import '../../features/home/data/repositories/video_repo_impl.dart';
import '../../features/home/domain/repostitory/video_data_local_repo.dart';
import '../../features/home/domain/repostitory/video_download_repos.dart';
import '../../features/home/domain/repostitory/video_meta_data_repos.dart';
import '../../features/home/domain/usecase/video_data_local_crud_usecases/delete_video_data_local_usecases.dart';
import '../../features/home/domain/usecase/video_data_local_crud_usecases/get_video_data_local_usecases.dart';
import '../../features/home/domain/usecase/video_data_local_crud_usecases/save_video_data_local_usecases.dart';
import '../../features/home/domain/usecase/video_download_usecases.dart';
import '../../features/home/domain/usecase/video_meta_data_usecases.dart';
import '../../features/home/presentation/bloc/selected_video/selected_video_bloc.dart';
import '../../features/home/presentation/bloc/video_data_local/video_data_bloc.dart';
import '../../features/home/presentation/bloc/video_download/video_meta_data_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
   sl // App Logic
  ..registerFactory(
  () => VideoMetaDataBloc(videoMetaDataUseCase: sl(),videoDownloadUseCase: sl()))
     ..registerFactory(
             () => VideoDataLocalBloc(deleteVideoDataUseCase: sl(),getAllVideoDataUseCase: sl(),saveVideoDataUseCase: sl()))
     ..registerFactory(
             () => SelectedVideoBloc())
    // Use cases
     ..registerLazySingleton(() => VideoMetaDataUseCase(sl()))
     ..registerLazySingleton(() => VideoDownloadUseCase(sl()))
     ..registerLazySingleton(() => DeleteVideoDataLocalUseCase(sl()))
     ..registerLazySingleton(() => GetAllVideoDataLocalUseCase(sl()))
     ..registerLazySingleton(() => SaveVideoDataLocalUseCase(sl()))

    // Repositories
  ..registerLazySingleton<VideoMetaDataRepository>(
  () => VideoMetaDataRepositoryImpl(sl()))
     ..registerLazySingleton<VideoDownloadRepository>(
             () => VideoDownloadRepositoryImpl(sl()))
     ..registerLazySingleton<VideoDataRepositoryAbstract>(
             () => VideoDataRepository(sl()))
    // Data sources
     ..registerLazySingleton<YouTubeMetaDataDataSource>(
             () => YouTubeDataSourceImpl(sl()))
     ..registerLazySingleton<YouTubeDownloadDataSource>(
             () => YouTubeDownloadDataSourceImpl(sl()))
     ..registerLazySingleton<VideoDataDao>(() => VideoDataDao())

    // External dependencies
  ..registerLazySingleton<YoutubeExplode>(() => YoutubeExplode());
}
