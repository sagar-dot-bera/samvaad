// // // ignore_for_file: must_be_immutable

// // import 'package:auto_route/auto_route.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// // import 'package:samvaad/core/themes/app_colors.dart';
// // import 'package:samvaad/core/utils/media_handler.dart';
// // import 'package:samvaad/domain/entities/message.dart';
// // import 'package:samvaad/router.gr.dart';

// // class VideoMessageOutgoingBubble extends StatefulWidget {
// //   Message message;
// //   // Message message;
// //   VideoMessageOutgoingBubble({super.key, required this.message});

// //   @override
// //   State<VideoMessageOutgoingBubble> createState() =>
// //       _VideoMessageOutgoingBubbleState();
// // }

// // class _VideoMessageOutgoingBubbleState
// //     extends State<VideoMessageOutgoingBubble> {
// //   MediaHandler mediaHandler = MediaHandler();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.end,
// //       mainAxisSize: MainAxisSize.max,
// //       children: [
// //         Container(
// //             constraints: const BoxConstraints(maxWidth: 250),
// //             decoration: BoxDecoration(
// //                 color: AppColors.neutralGrayLight,
// //                 borderRadius: const BorderRadius.only(
// //                     topRight: Radius.circular(12),
// //                     topLeft: Radius.circular(12),
// //                     bottomRight: Radius.circular(12))),
// //             child: Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     FutureBuilder(
// //                         future: mediaHandler
// //                             .getVideoThumbnailAndVideo(widget.message),
// //                         builder: (context, file) {
// //                           if (file.connectionState == ConnectionState.waiting) {
// //                             return SizedBox(
// //                               width: 200,
// //                               height: 100,
// //                               child: const Center(
// //                                 child: CircularProgressIndicator(),
// //                               ),
// //                             );
// //                           } else if (file.hasError) {
// //                             return const Text("Error");
// //                           } else {
// //                             if (file.hasData) {
// //                               return Stack(children: [
// //                                 Image.file(file.data!.thumbnail),
// //                                 Positioned.fill(
// //                                   child: Align(
// //                                     alignment: Alignment.center,
// //                                     child: FloatingActionButton.small(
// //                                       onPressed: () {
// //                                         context.router.push(VideoPlayerRoute(
// //                                             file: file.data!.video));
// //                                       },
// //                                       backgroundColor: Colors.transparent,
// //                                       elevation: 0.0,
// //                                       child: Icon(
// //                                         FeatherIcons.play,
// //                                         color: Theme.of(context)
// //                                             .colorScheme
// //                                             .primary,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 )
// //                               ]);
// //                             } else {
// //                               return const Text("No data found");
// //                             }
// //                           }
// //                         }),
// //                     const SizedBox(
// //                       width: 6.0,
// //                     ),
// //                   ],
// //                 )))
// //       ],
// //     );
// //   }
// // }

// import 'dart:io';

// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:samvaad/core/themes/app_colors.dart';
// import 'package:samvaad/core/utils/media_handler.dart';
// import 'package:samvaad/router.gr.dart';

// // ignore: must_be_immutable
