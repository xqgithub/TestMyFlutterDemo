library crashy;

import 'package:flutter/material.dart';
import 'AlignRelative.dart';
import 'BasicComponents.dart';
import 'ChangeTransform.dart';
import 'ClipTestRoute.dart';
import 'ContainerComponents.dart';
import 'EventAndNotification.dart';
import 'FirstExample.dart';
import 'FittedBoxRoute.dart';
import 'Flexiblelayout.dart';
import 'FlowLayout.dart';
import 'FunctionalComponent.dart';
import 'LayoutBuilderAfterLayout.dart';
import 'LayoutControls.dart';
import 'LoadAssets.dart';
import 'MainDirectory.dart';
import 'PublicPracticalMethod.dart';
import 'RouteValueType.dart';
import 'RowAndColumn.dart';
import 'ScaffoldRoute.dart';
import 'ScrollableRoute.dart';
import 'StackPositioned.dart';
import 'TestCounter.dart';
import 'WidgetIntroduction.dart';
import 'WidgetStateManagement.dart';
import 'dart:async';

// void main() => runApp(const MyApp());

///程序主入口
Future<void> main() async {
  ///框架异常
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      ///开发模式
      FlutterError.dumpErrorToConsole(details);
    } else {
      ///线上模式
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  runZonedGuarded<Future<void>>(() async {
    runApp(const MyApp());
  }, (error, stackTrace) => _reportError(error, stackTrace));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'demo列表',
      theme: ThemeData(primaryColor: Colors.white),

      ///注册路由表0n
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
        "BasicComponents": (context) => BasicComponents(),
        "LayoutControls": (context) => LayoutControls(),
        "RowAndColumn": (context) => RowAndColumn(),
        "Flexible": (context) => FlexibleLayout(),
        "FlowLayout": (context) => FlowLayout(),
        "StackPositioned": (context) => StackPositioned(),
        "AlignRelative": (context) => AlignRelative(),
        "LayoutBuilderRoute": (context) => LayoutBuilderRoute(),
        "ChangeTransform": (context) => ChangeTransform(),
        "TestContainer": (context) => TestContainer(),
        "ClipTestRoute": (context) => ClipTestRoute(),
        "FittedBoxRoute": (context) => FittedBoxRoute(),
        "ScaffoldRoute": (context) => ScaffoldRoute(),
        "ScrollableRoute": (context) => ScrollableRoute(),
        "FunctionComponent": (context) => FunctionComponent(),
        "EventAndNotification": (context) => EventAndNotification(),
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

///判断是否为开发模式
bool get isInDebugMode {
  bool inDebugMode = true;
  assert(inDebugMode = true);
  return inDebugMode;
}

///可以通过接口上报错误信息
Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // print('Caught error: $error');
  LogUtils.e('Caught error =-=  $error');
  if (isInDebugMode) {
    // print(stackTrace);
    // print('In dev mode. Not sending report to Sentry.io.');
    LogUtils.e('stackTrace =-=  $stackTrace');
    return;
  }
}
