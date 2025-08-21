// class AppPreview extends StatefulWidget {
//   const AppPreview({super.key});

//   @override
//   State<AppPreview> createState() => _AppPreviewState();
// }

// class _AppPreviewState extends State<AppPreview> {
//   File? videoFile;
//   final VideoTrimmer videoTrimmer = VideoTrimmer();
//   ScrollController scrollController = ScrollController();
//   late VideoPlayerController videoPlayerController;
//   Duration startTime = Duration(seconds: 0);
//   Duration endTime = Duration(seconds: 10);
//   Trimmer _trimmer = Trimmer();
//   Future<List<File>?> getVideoThumbs(File? video) async {
//     try {
//       log("getting thumbs");
//       List<File>? thumbs = List.empty(growable: true);
//       await videoTrimmer.loadVideo(video!.path);
//       _trimmer.loadVideo(videoFile: video);
//       videoPlayerController = VideoPlayerController.file(video);
//       await videoPlayerController.initialize();

//       for (var position = 0;
//           position <= videoPlayerController.value.duration.inMilliseconds;
//           position += 1000) {
//         log("position $position");
//         final thumb = await videoTrimmer.getVideoThumbnail(
//             positionMs: position, quality: 60);
//         log("file path $thumb");
//         thumbs.add(File(thumb!));
//       }
//       return thumbs;
//     } catch (e) {
//       log("error $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return MaterialApp(
//         home: Scaffold(
//       body: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//               padding: EdgeInsets.all(20.0),
//               child: TextButton(
//                   onPressed: () async {
//                     FilePickerResult? result = await FilePicker.platform
//                         .pickFiles(
//                             allowMultiple: true,
//                             allowedExtensions: ["mp4"],
//                             type: FileType.custom);
//                     for (var element in result!.files) {
//                       setState(() {
//                         log("picked file path ${element.path!}");
//                         videoFile = File(element.path!);
//                       });
//                     }
//                   },
//                   child: Text("Pick video"))),
//           videoFile != null
//               ? Column(
//                   children: [
//                     FutureBuilder(
//                         future: getVideoThumbs(videoFile),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(
//                               child: Text("Loading"),
//                             );
//                           } else if (snapshot.data != null) {
//                             return Stack(
//                               children: [
//                                 Positioned.fill(
//                                     child: Column(
//                                   children: [VideoViewer(trimmer: _trimmer)],
//                                 )),
//                                 SizedBox(
//                                   height:
//                                       SizeOf.intance.getWidth(context, 0.20),
//                                   width: MediaQuery.sizeOf(context).width,
//                                   child: ListView.builder(
//                                     controller: scrollController,
//                                     scrollDirection: Axis.horizontal,
//                                     itemBuilder: (context, index) {
//                                       return Image.file(snapshot.data![index]);
//                                     },
//                                     itemCount: snapshot.data!.length,
//                                   ),
//                                 ),
//                                 TrimmerFrame(
//                                     videoDuration:
//                                         videoPlayerController.value.duration,
//                                     thumbnailViewController: scrollController,
//                                     totalWidth:
//                                         MediaQuery.of(context).size.width,
//                                     onTrimUpdated: (start, end) {
//                                       log("start $start and $end");
//                                       startTime = start;
//                                       endTime = end;
//                                     })
//                               ],
//                             );
//                           } else {
//                             return Center(
//                               child: Text("Error"),
//                             );
//                           }
//                         }),
//                   ],
//                 )
//               : SizedBox()
//         ],
//       ),
//     ));
//   }
// }

// class TrimmerFrame extends StatefulWidget {
//   final double totalWidth; // Width of the thumbnail strip
//   final Function(Duration, Duration) onTrimUpdated;
//   final Duration videoDuration;
//   final ScrollController thumbnailViewController; // Callback for parent state

//   const TrimmerFrame(
//       {super.key,
//       required this.totalWidth,
//       required this.onTrimUpdated,
//       required this.thumbnailViewController,
//       required this.videoDuration});

//   @override
//   _TrimmerFrameState createState() => _TrimmerFrameState();
// }

// class _TrimmerFrameState extends State<TrimmerFrame> {
//   double _leftHandle = 50; // Initial start position
//   double _rightHandle = 200; // Initial end position
//   final double _minTrimWidth = 50; // Minimum trim width

//   void _updateTrim() {
//     widget.onTrimUpdated(
//         _positionToDuration(_leftHandle), _positionToDuration(_rightHandle));
//   }

//   Duration _positionToDuration(double position) {
//     double adjustedPosition = position +
//         widget.thumbnailViewController.offset; // Account for scroll offset
//     double ratio = adjustedPosition / widget.totalWidth;
//     return Duration(
//         milliseconds: (ratio * widget.videoDuration.inMilliseconds).round());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: _leftHandle,
//       right: widget.totalWidth - _rightHandle,
//       child: Stack(
//         children: [
//           // Highlighted Trimming Area
//           Container(
//             height: SizeOf.intance.getHight(context, 0.20),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.red, width: 2),
//               color: Colors.red.withValues(alpha: 0.1),
//             ),
//           ),

//           // Left Handle
//           Positioned(
//             left: 0,
//             child: GestureDetector(
//               onHorizontalDragUpdate: (details) {
//                 setState(() {
//                   _leftHandle = (_leftHandle + details.delta.dx)
//                       .clamp(0.0, _rightHandle - _minTrimWidth);
//                 });
//                 _updateTrim();
//               },
//               child: Container(
//                 height: 100,
//                 width: 5,
//                 color: Colors.red,
//               ),
//             ),
//           ),

//           // Right Handle
//           Positioned(
//             right: 0,
//             child: GestureDetector(
//               onHorizontalDragUpdate: (details) {
//                 setState(() {
//                   _rightHandle = (_rightHandle + details.delta.dx)
//                       .clamp(_leftHandle + _minTrimWidth, widget.totalWidth);
//                 });
//                 _updateTrim();
//               },
//               child: Container(
//                 height: 100,
//                 width: 5,
//                 color: Colors.red,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TrimmedVideoPlayer extends StatefulWidget {
//   final VideoPlayerController videoController;
//   final Duration startTrim;
//   final Duration endTrim;

//   const TrimmedVideoPlayer({
//     super.key,
//     required this.videoController,
//     required this.startTrim,
//     required this.endTrim,
//   });

//   @override
//   _TrimmedVideoPlayerState createState() => _TrimmedVideoPlayerState();
// }

// class _TrimmedVideoPlayerState extends State<TrimmedVideoPlayer> {
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();

//     // Seek to startTrim when initializing
//     widget.videoController.seekTo(widget.startTrim);

//     // Initialize Chewie
//     _chewieController = ChewieController(
//       videoPlayerController: widget.videoController,
//       autoPlay: true,
//       looping: false, // Change to true for looping within trim range
//     );

//     // Listen for playback updates
//     widget.videoController.addListener(_checkTrimEnd);
//   }

//   // Stops video at endTrim
//   void _checkTrimEnd() {
//     if (widget.videoController.value.position >= widget.endTrim) {
//       widget.videoController.pause();
//       widget.videoController.seekTo(widget.startTrim); // Reset for replay
//     }
//   }

//   @override
//   void dispose() {
//     widget.videoController.removeListener(_checkTrimEnd);
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: _chewieController != null &&
//               _chewieController!.videoPlayerController.value.isInitialized
//           ? Chewie(controller: _chewieController!)
//           : const CircularProgressIndicator(),
//     );
//   }
// }
