import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';

@RoutePage()
class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  VideoPlayerController? videoPlayerController;
  final _picker = ImagePicker();
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo Screen"),
      ),
      body: Column(),
    );
  }
}

class TrimmerView extends StatefulWidget {
  File file;
  TrimmerView({super.key, required this.file});

  @override
  State<TrimmerView> createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer
        .saveTrimmedVideo(
            startValue: _startValue,
            endValue: _endValue,
            onSave: (String? outputPath) {})
        .then((value) {
      setState(() {
        _progressVisibility = false;
      });
    });

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // ElevatedButton(
          //   onPressed: _progressVisibility
          //       ? null
          //       : () async {
          //           _saveVideo().then((outputPath) {
          //             print('OUTPUT PATH: $outputPath');
          //             final snackBar = SnackBar(
          //                 content: Text('Video Saved successfully'));
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               snackBar,
          //             );
          //           });
          //         },
          //   child: Text("SAVE"),
          // ),
          Center(
            child: TrimViewer(
                trimmer: _trimmer,
                viewerHeight: 70.0,
                viewerWidth: MediaQuery.of(context).size.width,
                maxVideoLength: const Duration(seconds: 10),
                onChangeStart: (value) => _startValue = value,
                onChangeEnd: (value) => _endValue = value,
                onChangePlaybackState: (value) =>
                    //setState(() => _isPlaying = value),
                    null),
          ),

          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: VideoViewer(trimmer: _trimmer)),
          ),

          // TextButton(
          //   child: _isPlaying
          //       ? Icon(
          //           Icons.pause,
          //           size: 80.0,
          //           color: Colors.white,
          //         )
          //       : Icon(
          //           Icons.play_arrow,
          //           size: 80.0,
          //           color: Colors.white,
          //         ),
          //   onPressed: () async {
          //     bool playbackState = await _trimmer.videoPlaybackControl(
          //       startValue: _startValue,
          //       endValue: _endValue,
          //     );
          //     setState(() {
          //       _isPlaying = playbackState;
          //     });
          //   },
          // )

          Padding(
            padding: const EdgeInsets.fromLTRB(9.0, 0.0, 0.0, 12.0),
            child: FloatingActionButton.extended(
                onPressed: () {},
                label: const Text(
                  "Send",
                  style: TextStyle(fontSize: 16),
                )),
          )
        ],
      ),
    );
  }
}
