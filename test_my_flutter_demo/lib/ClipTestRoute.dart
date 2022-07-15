import 'package:flutter/material.dart';

///剪裁（Clip）

class ClipTestRoute extends StatefulWidget {
  _ClipTestRoute createState() => new _ClipTestRoute();
}

class _ClipTestRoute extends State<ClipTestRoute> {
  // 头像
  Widget avatar = Image.asset(
    "assets/images/lufei.jpg",
    width: 150.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("剪裁（Clip）"),
      ),
      // body: _test1(avatar),
      body: _test2(avatar),
    );
  }
}

///剪裁示例
_test1(avatar) {
  return DecoratedBox(
    decoration: BoxDecoration(
        color: Colors.red,
        gradient: RadialGradient(
          //背景径向渐变
          colors: [Colors.red, Colors.orange],
          center: Alignment.topLeft,
          radius: 0.98,
        )),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ///不剪裁
        avatar,

        ///剪裁为圆形
        ClipOval(child: avatar),

        ///剪裁为圆角矩形
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: avatar,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              widthFactor: 0.5, //宽度设为原来宽度一半，另一半会溢出
              child: avatar,
            ),
            Text(
              "你好世界",
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRect(
              //将溢出部分剪裁
              child: Align(
                alignment: Alignment.topLeft,
                widthFactor: 0.5, //宽度设为原来宽度一半
                child: avatar,
              ),
            ),
            Text("你好世界", style: TextStyle(color: Colors.green))
          ],
        ),
      ],
    ),
  );
}

///自定义一个CustomClipper,来自定义剪裁区域
class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(10.0, 15.0, 40.0, 30.0);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

_test2(avatar) {
  return DecoratedBox(
    decoration: BoxDecoration(color: Colors.red),
    child: ClipRect(
        clipper: MyClipper(), //使用自定义的clipper
        child: avatar),
  );
}
