import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_electron/editView.dart';
import 'package:flutter_electron/fileRepo.dart';
import 'package:flutter_electron/imageRepo.dart';
import 'package:flutter_electron/pdfRepo.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as im;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FileService _fileService;
  PdfFactory _pdfFactory = PdfFactory();
  bool converting = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;
    _fileService = Provider.of<FileService>(context);
    return Scaffold(
      backgroundColor: Color(0xfff8f3f9),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Image To PDF Converter',
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                       color: Color(0xff20201f)
                     ),
                  ),
                ),
                Container(
                  width: devWidth,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        '*Less Images, Best Performance',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent
                        ),
                      ),
                      Spacer(),
                      RaisedButton(
                        onPressed: () async {
                         bool result = await _fileService.getFiles(false);
                        },
                        color: Color(0xff6e5ced),
                        child: Text(
                          'Select',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: devWidth,
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    height: devHeight * 0.6,
                    width: devWidth * 0.95,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10, 
                      ),
                      itemCount: _fileService.fileList.isNotEmpty ? _fileService.fileList.length : 0,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                loading = true;
                              });
                              await Future.delayed(Duration(seconds: 1));
                              im.Image image = im.decodeImage(_fileService.fileList[index]);
                              Provider.of<ImageService>(context, listen: false).setImage(image);
                              Uint8List result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditView(image: image,)),
                              );
                              if (result != null) {
                                setState(() {
                                  _fileService.fileList[index] = result;
                                });
                              }
                              setState(() {
                                loading = false;
                              });
                            },
                            child: Image.memory(_fileService.fileList[index], fit: BoxFit.cover,),
                          )
                        );
                      },
                    )
                  ),
                ),
                Container(
                  width: devWidth,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: _fileService.fileList.isNotEmpty ? RaisedButton(
                    color: Color(0xff6e5ced),
                    onPressed: () async {
                      bool result = await _fileService.getFiles(true);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Add More',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ],
                    )
                  ) : SizedBox(
                    height: 40,
                  ),
                ),
                Container(
                  width: devWidth,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      _fileService.fileList.isNotEmpty ? converting ? Row(
                        children: [
                          Text(
                            'Working...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ) : Text(
                        'Ready',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold
                        ),
                      ) : Text(
                        'Images Not Selected',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      RaisedButton(
                        color: Color(0xff6e5ced),
                        onPressed:_fileService.fileList.isNotEmpty ? () async {
                          setState(() {
                            converting = true;
                          });
                          pw.Document document = await _pdfFactory.getPdfDoc(_fileService.fileList);
                          String fileName = DateFormat("yyyyMMddhhmmss").format(DateTime.now());
                          _fileService.saveFile(document.save(), fileName);
                          // download(document.save(), downloadName: '$fileName.pdf');
                          setState(() {
                            converting = false;
                          });
                        } : null,
                        child: Text(
                          'Convert',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: loading ? Container(
              width: devWidth,
              height: devHeight,
              color: Colors.black12,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ) : SizedBox(),
          ),
        ],
      ),
    );
  }
}