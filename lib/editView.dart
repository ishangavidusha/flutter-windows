import 'package:flutter/material.dart';
import 'package:flutter_electron/imageRepo.dart';
import 'package:image/image.dart' as im;
import 'package:provider/provider.dart';

class EditView extends StatefulWidget {
  final im.Image image;
  const EditView({Key key, this.image}) : super(key: key);
  @override
  _EditViewState createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  ImageService _imageService;
  int widthValue;
  int maxWidth;
  bool isPortrait = false;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;
    _imageService = Provider.of<ImageService>(context);
    if (widthValue == null || maxWidth == null) {
      widthValue = _imageService.width;
      maxWidth = _imageService.width * 2;
    }
    isPortrait = _imageService.width > _imageService.height ? false : true;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff6e5ced),),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () async {
                Navigator.pop(context, _imageService.getImage());
              },
              color: Color(0xff6e5ced),
              child: Row(
                children: [
                  Icon(Icons.done, color: Colors.white,),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        title: Text(
          'Edit Image',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff20201f)
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: devHeight * 0.1,
            width: devWidth,
            left: 0,
            child: Center(
              child: Stack(
                children: [
                  Container(
                    width: devWidth * 0.8,
                    height: devHeight * 0.6,
                    child: _imageService.getImage() != null ? Image.memory(
                      _imageService.getImage(),
                      fit: isPortrait ? BoxFit.fitHeight : BoxFit.fitWidth,
                    ) : Container(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red[700],
                  inactiveTrackColor: Colors.red[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Colors.redAccent,
                  overlayColor: Colors.red.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.red[700],
                  inactiveTickMarkColor: Colors.red[100],
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.redAccent,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  min: 0.0,
                  max: maxWidth.toDouble(),
                  value: widthValue.toDouble(),
                  divisions: 50,
                  onChangeEnd: (value) {
                    Map<String, dynamic> result = _imageService.resize(value.toInt(), _imageService.height);
                    setState(() {
                      widthValue = result['width'];
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      widthValue = value.toInt();
                    });
                  },
                  label: '${_imageService.width}',
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: devWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      _imageService.rotate(90);
                    },
                    color: Color(0xff6e5ced),
                    child: Row(
                      children: [
                        Icon(Icons.rotate_right, color: Colors.white,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Rotate Right',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      _imageService.rotate(-90);
                    },
                    color: Color(0xff6e5ced),
                    child: Row(
                      children: [
                        Icon(Icons.rotate_left, color: Colors.white,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Rotate Left',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      
                    },
                    color: Color(0xff6e5ced),
                    child: Row(
                      children: [
                        Icon(Icons.rotate_left, color: Colors.white,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Crop',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: _imageService.loading ? Container(
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