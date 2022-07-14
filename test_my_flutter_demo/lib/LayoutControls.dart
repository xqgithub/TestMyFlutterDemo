import 'package:flutter/material.dart';

///布局类组件

class LayoutControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MConstrainedBox();
  }
}

///ConstrainedBox 布局
class MConstrainedBox extends StatefulWidget {
  @override
  _MConstrainedBox createState() => _MConstrainedBox();
}

class _MConstrainedBox extends State<MConstrainedBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('ConstrainedBox 布局')
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
            minWidth: double.infinity, //宽度尽可能大
            minHeight: 50.0 //最小高度为50像素
        ),
        child: Container(
          height: 5.0,
          child: redBox,
        ),
      ),
    );
  }
}

Widget redBox = const DecoratedBox(
  decoration: BoxDecoration(color: Colors.red),
);

