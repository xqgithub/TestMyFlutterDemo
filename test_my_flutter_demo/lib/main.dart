import 'package:flutter/material.dart';
import 'FirstExample.dart';
import 'LoadAssets.dart';
import 'MainDirectory.dart';
import 'RouteValueType.dart';
import 'TestCounter.dart';
import 'WidgetIntroduction.dart';
import 'WidgetStateManagement.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'demo列表',
      theme: ThemeData(primaryColor: Colors.white),

      ///注册路由表
      routes: {
        ///首页用 / 命名
        "/": (context) => Directory(),
        "FirstExample": (context) => RandomWords(),
        "EchoRoute": (context) => EchoRoute(),
        "TipRoute": (context) => TipRoute(
            text: (ModalRoute.of(context)?.settings.arguments).toString()),
        "TestCounter": (context) => TestCounter(),
        "WidgetIntroduction": (context) =>
            const WidgetIntroduction(text: 'Widget的介绍'),
        "WidgetStateManagement": (context) => WidgetStateManagement(),
        "LoadAssets": (context) => LoadAssets(),
      },

      ///如果路由表中没有注册，才会调用
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          String? routeName = settings.name;
          if (routeName == "RoutePassValue") {
            return RoutePassValue();
          } else {
            return Directory();
          }
        });
      },
    );
  }
}
