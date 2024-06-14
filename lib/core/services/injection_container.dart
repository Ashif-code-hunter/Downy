import 'package:downy/features/home/presentation/bloc/video_meta_data_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../features/home/data/datasources/remote_datasource/video_download_datasource.dart';
import '../../features/home/data/datasources/remote_datasource/video_meta_datasource.dart';
import '../../features/home/data/repositories/video_download_repo_impl.dart';
import '../../features/home/data/repositories/video_repo_impl.dart';
import '../../features/home/domain/repostitory/video_download_repos.dart';
import '../../features/home/domain/repostitory/video_meta_data_repos.dart';
import '../../features/home/domain/usecase/video_download_usecases.dart';
import '../../features/home/domain/usecase/video_meta_data_usecases.dart';

final sl = GetIt.instance;

Future<void> init() async {
   sl // App Logic
  ..registerFactory(
  () => VideoMetaDataBloc(videoMetaDataUseCase: sl(),videoDownloadUseCase: sl()))

    // Use cases
     ..registerLazySingleton(() => VideoMetaDataUseCase(sl()))
     ..registerLazySingleton(() => VideoDownloadUseCase(sl()))

    // Repositories
  ..registerLazySingleton<VideoMetaDataRepository>(
  () => VideoRepositoryImpl(sl()))
     ..registerLazySingleton<VideoDownloadRepository>(
             () => VideoDownloadRepositoryImpl(sl()))

    // Data sources
     ..registerLazySingleton<YouTubeMetaDataDataSource>(
             () => YouTubeDataSourceImpl(sl()))
     ..registerLazySingleton<YouTubeDownloadDataSource>(
             () => YouTubeDownloadDataSourceImpl(sl()))

    // External dependencies
  ..registerLazySingleton<YoutubeExplode>(() => YoutubeExplode());
}
