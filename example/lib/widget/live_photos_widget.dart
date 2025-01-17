///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/12/27 14:57
///
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class LivePhotosWidget extends StatefulWidget {
  const LivePhotosWidget({
    Key? key,
    required this.entity,
    required this.mediaUrl,
    required this.useOrigin,
  }) : super(key: key);

  final AssetEntity entity;
  final String mediaUrl;
  final bool useOrigin;

  @override
  _LivePhotosWidgetState createState() => _LivePhotosWidgetState();
}

class _LivePhotosWidgetState extends State<LivePhotosWidget> {
  late final VideoPlayerController _controller =
      VideoPlayerController.network(widget.mediaUrl)
        ..initialize().then((_) {
          if (mounted) {
            _controller.setVolume(0);
            setState(() {});
          }
        });

  void _play() {
    _controller.play();
  }

  Future<void> _stop() async {
    await _controller.pause();
    await _controller.seekTo(Duration.zero);
  }

  Widget _buildImage(BuildContext context) {
    return Image(
      image: AssetEntityImageProvider(
        widget.entity,
        isOriginal: widget.useOrigin == true,
      ),
      loadingBuilder: (_, Widget child, ImageChunkEvent? progress) {
        if (progress != null) {
          final double? value;
          if (progress.expectedTotalBytes != null) {
            value =
                progress.cumulativeBytesLoaded / progress.expectedTotalBytes!;
          } else {
            value = null;
          }
          return Center(
            child: SizedBox.fromSize(
              size: const Size.square(30),
              child: CircularProgressIndicator(value: value),
            ),
          );
        }
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => _play(),
      onLongPressEnd: (_) => _stop(),
      child: AspectRatio(
        aspectRatio: widget.entity.size.aspectRatio,
        child: Stack(
          children: <Widget>[
            if (_controller.value.isInitialized)
              Positioned.fill(child: VideoPlayer(_controller)),
            ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: _controller,
              builder: (_, VideoPlayerValue value, Widget? child) {
                return AnimatedOpacity(
                  opacity: value.isPlaying ? 0 : 1,
                  duration: kThemeAnimationDuration,
                  child: child,
                );
              },
              child: _buildImage(context),
            ),
          ],
        ),
      ),
    );
  }
}
