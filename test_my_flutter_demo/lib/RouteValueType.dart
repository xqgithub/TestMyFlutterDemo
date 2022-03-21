/**
 * 路由传值的方式
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'PublicPracticalMethod.dart';

///非命名路由传值
class RoutePassValue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // 打开`TipRoute`，并等待返回结果
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TipRoute(
                    // 路由参数
                    text: "提示：非命名路由传值",
                  );
                },
              ),
            );
            //输出`TipRoute`路由返回结果
            LogUtils.i("路由返回值 =-= $result");
          },
          child: const Text("打开提示页"),
        ),
      ),
    );
  }
}

class TipRoute extends StatelessWidget {
  final String text;

  TipRoute({
    Key? key,
    required this.text, // 接收一个text参数
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('提示'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, "我是返回值"),
                child: Text('返回'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

///命名路由
class EchoRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///获取路由参数
    var args = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.toString()),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // 打开`TipRoute`，并等待返回结果
            var result =
                await Navigator.pushNamed(context, "TipRoute", arguments: args);
            //输出`TipRoute`路由返回结果
            LogUtils.i("路由返回值: $result");
          },
          child: const Text("打开提示页"),
        ),
      ),
    );
  }
}
