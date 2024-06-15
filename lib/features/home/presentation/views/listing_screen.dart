import 'package:downy/core/const/go_routing_routes.dart';
import 'package:downy/core/const/sized_boxes.dart';
import 'package:downy/features/home/presentation/bloc/selected_video/selected_video_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/const/asset_manager.dart';
import '../../../../core/const/color_manger.dart';
import '../../../../core/const/font_manager.dart';
import '../../../../core/const/style_manager.dart';
import '../../../../core/const/values_manger.dart';
import '../../../common_widgets/animated_dialog_box.dart';
import '../../../common_widgets/appbar_main_widget.dart';
import '../../../common_widgets/rounded_button_widget.dart';
import 'player_screen.dart';
import '../../domain/entity/video_data_local_entity.dart';
import '../bloc/video_data_local/video_data_bloc.dart';
import '../bloc/video_data_local/video_data_event.dart';
import '../bloc/video_data_local/video_data_state.dart';
import '../bloc/video_download/video_meta_data_bloc.dart';

class ListingScreen extends HookWidget {
  const ListingScreen({super.key});


  @override
  Widget build(BuildContext context) {

  useEffect((){
    context.read<VideoDataLocalBloc>().add(GetAllVideoDataEvent());
    return null;
  },[]);


    return Scaffold(
      appBar:  PreferredSize(
        preferredSize:  Size(double.infinity, 60.h),
        child: const MainAppBarWidget(isFirstPage: false,title: "Downloaded List"),
      ),
      body: SafeArea(
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16,vertical: AppPadding.p12),
          child: BlocConsumer<VideoDataLocalBloc, VideoDataLocalState>(

            builder: (context,state) {
              if(state is VideoDataList) {
                return ListView.builder(
                itemCount: state.videoDataList.length,
                itemBuilder: (context, i) {
                  final data = state.videoDataList[i];
                  return  InkWell(
                    onTap: (){
                      context.read<SelectedVideoBloc>().add(VideoEvent(fileName: data.fileName));
                      goRoute.goNamed(AppRoute.viewScreen.name); // triggering to pull locally saved encrypted video for decrypting
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ColorManager.filledColor
                      ),
                      margin: EdgeInsets.symmetric(vertical: AppPadding.p6),
                      padding: EdgeInsets.symmetric(horizontal: AppPadding.p12,vertical: AppPadding.p8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("#${i+1}",style: getBoldStyle(color: ColorManager.secondary,fontSize: FontSize.s14),maxLines: 3,overflow: TextOverflow.ellipsis,),
                          kSizedBox2,
                          Text(data.title,style: getBoldStyle(color: ColorManager.secondary,fontSize: FontSize.s14),maxLines: 3,overflow: TextOverflow.ellipsis,),
                          kSizedBox4,
                          Text(data.description,style: getBoldStyle(color: ColorManager.black,fontSize: FontSize.s10),maxLines: 5,overflow: TextOverflow.ellipsis,),
                          kSizedBox4,
                          Text(data.duration.split(".").first,style: getBoldStyle(color: ColorManager.black,fontSize: FontSize.s10),maxLines: 5,overflow: TextOverflow.ellipsis,),
                          kSizedBox4,
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Text(data.downloadStatus,style: getBoldStyle(color: ColorManager.black,fontSize: FontSize.s12),maxLines: 5,overflow: TextOverflow.ellipsis)),

                        ],
                      ),
                    ),
                  );

                },
              );

              }else if (state is VideoDataLoading){
                 return const Center(child: CircularProgressIndicator());
              }
              return kSizedBox;
            }, listener: (BuildContext context, VideoDataLocalState state) {
             if (state is VideoDataError){
               showCustomDialog(
                 context: context,
                 isDismissible: false,
                 header: ImageAssets.failure,
                 title: "Failed",
                 desc: "Couldn't fetch downloaded list, please come back later",
                 onOkTap: (){
                   goRoute.goNamed(AppRoute.listingScreen.name);
                 },
                 okColor: ColorManager.secondary,
               );
            }
          },
          )
        ),
      ),
    );

  }

}
