import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/home/presentation/bloc/video_meta_data_bloc.dart';
import '../services/injection_container.dart';


List<SingleChildWidget> providersList = [
  BlocProvider(create: (_) => sl<VideoMetaDataBloc>(),),

];
