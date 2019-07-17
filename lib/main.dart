import 'package:flutter/material.dart';
import 'package:cosplay_app/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _controllerOpacity;
  AnimationController _controllerScale;
  Animation _animationOpacity;
  Animation<double> _animationScale;

  @override
  void initState() {
    super.initState();
    _controllerOpacity = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _animationOpacity = Tween(begin: 0.0, end: 1.0).animate(_controllerOpacity);
    _controllerOpacity.forward();

    _controllerScale = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animationScale =
        Tween<double>(begin: 0.8, end: 1.0).animate(_controllerScale)
          ..addListener(() {
            setState(() {});
          });
    _controllerScale.forward();
  }

  @override
  void dispose() {
    _controllerOpacity.dispose();
    _controllerScale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomPaint(
              painter: ShapesPainter(),
              child: Container(height: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LoginScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = Colors.cyanAccent;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    Path path = Path();
    path.lineTo(0, size.height - 500);
    path.lineTo(size.width, 0);
    // close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);

    final initDistance = size.width - 200;
    final initDistanceY = size.height - 550;

    canvas.drawCircle(Offset(initDistance + 50, initDistanceY), 20.0, paint);
    canvas.drawCircle(Offset(initDistance + 100, initDistanceY), 20.0, paint);
    canvas.drawCircle(Offset(initDistance + 150, initDistanceY), 20.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
