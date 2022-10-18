import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'PublicPracticalMethod.dart';

///功能型Widget简介

class FunctionComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("功能型Widget"),
      ),
      // body: WillPopScopeTestRoute(),
      // body: InheritedWidgetTestRoute(),
      // body: ProviderRoute(),
      // body: _TestNavBar(),
      // body: ThemeTestRoute(),
      // body: ValueListenableRoute(),
      // body: _TestFutureBuilder(),
      // body: _TestStreamBuilder(),
      body: TestAlertDialog(),
    );
  }
}

///导航返回拦截
class WillPopScopeTestRoute extends StatefulWidget {
  @override
  WillPopScopeTestRouteState createState() {
    return WillPopScopeTestRouteState();
  }
}

class WillPopScopeTestRouteState extends State<WillPopScopeTestRoute> {
  DateTime? _lastPressedAt; //上次点击时间

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 1)) {
          //两次点击间隔超过1秒则重新计时
          _lastPressedAt = DateTime.now();
          return false;
        }
        return true;
      },
      child: Container(
        alignment: Alignment.center,
        child: Text("1秒内连续按两次返回键退出"),
      ),
    );
  }
}

///数据共享(InheritedWidget)
class ShareDataWidget extends InheritedWidget {
  ShareDataWidget({Key? key, required this.data, required Widget child})
      : super(key: key, child: child);

  //需要在子树中共享的数据，保存点击次数
  final int data;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static ShareDataWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShareDataWidget>();
  }

  @override
  bool updateShouldNotify(ShareDataWidget old) {
    //如果返回true，则子树中依赖(build函数中有调用)本widget
    //的子widget的`state.didChangeDependencies`会被调用
    return old.data != data;
  }
}

class TestInheritedWidget extends StatefulWidget {
  @override
  _TestInheritedWidget createState() => _TestInheritedWidget();
}

class _TestInheritedWidget extends State<TestInheritedWidget> {
  @override
  Widget build(BuildContext context) {
    //使用InheritedWidget中的共享数据
    return Text(ShareDataWidget.of(context)!.data.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //父或祖先widget中的InheritedWidget改变(updateShouldNotify返回true)时会被调用。
    //如果build中没有依赖InheritedWidget，则此回调不会被调用。
    LogUtils.i("Dependencies change");
  }
}

class InheritedWidgetTestRoute extends StatefulWidget {
  @override
  _InheritedWidgetTestRouteState createState() =>
      _InheritedWidgetTestRouteState();
}

class _InheritedWidgetTestRouteState extends State<InheritedWidgetTestRoute> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShareDataWidget(
        //使用ShareDataWidget
        data: count,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: TestInheritedWidget(), //子widget中依赖ShareDataWidget
            ),
            ElevatedButton(
              child: Text("Increment"),
              //每点击一次，将count自增，然后重新build,ShareDataWidget的data将被更新
              onPressed: () => setState(() => ++count),
            )
          ],
        ),
      ),
    );
  }
}

///一个通用的InheritedWidget，保存任需要跨组件共享的状态
// 一个通用的InheritedWidget，保存需要跨组件共享的状态
class InheritedProvider<T> extends InheritedWidget {
  InheritedProvider({
    required this.data,
    required Widget child,
  }) : super(child: child);

  final T data;

  @override
  bool updateShouldNotify(InheritedProvider<T> old) {
    //在此简单返回true，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}

// 该方法用于在Dart中获取模板类型
Type _typeOf<T>() => T;

///订阅者类
class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  ChangeNotifierProvider({
    Key? key,
    required this.data,
    required this.child,
  });

  final Widget child;
  final T data;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static T of<T>(BuildContext context, {bool listen = true}) {
    final type = _typeOf<InheritedProvider<T>>();
    final provider =
    context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();
    return provider!.data;
  }

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  void update() {
    //如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
    setState(() => {});
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}

///向购物车添加商品的时候更新总价
//1.向购物车中添加新商品时总价更新
class Item {
  Item(this.price, this.count);

  double price; //商品单价
  int count; // 商品份数
}

//将要共享的状态放到一个Model类中，然后让它继承自ChangeNotifier
class CartModel extends ChangeNotifier {
  // 用于保存购物车中商品列表
  final List<Item> _items = [];

  // 禁止改变购物车里的商品信息
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  // 购物车中商品的总价
  double get totalPrice =>
      _items.fold(0, (value, item) => value + item.count * item.price);

  // 将 [item] 添加到购物车。这是唯一一种能从外部改变购物车的方法。
  void add(Item item) {
    _items.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }
}

class ProviderRoute extends StatefulWidget {
  @override
  _ProviderRouteState createState() => _ProviderRouteState();
}

class _ProviderRouteState extends State<ProviderRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("跨组件状态共享（Provider）"),
      ),
      body: Center(
        child: ChangeNotifierProvider<CartModel>(
          data: CartModel(),
          child: Builder(
            builder: (context) {
              return Column(
                children: <Widget>[
                  Consumer<CartModel>(
                    builder: (context, cart) => Text("总价: ${cart.totalPrice}"),
                  ),
                  Builder(
                    builder: (context) {
                      print("RaisedButton build"); //在后面优化部分会用到
                      return ElevatedButton(
                        child: Text("添加商品"),
                        onPressed: () {
                          //给购物车中添加商品，添加后总价会更新,listen 设为false，不建立依赖关系
                          ChangeNotifierProvider.of<CartModel>(context,
                              listen: false)
                              .add(Item(20.0, 1));
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// 这是一个便捷类，会获得当前context和指定数据类型的Provider
class Consumer<T> extends StatelessWidget {
  Consumer({
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  final Widget? child;

  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      ChangeNotifierProvider.of<T>(context), //自动获取Model
    );
  }
}

///颜色亮度,实现一个背景颜色和Title可以自定义的导航栏，并且背景色为深色时我们应该让Title显示为浅色；背景色为浅色时，Title显示为深色
class NavBar extends StatelessWidget {
  final String title;
  final Color color; //背景颜色

  NavBar({
    Key? key,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 52.0,
        minWidth: double.infinity,
      ),
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          //阴影
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 3,
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          //根据背景色亮度来确定Title颜色
          color: color.computeLuminance() < 0.5 ? Colors.white : Colors.black,
        ),
      ),
      alignment: Alignment.center,
    );
  }
}

_TestNavBar() {
  return Column(children: <Widget>[
    //背景为蓝色，则title自动为白色
    NavBar(color: Colors.blue, title: "标题"),
    //背景为白色，则title自动为黑色
    NavBar(color: Colors.greenAccent, title: "标题"),
  ]);
}

///主题颜色
class ThemeTestRoute extends StatefulWidget {
  @override
  _ThemeTestRouteState createState() => _ThemeTestRouteState();
}

class _ThemeTestRouteState extends State<ThemeTestRoute> {
  var _themeColor = Colors.teal; //当前路由主题色

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Theme(
      data: ThemeData(
          primarySwatch: _themeColor, //用于导航栏、FloatingActionButton的背景色等
          iconTheme: IconThemeData(color: _themeColor) //用于Icon颜色
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("主题测试")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //第一行Icon使用主题中的iconTheme
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Icon(Icons.favorite),
              Icon(Icons.airport_shuttle),
              Text("  颜色跟随主题")
            ]),
            //为第二行Icon自定义颜色（固定为黑色)
            Theme(
              data: themeData.copyWith(
                iconTheme: themeData.iconTheme.copyWith(color: Colors.black),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Icon(Icons.airport_shuttle),
                    Text("  颜色固定黑色")
                  ]),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => //切换主题
            setState(() =>
            _themeColor =
            _themeColor == Colors.teal ? Colors.blue : Colors.teal),
            child: Icon(Icons.palette)),
      ),
    );
  }
}

///ValueListenableBuilder使用
class ValueListenableRoute extends StatefulWidget {
  const ValueListenableRoute({Key? key}) : super(key: key);

  @override
  State<ValueListenableRoute> createState() => _ValueListenableState();
}

class _ValueListenableState extends State<ValueListenableRoute> {
  // 定义一个ValueNotifier，当数字变化时会通知 ValueListenableBuilder
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  static const double textScaleFactor = 1.5;

  @override
  Widget build(BuildContext context) {
    // 添加 + 按钮不会触发整个 ValueListenableRoute 组件的 build
    LogUtils.i('build');
    return Scaffold(
      appBar: AppBar(title: Text('ValueListenableBuilder 测试')),
      body: Center(
        child: ValueListenableBuilder<int>(
          builder: (BuildContext context, int value, Widget? child) {
            // builder 方法只会在 _counter 变化时被调用
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                child!,
                Text('$value 次', textScaleFactor: textScaleFactor),
              ],
            );
          },
          valueListenable: _counter,
          // 当子组件不依赖变化的数据，且子组件收件开销比较大时，指定 child 属性来缓存子组件非常有用
          child: const Text('点击了 ', textScaleFactor: textScaleFactor),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        // 点击后值 +1，触发 ValueListenableBuilder 重新构建
        onPressed: () => _counter.value += 1,
      ),
    );
  }
}

///异步UI更新（FutureBuilder、StreamBuilder）
///模拟加载数据
Future<String> mockNetworkData() async {
  return Future.delayed(Duration(seconds: 2), () => "我是从互联网上获取的数据");
}

///异步更新UI,FutureBuilder
_TestFutureBuilder() {
  return Center(
    child: FutureBuilder<String>(
      future: mockNetworkData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 请求已结束
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return Text("Error: ${snapshot.error}");
          } else {
            // 请求成功，显示数据
            return Text("Contents: ${snapshot.data}");
          }
        } else {
          // 请求未结束，显示loading
          return CircularProgressIndicator();
        }
      },
    ),
  );
}

///使用Stream来实现每隔一秒生成一个数字
Stream<int> counter() {
  return Stream.periodic(Duration(seconds: 1), (i) {
    return i;
  });
}

///异步更新UI,FutureBuilder
_TestStreamBuilder() {
  return StreamBuilder<int>(
    stream: counter(),
    //initialData: ,// a Stream<int> or null
    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return Text('没有Stream');
        case ConnectionState.waiting:
          return Text('等待数据...');
        case ConnectionState.active:
          return Text('active: ${snapshot.data}');
        case ConnectionState.done:
          return Text('Stream已关闭');
      }
      // return null; // unreachable
    },
  );
}

///AlertDialog
class TestAlertDialog extends StatefulWidget {
  _TestAlertDialog createState() => new _TestAlertDialog();
}

class _TestAlertDialog extends State<TestAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "对话框",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200.0,
                  height: 50.0,
                  child: ElevatedButton(
                      child: Text(
                        "确认对话框",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: () async {
                        //弹出对话框并等待其关闭
                        bool delete = await _TestConfirm(context);
                        if (delete == null) {
                          print("点击弹框外部，取消弹框");
                        } else {
                          if (delete == false) {
                            print("取消删除");
                          } else {
                            print("已确认删除");
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color(0xFFE53935)), //背景颜色
                      )),
                ),
                Container(
                  width: 200.0,
                  height: 50.0,
                  margin: const EdgeInsets.only(top: 15.0),
                  child: ElevatedButton(
                    child: new Text(
                      "选择语言对话框",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      changeLanguage(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Color(0xFFE53935)), //背景颜色
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 50.0,
                  margin: const EdgeInsets.only(top: 15.0),
                  child: ElevatedButton(
                    child: new Text(
                      "显示listView弹框",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      showListDialog(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Color(0xFFE53935)), //背景颜色
                    ),
                  ),
                ),
                Container(
                  width: 250.0,
                  height: 60.0,
                  margin: const EdgeInsets.only(top: 15.0),
                  child: ElevatedButton(
                    child: Text(
                      "自定义对话框showGeneralDialog",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      _TestConfirm2(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Color(0xFFE53935)), //背景颜色
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 50.0,
                  margin: const EdgeInsets.only(top: 15.0),
                  child: ElevatedButton(
                    child: Text(
                      "复选框对话框",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      showCheckboxDialog(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Color(0xFFE53935)), //背景颜色
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 50.0,
                  margin: const EdgeInsets.only(top: 15.0),
                  child: ElevatedButton(
                    child: Text(
                      "底部菜单栏对话框",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async {
                      int type = await _showModalBottomSheet(context);
                      print(type);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Color(0xFFE53935)), //背景颜色
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 50.0,
                  margin: const EdgeInsets.only(top: 15.0),
                  child: new RaisedButton(
                    child: new Text(
                      "Loading框",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      _showLoadingDialog(context);
                    },
                    color: Colors.red,
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 50.0,
                  margin: const EdgeInsets.only(top: 15.0),
                  child: new RaisedButton(
                    child: new Text(
                      "日历Android",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async {
                      var DateTime = await _showDatePicker1(context);
                      print(
                          "年：${DateTime?.year} 月：${DateTime
                              ?.month}  日：${DateTime?.day}");
                    },
                    color: Colors.red,
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 50.0,
                  margin: const EdgeInsets.only(top: 15.0),
                  child: new RaisedButton(
                    child: new Text(
                      "日历IOS",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async {
                      _showDatePicker2(context);
                    },
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///确认对话框
Future _TestConfirm(context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("提示"),
        content: Text("您确定要删除当前文件吗?"),
        actions: <Widget>[
          FlatButton(
            child: Text("取消"),
            onPressed: () => Navigator.of(context).pop(false), //关闭对话框
          ),
          FlatButton(
            child: Text("删除"),
            onPressed: () {
              // ... 执行删除操作
              Navigator.of(context).pop(true); //关闭对话框
            },
          ),
        ],
      );
    },
  );
}

///SimpleDialog 展示一个列表
Future<void> changeLanguage(context) async {
  int? i = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('请选择语言'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                // 返回1
                Navigator.pop(context, 1);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text('中文简体'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                // 返回2
                Navigator.pop(context, 2);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text('美国英语'),
              ),
            ),
          ],
        );
      });

  if (i != null) {
    print("选择了：${i == 1 ? "中文简体" : "美国英语"}");
  }
}

///显示ListView弹框
Future<void> showListDialog(context) async {
  int? index = await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      var child = Column(
        children: <Widget>[
          ListTile(title: Text("请选择")),
          Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text("$index"),
                    onTap: () => Navigator.of(context).pop(index),
                  );
                },
              )),
        ],
      );
      //使用AlertDialog会报错
      //return AlertDialog(content: child);
      return Dialog(child: child);
    },
  );
  if (index != null) {
    print("点击了：$index");
  }
}

Future<bool?> _TestConfirm2(context) {
  return showCustomDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("提示"),
        content: Text("您确定要删除当前文件吗?"),
        actions: <Widget>[
          TextButton(
            child: Text("取消"),
            onPressed: () => Navigator.of(context).pop(), //关闭对话框
          ),
          TextButton(
            child: Text("删除"),
            onPressed: () {
              Navigator.of(context).pop(true); //关闭对话框
            },
          ),
        ],
      );
    },
  );
}

///对话框打开动画及遮罩
Future<T?> showCustomDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  required WidgetBuilder builder,
  ThemeData? theme,
}) {
  final ThemeData theme = Theme.of(context);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations
        .of(context)
        .modalBarrierDismissLabel,
    // 自定义遮罩颜色
    barrierColor: Colors.black87,
    //定义动画
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
  );
}

Widget _buildMaterialDialogTransitions(BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  // 使用缩放动画
  return ScaleTransition(
    scale: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

///复选框
Future<bool?> showCheckboxDialog(context) {
  bool _withTree = false;
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("您确定要删除当前文件吗?"),
              Row(
                children: <Widget>[
                  Text("同时删除子目录？"),
                  // 通过Builder来获得构建Checkbox的`context`，
                  // 这是一种常用的缩小`context`范围的方式
                  Builder(
                    builder: (BuildContext context) {
                      return Checkbox(
                        // 依然使用Checkbox组件
                        value: _withTree,
                        onChanged: (bool? value) {
                          (context as Element).markNeedsBuild();
                          _withTree = !_withTree;
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("删除"),
              onPressed: () {
                // 执行删除操作
                Navigator.of(context).pop(_withTree);
              },
            ),
          ],
        );
      });
}

///底部菜单栏对话框  showModalBottomSheet
Future _showModalBottomSheet(context) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ListView.builder(
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("$index"),
            onTap: () => Navigator.of(context).pop(index),
          );
        },
      );
    },
  );
}

///Loading框 showDialog+AlertDialog
_showLoadingDialog(context) {
  return showDialog(
      context: context,
      barrierDismissible: true, //点击遮罩关闭对话框
      builder: (context) {
        ///使用UnconstrainedBox先抵消showDialog对宽度的限制，然后再使用SizedBox指定宽度
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 280,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: Text("正在加载，请稍后..."),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

///日历Android风格
Future<DateTime?> _showDatePicker1(context) {
  var date = DateTime.now();
  return showDatePicker(
    context: context,
    initialDate: date,
    firstDate: date,
    lastDate: date.add(
      //未来30天可选
      Duration(days: 30),
    ),
  );
}

///日历IOS风格
Future _showDatePicker2(context) {
  var date = DateTime.now();
  return showCupertinoModalPopup(
    context: context,
    builder: (ctx) {
      return SizedBox(
        height: 200,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.dateAndTime,
          minimumDate: date,
          maximumDate: date.add(
            Duration(days: 30),
          ),
          maximumYear: date.year + 1,
          onDateTimeChanged: (DateTime value) {
            print(value);
          },
        ),
      );
    },
  );
}
