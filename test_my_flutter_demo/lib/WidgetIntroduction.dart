import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'PublicPracticalMethod.dart';

///widget介绍

///自定义 StatelessWidget 组件
class WidgetIntroduction extends StatelessWidget {
  const WidgetIntroduction(
      {Key? key, required this.text, this.backgroundColor = Colors.grey})
      : super(key: key);

  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Container(
    //     color: backgroundColor,
    //     child: Text(text,
    //         style: const TextStyle(
    //             fontSize: 18.0,
    //             color: Colors.purple,
    //             decoration: TextDecoration.none)),
    //   ),
    // );

    // return ContextRoute();

    return CounterWidget();
  }
}

///Context  测试
class ContextRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Context测试"),
      ),
      body: Container(
        child: Builder(builder: (context) {
          // 在 widget 树中向上查找最近的父级`Scaffold`  widget
          Scaffold? scaffold =
              context.findAncestorWidgetOfExactType<Scaffold>();
          // 直接返回 AppBar的title， 此处实际上是Text("Context测试")
          return (scaffold?.appBar as AppBar).title!;
        }),
      ),
    );
  }
}

///State生命周期 测试
class CounterWidget extends StatefulWidget {
  const CounterWidget({Key? key, this.initValue = 0}) : super(key: key);

  final int initValue;

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  ///当 widget 第一次插入到 widget 树时会被调用，对于每一个State对象，Flutter 框架只会调用一次该回调
  @override
  void initState() {
    super.initState();
    _counter = widget.initValue;
    LogUtils.i('initState =-= ');
  }

  ///当State对象的依赖发生变化时会被调用
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LogUtils.i('didChangeDependencies =-= ');
  }

  ///主要是用于构建 widget 子树的，会在如下场景被调用:
  ///1.在调用initState()之后
  ///2.在调用didUpdateWidget()之后。
  ///3.在调用setState()之后。
  ///4.在调用didChangeDependencies()之后。
  @override
  Widget build(BuildContext context) {
    LogUtils.i('build =-= ');
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('$_counter'),

          ///点击后计数器自增
          onPressed: () {
            setState(() {
              ++_counter;
            });
          },
        ),
      ),
    );
  }

  ///在 widget 重新构建时，Flutter 框架会调用widget.canUpdate来检测 widget 树中同一位置的新旧节点，然后决定是否需要更新
  @override
  void didUpdateWidget(covariant CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    LogUtils.i('didUpdateWidget =-= ');
  }

  ///当 State 对象从树中被移除时，会调用此回调
  @override
  void deactivate() {
    super.deactivate();
    LogUtils.i('deactivate =-= ');
  }

  ///当 State 对象从树中被永久移除时调用；通常在此回调中释放资源
  @override
  void dispose() {
    super.dispose();
    LogUtils.i('dispose =-= ');
  }

  ///此回调是专门为了开发调试而提供的，在热重载(hot reload)时会被调用，此回调在Release模式下永远不会被调用
  @override
  void reassemble() {
    super.reassemble();
    LogUtils.i('reassemble =-= ');
  }
}
