import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/question_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/question': (context) => QuestionScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}

//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//  AnimationController _controllerOpacity;
//  AnimationController _controllerScale;
//  Animation _animationOpacity;
//  Animation<double> _animationScale;
//
//  @override
//  void initState() {
//    super.initState();
//    _controllerOpacity = AnimationController(
//      vsync: this,
//      duration: Duration(seconds: 5),
//    );
//    _animationOpacity = Tween(begin: 0.0, end: 1.0).animate(_controllerOpacity);
//    _controllerOpacity.forward();
//
//    _controllerScale = AnimationController(
//      vsync: this,
//      duration: Duration(seconds: 1),
//    );
//    _animationScale =
//        Tween<double>(begin: 0.8, end: 1.0).animate(_controllerScale)
//          ..addListener(() {
//            setState(() {});
//          });
//    _controllerScale.forward();
//  }
//
//  @override
//  void dispose() {
//    _controllerOpacity.dispose();
//    _controllerScale.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: SafeArea(
//        child: LoginScreen(),
//      ),
//    );
//  }
//}
