import 'package:flutter/material.dart';

///空间适配FittedBox

class FittedBoxRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MyFittedBox();
    return SingleRowZoomLayout();
  }
}

class MyFittedBox extends StatefulWidget {
  @override
  _MyittedBox createState() => _MyittedBox();
}

class _MyittedBox extends State<MyFittedBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("空间适配FittedBox"),
      ),
      body: Center(
        child: Column(
          children: [
            wContainer(BoxFit.none),
            Text('海贼王路飞'),
            wContainer(BoxFit.contain),
            Text('皇副索隆'),
          ],
        ),
      ),
    );
  }
}

///单行缩放布局
class SingleRowZoomLayout extends StatefulWidget {
  @override
  _SingleRowZoomLayout createState() => _SingleRowZoomLayout();
}

class _SingleRowZoomLayout extends State<SingleRowZoomLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("单行缩放布局"),
      ),
      body: Center(
        child: Column(
          children: [
            //会溢出屏幕
            wRow(" 一二三四五六七八九十哇哈哈 "),
            //不会溢出，字体缩小
            FittedBox(child: wRow(" 一二三四五六七八九十哇哈哈 ")),
            wRow(' 一二三四五六七 '),
            FittedBox(child: wRow(" 一二三四五六七 ")),
            SingleLineFittedBox(child: wRow(" 一二三四五六七 ")),
            SingleLineFittedBox(child: wRow(" 一二三四五六七八九十哇哈哈 ")),
          ],
        ),
      ),
    );
  }
}

Widget wContainer(BoxFit boxFit) {
  return Container(
    width: 50,
    height: 50,
    color: Colors.red,
    child: FittedBox(
      fit: boxFit,
      // 子容器超过父容器大小
      child: Container(width: 50, height: 70, color: Colors.blue),
    ),
  );
}

// 直接使用Row
Widget wRow(String text) {
  Widget child = Text(text);
  child = Padding(
    padding: EdgeInsets.only(top: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [child, child, child],
    ),
  );
  return child;
}

class SingleLineFittedBox extends StatelessWidget {
  const SingleLineFittedBox({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return FittedBox(
          child: ConstrainedBox(
            constraints: constraints.copyWith(
              minWidth: constraints.maxWidth,
              maxWidth: double.infinity,
              // maxWidth: constraints.maxWidth
            ),
            child: child,
          ),
        );
      },
    );
  }
}
