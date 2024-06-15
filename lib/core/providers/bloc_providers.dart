import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import '../../features/home/presentation/bloc/selected_video/selected_video_bloc.dart';
import '../../features/home/presentation/bloc/video_data_local/video_data_bloc.dart';
import '../../features/home/presentation/bloc/video_download/video_meta_data_bloc.dart';
import '../services/injection_container.dart';


List<SingleChildWidget> providersList = [
  BlocProvider(create: (_) => sl<VideoMetaDataBloc>(),),
  BlocProvider(create: (_) => sl<VideoDataLocalBloc>(),),
  BlocProvider(create: (_) => sl<SelectedVideoBloc>(),),

];
