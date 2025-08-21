import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:remixicon/remixicon.dart';

import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/screens/message_screens/send_image_preview_screen.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';

@RoutePage()
// ignore: must_be_immutable
class SendFileScreen extends StatefulWidget {
  List<File> files;
  Map<String, File> fileListWithName;
  ChatHandlerViewModel messageHandlerViewModel;
  SendFileScreen(
      {super.key,
      required this.files,
      required this.messageHandlerViewModel,
      required this.fileListWithName});

  @override
  State<SendFileScreen> createState() => _SendFileScreenState();
}

class _SendFileScreenState extends State<SendFileScreen> {
  bool isLoading = false;
  int selectedIndex = 0;
  Offset? startPosition;
  List<PdfDocument> pdfDocs = List.empty(growable: true);
  final TextEditingController capitionTextControler = TextEditingController();
  final FocusNode capitionFocusNode = FocusNode();
  Future<PdfDocument> toPdfDocument(File file) async {
    log("conveting to pdfdocument ${file.path}");
    PdfDocument pdfDocument = await PdfDocument.openFile(file.path);
    return pdfDocument;
  }

  Future<List<PdfDocument>> pdfDocList(List<File> files) async {
    List<PdfDocument> tempPdfs = List.empty(growable: true);

    for (var element in files) {
      tempPdfs.add(await toPdfDocument(element));
    }
    log("number of file added ${tempPdfs.length}");
    return tempPdfs;
  }

  String getCaption() {
    String caption = capitionTextControler.text.trim();

    if (caption.isNotEmpty) {
      return caption;
    } else {
      return "NaN";
    }
  }

  Future<File?> getPdfFirstPage(PdfDocument pdf) async {
    final page = pdf.pages[0]; // First page
    final pageImage = await page.render();
    final image = pageImage != null ? await pageImage.createImage() : null;

    if (image == null) return null;

    final imgBytes = await image.toByteData(format: ImageByteFormat.png);

    if (imgBytes == null) return null;
    final outputDir = await getTemporaryDirectory();
    final outputFile = File('${outputDir.path}/first_page.png');
    await outputFile.writeAsBytes(imgBytes.buffer.asUint8List());

    return outputFile;
  }

  Future<void> sendPdfFile(File fileToSend, PdfDocument pdfDoc) async {
    log("file to upload created ${fileToSend.path}");
    String captionText = getCaption();
    String fileName = "";

    widget.fileListWithName.forEach((name, file) {
      if (file.path == fileToSend.path) {
        fileName = name;
      }
    });
    ExtraInfo extraInfo = ExtraInfo(
      fileName: fileName,
      caption: captionText,
    );
    widget.messageHandlerViewModel
        .sendMessageWithFile(fileToSend, "pdf", extraInfo);
  }

  @override
  void initState() {
    super.initState();

    pdfDocList(widget.files).then((task) {
      setState(() {
        log("setting data all to pdfDocs");
        pdfDocs.addAll(task);
        log("pdf docs size ${pdfDocs.length}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    log("loading pdf");
    //log("file path ${widget.file.path}");
    PDFViewController? controller;

    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Share file"),
        actions: [
          IconButton(
              onPressed: () {
                if (widget.files.isNotEmpty) {
                  widget.files.removeAt(selectedIndex);
                  if (widget.files.isNotEmpty) {
                    setState(() {});
                  } else {
                    getIt<AppRouter>().maybePop();
                  }
                }
              },
              icon: Icon(Remix.delete_bin_3_line))
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: isLoading,
            child: LinearProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: AppColors.neutralWhite,
            ),
          ),
          AppSpacingMedium(),
          Expanded(
              child: pdfDocs.isNotEmpty
                  ? GestureDetector(
                      onPanStart: (details) {
                        log("swipe recorded");
                        startPosition = details.globalPosition;
                      },
                      onPanEnd: (details) {
                        log("swipe ended");

                        double dx =
                            details.globalPosition.dx - startPosition!.dx;

                        setState(() {
                          log("start value ${startPosition!.dx} end value ${details.globalPosition.dx}");
                          log("dx value $dx selected ");
                          if (dx > 50) {
                            if (selectedIndex > 0) {
                              selectedIndex--;
                            }
                          }

                          if (dx < -50) {
                            if (selectedIndex < widget.files.length - 1) {
                              selectedIndex++;
                            }
                          }
                        });
                      },
                      child: PdfPageView(
                        document: pdfDocs[selectedIndex],
                        pageNumber: 1,
                      ),
                    )
                  : Center(child: CircularProgressIndicator())),
          SizedBox(
            height: 50,
            width: MediaQuery.sizeOf(context).width - 40,
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          log("new selected index and value for that $selectedIndex");
                          log("file path of selected item is ${widget.files[index].path}");
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.all(2.0),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: index == selectedIndex
                                  ? Border.all(
                                      color: AppColors.brandColorDark,
                                      width: 2.50)
                                  : Border(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              child: pdfDocs.isNotEmpty
                                  ? PdfPageView(
                                      document: pdfDocs[index], pageNumber: 1)
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    ))));
                },
                itemCount: widget.files.length,
              ),
            ),
          ),
          CapitionBox(
              capitionTextFocusNode: capitionFocusNode,
              capitionTextControler: capitionTextControler),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                    icon: const Icon(FeatherIcons.send),
                    onPressed: () async {
                      sendPdfFile(
                          widget.files[selectedIndex], pdfDocs[selectedIndex]);
                      if (widget.files.isNotEmpty) {
                        widget.files.removeAt(selectedIndex);

                        if (widget.files.isNotEmpty) {
                          setState(() {
                            selectedIndex = 0;
                            capitionTextControler.text = "";
                          });
                        }
                      }
                      if (widget.files.isEmpty) {
                        context.router.maybePop();
                      }
                    },
                    label: const Text(
                      "Send",
                      style: TextStyle(fontSize: 16.0),
                    ))),
          ),
        ],
      ),
    );
  }
}
