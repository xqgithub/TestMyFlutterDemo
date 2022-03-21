import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///状态管理
class WidgetStateManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return TapboxA();
    // return ParentWidgetB();
    return ParentWidgetC();
  }
}

///Widget管理自身状态
class TapboxA extends StatefulWidget {
  TapboxA({Key? key}) : super(key: key);

  @override
  _TapboxAState createState() => _TapboxAState();
}

class _TapboxAState extends State<TapboxA> {
  ///确定盒子的当前颜色的布尔值。
  bool _active = false;

  ///设置开关状态
  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            _active ? 'Active' : 'Inactive',
            style: const TextStyle(
                fontSize: 32.0,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }
}

///父Widget管理子Widget的状态
class ParentWidgetB extends StatefulWidget {
  @override
  _ParentWidgetBState createState() => _ParentWidgetBState();
}

class _ParentWidgetBState extends State<ParentWidgetB> {
  ///确定盒子的当前颜色的布尔值。
  bool _active = false;

  ///设置开关状态
  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TapboxB(active: _active, onChanged: _handleTapboxChanged),
    );
  }
}

class TapboxB extends StatelessWidget {
  TapboxB({Key? key, this.active = false, required this.onChanged})
      : super(key: key);

  final bool active;
  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Center(
        child: Container(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: const TextStyle(
                fontSize: 32.0,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          alignment: Alignment.topLeft,
          width: 500.0,
          height: 250.0,
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          decoration: BoxDecoration(
            color: active ? Colors.lightGreen[700] : Colors.grey[600],
            border: Border.all(
              width: 2.0,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

///混合状态管理
class ParentWidgetC extends StatefulWidget {
  @override
  _ParentWidgetCState createState() => _ParentWidgetCState();
}

class _ParentWidgetCState extends State<ParentWidgetC> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TapboxC(active: _active, onChanged: _handleTapboxChanged),
    );
  }
}

class TapboxC extends StatefulWidget {
  const TapboxC({Key? key, this.active = false, required this.onChanged})
      : super(key: key);

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  _TapboxCState createState() => _TapboxCState();
}

class _TapboxCState extends State<TapboxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      //处理按下事件
      onTapUp: _handleTapUp,
      //处理抬起事件
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: Center(
        child: Container(
          child: Text(
            widget.active ? 'Active' : 'Inactive',
            style: const TextStyle(
                fontSize: 32.0,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          alignment: Alignment.topLeft,
          width: 500.0,
          height: 250.0,
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          decoration: BoxDecoration(
            color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
            border: _highlight
                ? Border.all(
                    width: 2.0,
                    color: Colors.red,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

    );
  }
}
