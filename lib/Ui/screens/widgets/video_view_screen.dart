import 'youtube_player_widget.dart';
import '../../../utils/Extensions/extensions.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

import '../../../utils/helper_utils.dart';

class VideoViewScreen extends StatelessWidget {
  final String videoUrl;
  final FlickManager? flickManager;
  const VideoViewScreen({
    Key? key,
    required this.videoUrl,
    this.flickManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: context.color.teritoryColor),
        ),
        backgroundColor: context.color.backgroundColor,
        body: Center(
          child: HelperUtils.checkVideoType(
            videoUrl,
            onYoutubeVideo: () {
              return YoutubePlayerWidget(
                videoUrl: videoUrl,
                onLandscape: () {},
                onPortrate: () {},
              );
            },
            onOtherVideo: () {
              if (flickManager != null) {
                return FlickVideoPlayer(flickManager: flickManager!);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
