import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:radioplenitudesvie/consts/app_images.dart';
import 'package:radioplenitudesvie/models/torrent_cover_model.dart';
import 'package:radioplenitudesvie/pages/dashboard/dashboard_page.dart';
import 'package:radioplenitudesvie/routes/app_pages.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import '../../../consts/app_defaults.dart';
import 'package:get/route_manager.dart';

import '../../audio_helpers/audio_handler.dart';
import '../../utils/ui_helper.dart';
import '../dashboard/dashboard_controller.dart';
import '../torrent_screen/torrent_view.dart';

final DashboardController dashboardController = Get.put(DashboardController());

class ThoughtCoover extends StatelessWidget {
  String cover;
  List<dynamic> contentList;
   ThoughtCoover({
    required this.cover,
    required this.contentList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final storyController = StoryController();
    return   Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        child:Stack(children: [
          ClipRRect(
              borderRadius: AppDefaults.defaultBottomSheetRadius,
              child: InkWell(
                child:
                SizedBox(
                  width: Get.width * 0.9,
                  child:
                  AspectRatio(
                    aspectRatio: 12 / 15,
                    child:
                    cover.isNotEmpty?
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: cover,
                      placeholder: (context, url) => const SpinKitThreeBounce(
                        color: Colors.redAccent,
                        size: 50.0,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    )
                        :Image.asset(AppImages.COVER2, fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  onStoryTap(context,contentList,storyController);
                },
              )),
          Positioned(
              top: 0.0,
              right: 0.0,
              child: Row(children: [
                IconButton(
                  onPressed: () {
                    onStoryTap(context, contentList, storyController);
                  },
                  icon: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      size:15,
                      Icons.expand_sharp,
                      color: Colors.white,
                    ),
                  ),
                )
              ],))
        ],)
    );
  }
}


onStoryTap(BuildContext context,List<dynamic> contentList,StoryController storyController){
  tpvPlayer.pause();
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return
        Obx(() =>
            CupertinoPageScaffold(
              navigationBar: const CupertinoNavigationBar(),
              child:
              Stack(
                children: [
                  StoryView(
                    storyItems: contentList
                        .where((videoUrl) => videoUrl['link'] != null || videoUrl['imagelink'] != null)
                        .map((videoUrl) {
                      return
                        AppUiHelper()
                            .fileExention(videoUrl['name'].toString().toLowerCase())
                            .contains("mp4") ?
                        StoryItem.pageVideo(
                          videoUrl['link'].toString(),
                          duration:const Duration(seconds: 30),
                          controller: storyController,
                        ):
                        StoryItem.inlineImage(
                          duration:const Duration(seconds: 10),
                          controller: storyController, url: videoUrl['imagelink'].toString(),
                        );
                    }).toList(),

                    onStoryShow: (s) {
                      storyController.play();
                    },
                    onComplete: () {
                      Navigator.of(context).pop();
                    },
                    progressPosition: ProgressPosition.top,
                    repeat: false,
                    controller: storyController,
                  ),
                ],
              ),
            ));
    },
  );
}