import 'package:flutter/material.dart';

///首页列表

///列表的Widget
class Directory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DirectoryState();
}

///列表的Widget 实现
class _DirectoryState extends State<Directory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Center(
          child: Text('Flutter demo 列表'),
        ),
      ),
      body: _getDemoListData(context),
    );
  }
}

/// demo列表
_getDemoListData(BuildContext context) {
  const _fontSize = TextStyle(fontSize: 18.0, color: Colors.purple);

  ///下划线widget预定义以供复用。
  Widget divider1 = const Divider(
    color: Colors.blue,
  );
  var _name = [];
  _name.add("flutter 第一个例子");
  _name.add("非命名路由传值");
  _name.add("命名路由传值");
  _name.add("计数器应用示例");
  _name.add("Widget介绍");
  _name.add("Widget状态管理");
  _name.add("加载assets中的资源");
  _name.add("基础组件");
  _name.add("布局类组件");
  _name.add("线性布局(Row和Column)");
  _name.add("弹性布局");
  _name.add("流式布局");
  _name.add("层叠布局,绝对定位");
  _name.add("对齐与相对定位(Align)");
  _name.add("LayoutBuilder、AfterLayout");
  _name.add("变换（Transform）");
  _name.add("容器组件(Container)");
  _name.add("剪裁（Clip）");
  _name.add("空间适配FittedBox");
  _name.add("页面骨架(Scaffold)");

  return ListView.builder(
    ///设置列表的 滑动方向
    scrollDirection: Axis.vertical,
    itemCount: _name.length * 2,

    ///设置item
    itemBuilder: (BuildContext context, int i) {
      ///当时奇数的时候返回分割线
      if (i.isOdd) return divider1;

      /// 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
      final index = i ~/ 2;
      return Container(
        child: ListTile(
          title: Text(_name[index], style: _fontSize),
          onTap: () {
            _pageJump(context, index);
          },
        ),
      );
    },
  );
}

/// 页面跳转
_pageJump(BuildContext context, int index) {
  if (index == 0) {
    ///跳转到第一个例子页面
    Navigator.pushNamed(context, "FirstExample");
  } else if (index == 1) {
    ///1.非命名路由
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //   return RoutePassValue();
    // }));

    ///2.添加路由，但是未在路由表中注册，最终走的是onGenerateRoute
    Navigator.pushNamed(context, "RoutePassValue");
  } else if (index == 2) {
    ///命名路由
    Navigator.pushNamed(context, "EchoRoute", arguments: "命名路由传值 =-= 123456");
  } else if (index == 3) {
    ///计数器应用示例
    Navigator.pushNamed(context, "TestCounter");
  } else if (index == 4) {
    ///Widget介绍
    Navigator.pushNamed(context, "WidgetIntroduction");
  } else if (index == 5) {
    ///状态管理
    Navigator.pushNamed(context, "WidgetStateManagement");
  } else if (index == 6) {
    ///加载assets文件中的内容
    Navigator.pushNamed(context, "LoadAssets");
  } else if (index == 7) {
    ///基础组件
    Navigator.pushNamed(context, "BasicComponents");
  } else if (index == 8) {
    ///布局类组件
    Navigator.pushNamed(context, "LayoutControls");
  } else if (index == 9) {
    ///线性布局(Row和Column)
    Navigator.pushNamed(context, "RowAndColumn");
  } else if (index == 10) {
    ///弹性布局
    Navigator.pushNamed(context, "Flexible");
  } else if (index == 11) {
    ///流式布局
    Navigator.pushNamed(context, "FlowLayout");
  } else if (index == 12) {
    ///层叠布局,绝对定位
    Navigator.pushNamed(context, "StackPositioned");
  } else if (index == 13) {
    ///对齐与相对定位(Align)
    Navigator.pushNamed(context, "AlignRelative");
  } else if (index == 14) {
    ///LayoutBuilder、AfterLayout
    Navigator.pushNamed(context, "LayoutBuilderRoute");
  } else if (index == 15) {
    ///变换（Transform）
    Navigator.pushNamed(context, "ChangeTransform");
  } else if (index == 16) {
    ///容器组件(Container)
    Navigator.pushNamed(context, "TestContainer");
  } else if (index == 17) {
    ///剪裁（Clip）
    Navigator.pushNamed(context, "ClipTestRoute");
  } else if (index == 18) {
    ///空间适配FittedBox
    Navigator.pushNamed(context, "FittedBoxRoute");
  } else if (index == 19) {
    ///页面骨架(Scaffold)
    Navigator.pushNamed(context, "ScaffoldRoute");
  }
}
