import 'dart:io';
import 'dart:typed_data';
import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/cupertino.dart';

class FileService with ChangeNotifier {
  List<Uint8List> fileList = List();

  Future<bool> getFiles(bool add) async {
    if (!add) {
      fileList = List();
    }
    FileChooserResult result = await showOpenPanel(
      allowsMultipleSelection: true,
      allowedFileTypes: <FileTypeFilterGroup> [
        FileTypeFilterGroup(
          label: 'Images',
          fileExtensions: <String> [
            'jpeg',
            'jpg',
            'png',
          ]
        )
      ]
    );
    if (result.canceled != true) {
      result.paths.forEach((element) {
        File file = File(element);
        Uint8List bytes = file.readAsBytesSync();
        fileList.add(bytes);
      });
      notifyListeners();
      return true;
    } else {
      fileList = List();
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveFile(Uint8List byteData, String fileName) async {
    FileChooserResult result = await showSavePanel(
      suggestedFileName: fileName + '.pdf',
      allowedFileTypes: <FileTypeFilterGroup> [
        FileTypeFilterGroup(
          label: 'Document',
          fileExtensions: <String> [
            'pdf',
          ]
        )
      ]
    );
    if (result.canceled != true) {
      File file = File(result.paths[0]);
      file.writeAsBytesSync(byteData);
      return true;
    } else {
      return false;
    }
  }
}