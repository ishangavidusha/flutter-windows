import 'package:flutter/material.dart';
import 'package:flutter_electron/fileRepo.dart';
import 'package:flutter_electron/homePage.dart';
import 'package:flutter_electron/imageRepo.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart' as window_size;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  window_size.getWindowInfo().then((window) {
    if (window.screen != null) {
      final screenFrame = window.screen.visibleFrame;
      final width = (screenFrame.width / 2).roundToDouble() > 800.0 ? (screenFrame.width / 2).roundToDouble() : 800.0;
      final height = (screenFrame.height / 2).roundToDouble() > 600.0 ? (screenFrame.height / 2).roundToDouble() : 600.0;
      final left = ((screenFrame.width - width) / 2).roundToDouble();
      final top = ((screenFrame.height - height) / 3).roundToDouble();
      final frame = Rect.fromLTWH(left, top, width, height);
      window_size.setWindowFrame(frame);
      window_size.setWindowMinSize(Size(0.8 * width, 0.8 * height));
      window_size.setWindowMaxSize(Size(1.5 * width, 1.5 * height));
      window_size
          .setWindowTitle('Image To PDF');
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FileService(),),
        ChangeNotifierProvider(create: (_) => ImageService(),),
      ],
      child: MaterialApp(
        title: 'Image To PDF',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
