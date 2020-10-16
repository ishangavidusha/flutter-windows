import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfFactory {
  pw.Document _pdf;

  Future<pw.Document> getPdfDoc(List<Uint8List> images) async {
    _pdf = pw.Document();
    _pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => images.map((Uint8List image) => pw.SizedBox(
          height: 400,
          width: 400,
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Flexible(
                child: pw.Container(
                  height: 360,
                  child: pw.Image(PdfImage.file(_pdf.document, bytes: image), fit: pw.BoxFit.contain),
                ),
              ),
            ]
          )
        )).toList()
      )
    );
    return _pdf;
  }

}