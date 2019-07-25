import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/register_screen.dart';
import 'screens/question_screen.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        primaryColor: Colors.cyan[300],
        accentColor: Colors.limeAccent[200],
        buttonColor: Colors.cyan[300],
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/question': (context) => QuestionScreen(),
        '/main': (context) => MainScreen(),
        '/register': (context) => RegisterScreen(),
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
