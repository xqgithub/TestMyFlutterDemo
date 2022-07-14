import 'package:flutter/material.dart';

///线性布局(Row和Column)

class RowAndColumn extends StatefulWidget {
  @override
  _RowAndColumn createState() => _RowAndColumn();
}

class _RowAndColumn extends State<RowAndColumn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("线性布局"),
      ),
      body: Container(
        color: Colors.green,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //测试Row对齐方式，排除Column默认居中对齐的干扰
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text("海贼王"),
                Text("路飞"),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center, //此时该方法是没有效果的
              children: const [
                Text("海贼王"),
                Text("索隆"),
              ],
            ),
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text("海贼王"),
                Text("娜美"),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              verticalDirection: VerticalDirection.up,
              children: const [
                Text(
                  "海贼王",
                  style: TextStyle(fontSize: 30.0),
                ),
                Text("乌索普"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
