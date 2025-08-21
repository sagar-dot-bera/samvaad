import 'dart:io';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:video_player/video_player.dart';

@RoutePage()
class VideoPlayerScreen extends StatefulWidget {
  File file;
  VideoPlayerScreen({super.key, required this.file});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    final file = widget.file;
    videoController = VideoPlayerController.file(file);
  }

  Future<void> setChewie() async {
    await videoController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Plying video"),
      ),
      body: Center(
        child: FutureBuilder(
            future: setChewie(),
            builder: (context, video) {
              log("video ${widget.file.path}");
              if (video.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (video.hasError) {
                return const Text("Error loading video");
              } else {
                if (video.connectionState == ConnectionState.done ||
                    video.hasData) {
                  final chewieController =
                      ChewieController(videoPlayerController: videoController);

                  if (chewieController != null) {
                    return Chewie(controller: chewieController);
                  } else {
                    return const Text("controller is null");
                  }
                } else {
                  return const Text("video not found");
                }
              }
            }),
      ),
    );
  }
}

class VideoPlayerWithTrim extends StatefulWidget {
  final String videoPath;
  final Duration startTrim; // Start position
  final Duration endTrim; // End position

  const VideoPlayerWithTrim({
    super.key,
    required this.videoPath,
    required this.startTrim,
    required this.endTrim,
  });

  @override
  _VideoPlayerWithTrimState createState() => _VideoPlayerWithTrimState();
}

class _VideoPlayerWithTrimState extends State<VideoPlayerWithTrim> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    // Initialize Video Player
    _videoPlayerController = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        // Seek to startTrim when ready
        _videoPlayerController.seekTo(widget.startTrim);
        setState(() {});
      });

    // Initialize Chewie
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    // Listen for video position updates
    _videoPlayerController.addListener(_checkTrimEnd);
  }

  void _checkTrimEnd() {
    // Pause video when reaching the end trim point
    if (_videoPlayerController.value.position >= widget.endTrim) {
      _videoPlayerController.pause();
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_checkTrimEnd);
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trimmed Video Player")),
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
