import 'dart:typed_data';
import 'dart:ui';

import 'package:pdfrx/pdfrx.dart';

class Pdf {
  PdfDocument pdfFile;
  Uint8List pdfFirstPageImage;

  Pdf({required this.pdfFile, required this.pdfFirstPageImage});
}
