import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_my_flutter_demo/PublicPracticalMethod.dart';

/**
 * 事件处理与通知
 */

class EventAndNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("事件处理与通知"),
      ),
      body: TestPointerEvent(),
    );
  }
}

/************* 原始指针事件处理 *************/

class TestPointerEvent extends StatefulWidget {
  _TestPointerEvent createState() => new _TestPointerEvent();
}

//定义一个状态，保存当前指针位置
PointerEvent? _event;

class _TestPointerEvent extends State<TestPointerEvent> {
  @override
  Widget build(BuildContext context) {
    // return _TestTestPointerEvent(this);
    // return _TestTestPointerEvent2();
    // return _TestTestPointerEvent3();
    // return _TestGestureDetector(this);
    // return _Drag();
    // return DragVertical();
    return Zoom();
  }
}

///使用Listener来监听原始触摸事件
_TestTestPointerEvent(State state) {
  return Listener(
    child: Container(
      alignment: Alignment.center,
      color: Colors.blue,
      width: 300.0,
      height: 150.0,
      child: Text(_event?.toString() ?? "",
          style: const TextStyle(color: Colors.white)),
    ),
    onPointerDown: (PointerDownEvent event) =>
        state.setState(() => _event = event),
    onPointerMove: (PointerMoveEvent event) =>
        state.setState(() => _event = event),
    onPointerUp: (PointerUpEvent event) => state.setState(() => _event = event),
  );
}

///behavior属性，它决定子组件如何响应命中测试
_TestTestPointerEvent2() {
  return Stack(
    children: <Widget>[
      Listener(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size(300.0, 200.0)),
          child: DecoratedBox(decoration: BoxDecoration(color: Colors.blue)),
        ),
        onPointerDown: (event) => print("down0"),
      ),
      Listener(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size(200.0, 100.0)),
          child: Center(
            child: Text("左上角200*100范围内非文本区域点击"),
          ),
        ),
        onPointerDown: (event) => print("down1"),
        behavior: HitTestBehavior.translucent, //放开此行注释后可以"点透"
//        behavior: HitTestBehavior.opaque, //将当前组件当成不透明处理(即使本身是透明的)
      )
    ],
  );
}

///忽略PointerEvent
_TestTestPointerEvent3() {
  return Listener(
    child: AbsorbPointer(
      child: Listener(
        child: Container(
          color: Colors.red,
          width: 200.0,
          height: 100.0,
        ),
        onPointerDown: (event) => print("in"),
      ),
    ),
    onPointerDown: (event) => print("up"),
  );
}

/************* 手势识别 *************/

///更新事件名称
String _operation = "No Gesture detected!"; //保存事件名
void updateText(String text, State state) {
  state.setState(() {
    _operation = text;
  });
}

///点击、双击、长按
_TestGestureDetector(State state) {
  return Center(
    child: GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: Colors.blue,
        width: 200.0,
        height: 100.0,
        child: Text(
          _operation,
          style: TextStyle(color: Colors.white),
        ),
      ),
      onTap: () => updateText("点击事件", state), //点击
      onDoubleTap: () => updateText("双击事件", state), //双击
      onLongPress: () => updateText("长按事件", state), //长按
    ),
  );
}

///拖动、滑动
class _Drag extends StatefulWidget {
  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<_Drag> with SingleTickerProviderStateMixin {
  double _top = 0.0; //距顶部的偏移
  double _left = 0.0; //距左边的偏移

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            child: CircleAvatar(child: Text("A")),
            //手指按下时会触发此回调
            onPanDown: (DragDownDetails e) {
              //打印手指按下的位置(相对于屏幕)
              LogUtils.i("用户手指按下 =-= ${e.globalPosition}");
            },
            //手指滑动时会触发此回调
            onPanUpdate: (DragUpdateDetails e) {
              //用户手指滑动时，更新偏移，重新构建
              setState(() {
                _left += e.delta.dx;
                _top += e.delta.dy;
              });
            },
            onPanEnd: (DragEndDetails e) {
              //打印滑动结束时在x、y轴上的速度
              LogUtils.i("滑动结束时在x、y轴上的速度 =-= ${e.velocity}");
            },
          ),
        )
      ],
    );
  }
}

///单一方向拖动,垂直
class DragVertical extends StatefulWidget {
  _DragVertical createState() => _DragVertical();
}

class _DragVertical extends State<DragVertical> {
  double _top = 0.0; //距顶部的偏移

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: _top,
          child: GestureDetector(
            child: CircleAvatar(child: Text("A")),
            //垂直方向拖动事件
            onVerticalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                _top += details.delta.dy;
              });
            },
          ),
        ),
      ],
    );
  }
}

///缩放
class Zoom extends StatefulWidget {
  _Zoom createState() => _Zoom();
}

class _Zoom extends State<Zoom> {
  double _width = 200.0; //通过修改图片宽度来达到缩放效果

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        //指定宽度，高度自适应
        child: Image.asset("assets/images/lufei.jpg", width: _width),
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            //缩放倍数在0.8到10倍之间
            _width = 200 * details.scale.clamp(.8, 10.0);
          });
        },
      ),
    );
  }
}
