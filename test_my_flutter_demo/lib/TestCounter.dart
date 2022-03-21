import 'package:flutter/material.dart';

///计数器应用示例

class TestCounter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestCounterImpl();
}

///实现
class _TestCounterImpl extends State<TestCounter> {
  var _counter = 0;

  ///数字逐渐+1方法
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('计数器'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: '计数会增加',
        child: const Icon(Icons.add),
      ),
    );
  }
}
