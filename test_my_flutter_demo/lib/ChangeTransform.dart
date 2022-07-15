import 'package:flutter/material.dart';
import 'dart:math' as math;

///变换（Transform）

class ChangeTransform extends StatefulWidget {
  _ChangeTransform createState() => new _ChangeTransform();
}

class _ChangeTransform extends State<ChangeTransform> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("变换（Transform）"),
      ),
      // body: _Matrix4(),
      // body: _Translation(),
      // body: _rotate(),
      // body: _scale(),
      body: _RotatedBox(),
    );
  }
}

///Matrix4是一个4D矩阵，通过它我们可以实现各种矩阵操作
_Matrix4() {
  return Center(
    child: Container(
      color: Colors.black,
      child: new Transform(
        alignment: Alignment.topRight, //相对于坐标系原点的对齐方式
        transform: new Matrix4.skewY(0.3), //沿Y轴倾斜0.3弧度
        child: new Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.deepOrange,
          child: const Text('Apartment for rent!'),
        ),
      ),
    ),
  );
}

///平移
_Translation() {
  return Center(
    child: DecoratedBox(
      decoration: BoxDecoration(color: Colors.red),
      //默认原点为左上角，左移20像素，向上平移5像素
      child: Transform.translate(
        offset: Offset(10.0, 10.0),
        child: Text("Hello world"),
      ),
    ),
  );
}

///旋转
_rotate() {
  return Center(
    child: DecoratedBox(
      decoration: BoxDecoration(color: Colors.red),
      child: Transform.rotate(
        //旋转90度
        angle: math.pi / 2,
        child: Text("Hello world"),
      ),
    ),
  );
}

///缩放
_scale() {
  return Center(
    child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.red),
        child: Transform.scale(
            scale: 1.5, //放大到1.5倍
            child: Text("Hello world"))),
  );
}

_RotatedBox() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      DecoratedBox(
        decoration: BoxDecoration(color: Colors.red),
        child: RotatedBox(
          quarterTurns: 1, //旋转90度(1/4圈)
          child: Text("Hello world"),
        ),
      ),
      Text(
        "你好",
        style: TextStyle(color: Colors.green, fontSize: 18.0),
      )
    ],
  );
}
