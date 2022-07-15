import 'package:flutter/material.dart';

import 'PublicPracticalMethod.dart';

///Scaffold是一个路由页的骨架，我们使用它可以很容易地拼装出一个完整的页面

class ScaffoldRoute extends StatefulWidget {
  @override
  _ScaffoldRoute createState() => _ScaffoldRoute();
}

/// 实现一个页面
/// 1.一个导航栏
/// 2.导航栏右边有一个分享按钮
/// 3.有一个抽屉菜单
/// 4.有一个底部导航
/// 5.右下角有一个悬浮的动作按钮
class _ScaffoldRoute extends State<ScaffoldRoute>
    with SingleTickerProviderStateMixin {
  //底部导航栏被选中的序号
  int _selectedIndex = 0;

  late TabController _tabController; //需要定义一个Controller
  List tabs = ["新闻", "历史", "图片"];

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
    //顶部tab切换监听
    _tabController.addListener(() {
      switch (_tabController.index) {
        case 0:
          LogUtils.i("tab${_tabController.index}被选择了");
          break;
        case 1:
          LogUtils.i("tab${_tabController.index}被选择了");
          break;
        case 2:
          LogUtils.i("tab${_tabController.index}被选择了");
          break;
      }
    });
  }

  ///切换选项卡
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ///悬浮按钮添加事件
  void _onAdd() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///导航栏
      appBar: AppBar(
        title: Text("Scaffold、TabBar、底部导航"),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.dashboard, color: Colors.white), //自定义图标
            onPressed: () {
              // 打开抽屉菜单,Scaffold.of(context)可以获取父级最近的Scaffold 组件的State对象
              Scaffold.of(context).openDrawer();
            },
          );
        }),

        ///导航栏右侧菜单
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                LogUtils.i("右侧菜单  被点击了");
              }),
        ],
      ),

      ///抽屉
      drawer: new MyDrawer(),
      endDrawer: new MyDrawer(),

      /// 底部导航
      bottomNavigationBar: _bottomNavigationBar2(_selectedIndex, _onItemTapped),

      ///悬浮按钮
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onAdd,
      ),

      ///悬浮按钮位置
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: _tabPage(_tabController, tabs),
    );
  }
}

///创建tab页
_tabPage(TabController _tabController, List tabs) {
  return TabBarView(
    controller: _tabController,
    children: tabs.map((e) {
      return Container(
        alignment: Alignment.center,
        child: Text(e, textScaleFactor: 5),
      );
    }).toList(),
  );
}

///底部导航栏
Widget _bottomNavigationBar2(_selectedIndex, _onItemTapped) {
  return BottomAppBar(
    color: Colors.white,
    shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            LogUtils.i("首页被点击了");
          },
          icon: Icon(Icons.home),
        ),
        IconButton(
          onPressed: () {
            LogUtils.i("附加页被点击了");
          },
          icon: Icon(Icons.business),
        ),
      ],
    ),
  );
}

// 返回每个隐藏的菜单项
SelectView(IconData icon, String text, String id) {
  return new PopupMenuItem<String>(
      value: id,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Icon(icon, color: Colors.blue),
          new Text(text),
        ],
      )
  );
}

///Scaffold的drawer和endDrawer属性可以分别接受一个Widget来作为页面的左、右抽屉菜单
///左边抽屉类
class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true, //移除抽屉菜单顶部默认留白
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/error_null.png",
                        width: 80,
                      ),
                    ),
                  ),
                  Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add account'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Manage accounts'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
