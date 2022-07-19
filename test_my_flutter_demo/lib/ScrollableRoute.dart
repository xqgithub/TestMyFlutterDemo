import 'dart:ui';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'PublicPracticalMethod.dart';
import 'sliver_flexible_header.dart';
import 'sliver_persistent_header_to_box.dart';

///可滚动组件

class ScrollableRoute extends StatefulWidget {
  @override
  _ScrollableRoute createState() => _ScrollableRoute();
}

class _ScrollableRoute extends State<ScrollableRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("可滚动组件"),
      ),
      // body: _TestSingleChildScrollView(),
      // body: _TestListView1(),
      // body: _TestListView2(),
      // body: _TestListView3(),
      // body: _TestListView4(),
      // body: InfiniteListView(),
      // body: ScrollControllerTestRoute(),
      // body: ScrollNotificationTestRoute(),
      // body: AnimatedListRoute(),
      // body: _TestGridView1(),
      // body: _TestGridView2(),
      // body: _TestGridView3(),
      //  body: _TestGridView4(),
      //  body: InfiniteGridView(),
      // body: CustomScrollViewTestRoute(),
      // body: SliverFlexibleHeaderRoute(),
      // body: SliverPersistentHeaderToBoxRoute(),
      body: NestedScrollViewRoute(),
      // body: KeepAliveTest(),
    );
  }
}

///1.SingleChildScrollView只应在期望的内容不会超过屏幕太多时使用，这是因为SingleChildScrollView不支持基于Sliver的延迟实例化模型，
///2.所以如果预计视口可能包含超出屏幕尺寸太多的内容时，那么使用SingleChildScrollView将会非常昂贵（性能差），此时应该使用一些支持Sliver延迟加载的可滚动组件，如ListView
_TestSingleChildScrollView() {
  String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ一二三四五六七八九十";
  return Scrollbar(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          //动态创建一个List<Widget>
          children: str
              .split("")
          //每一个字母都用一个Text显示,字体为原来的两倍
              .map((c) =>
              Text(
                c,
                textScaleFactor: 2.0,
              ))
              .toList(),
        ),
      ),
    ),
  );
}

///1.适合只有少量的子组件的情况，因为这种方式需要将所有children都提前创建好（这需要做大量工作）
///2.实际上通过此方式创建的ListView和使用SingleChildScrollView+Column的方式没有本质的区别
_TestListView1() {
  return ListView(
    shrinkWrap: true,
    padding: const EdgeInsets.all(20.0),
    children: <Widget>[
      const Text('I\'m dedicating every day to you'),
      const Text('Domestic life was never quite my style'),
      const Text('When you smile, you knock me out, I fall apart'),
      const Text('And I thought I was so smart'),
    ],
  );
}

///ListView.builder适合列表项比较多（或者无限）的情况，因为只有当子组件真正显示的时候才会被创建，也就说通过该构造函数创建的ListView是支持基于Sliver的懒加载模型的
_TestListView2() {
  return ListView.builder(
    itemCount: 100,
    itemExtent: 50.0, //强制高度为50.0
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text("${index}"),
      );
    },
  );
}

///ListView.separated可以在生成的列表项之间添加一个分割组件，它比ListView.builder多了一个separatorBuilder参数，该参数是一个分割组件生成器
_TestListView3() {
  //下划线widget预定义以供复用。
  Widget divider1 = Divider(
    color: Colors.blue,
  );
  Widget divider2 = Divider(color: Colors.green);

  return ListView.separated(
    itemCount: 100,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text("${index}"),
      );
    },

    ///分割器构造器
    separatorBuilder: (BuildContext context, int index) {
      return index % 2 == 0 ? divider1 : divider2;
    },
  );
}

///ListView添加固定列表头
_TestListView4() {
  return Column(
    children: <Widget>[
      ListTile(
        title: Text("商品列表"),
      ),
      Expanded(
        child: ListView.separated(
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("${index}"),
            );
          },
          separatorBuilder: (context, index) => Divider(height: .0),
        ),
      ),
    ],
  );
}

///无限加载列表
class InfiniteListView extends StatefulWidget {
  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        //如果到了表尾
        if (_words[index] == loadingTag) {
          //不足100条，继续获取数据
          if (_words.length - 1 < 100) {
            //获取数据
            _retrieveData();
            //加载时显示loading
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else {
            //已经加载了100条数据，不再获取数据。
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
              child: Text(
                "没有更多了",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
        }
        //显示单词列表项
        return ListTile(title: Text(_words[index]));
      },
      separatorBuilder: (context, index) => Divider(height: .0),
    );
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 1)).then((e) {
      setState(() {
        //重新构建列表
        _words.insertAll(
          _words.length - 1,
          //每次生成20个单词
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList(),
        );
      });
    });
  }
}

///滚动监听及控制
class ScrollControllerTestRoute extends StatefulWidget {
  _ScrollControllerTestRoute createState() => new _ScrollControllerTestRoute();
}

class _ScrollControllerTestRoute extends State<ScrollControllerTestRoute> {
  ScrollController _controller = new ScrollController();

  //是否显示“返回到顶部”按钮
  bool showToTopBtn = false;

  @override
  void initState() {
    super.initState();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      print(_controller.offset); //打印滚动位置
      if (_controller.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_controller.offset >= 1000 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("滚动监听及控制"),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: 100,
          itemExtent: 50.0,
          controller: _controller,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("$index"),
            );
          },
        ),
      ),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: () {
          //返回到顶部时执行动画
          _controller.animateTo(
            0.0,
            duration: Duration(microseconds: 200),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}

///滚动监听 NotificationListener
class ScrollNotificationTestRoute extends StatefulWidget {
  @override
  _ScrollNotificationTestRouteState createState() =>
      new _ScrollNotificationTestRouteState();
}

class _ScrollNotificationTestRouteState
    extends State<ScrollNotificationTestRoute> {
  String _progress = "0%"; //保存进度百分比

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("滚动监听 NotificationListener"),
      ),
      body: Scrollbar(
        //进度条
        // 监听滚动通知
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            double progress = notification.metrics.pixels /
                notification.metrics.maxScrollExtent;
            //重新构建
            setState(() {
              _progress = "${(progress * 100).toInt()}%";
            });
            print("BottomEdge: ${notification.metrics.extentAfter == 0}");
            return true; //放开此行注释后，进度条将失效
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ListView.builder(
                  itemCount: 100,
                  itemExtent: 50.0,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text("$index"));
                  }),
              CircleAvatar(
                //显示进度百分比
                radius: 30.0,
                child: Text(_progress),
                backgroundColor: Colors.black54,
              )
            ],
          ),
        ),
      ),
    );
  }
}

///AnimatedList
class AnimatedListRoute extends StatefulWidget {
  const AnimatedListRoute({Key? key}) : super(key: key);

  @override
  _AnimatedListRouteState createState() => _AnimatedListRouteState();
}

class _AnimatedListRouteState extends State<AnimatedListRoute> {
  var data = <String>[];
  int counter = 5;

  final globalKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    for (var i = 0; i < counter; i++) {
      data.add('${i + 1}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedList(
          key: globalKey,
          initialItemCount: data.length,
          itemBuilder: (BuildContext context,
              int index,
              Animation<double> animation,) {
            //添加列表项时会执行渐显动画
            return FadeTransition(
              opacity: animation,
              child: buildItem(context, index),
            );
          },
        ),
        buildAddBtn(),
      ],
    );
  }

  // 创建一个 “+” 按钮，点击后会向列表中插入一项
  Widget buildAddBtn() {
    return Positioned(
      child: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // 添加一个列表项
          data.add('${++counter}');
          // 告诉列表项有新添加的列表项
          globalKey.currentState!.insertItem(data.length - 1);
          print('添加 $counter');
        },
      ),
      bottom: 30,
      left: 0,
      right: 0,
    );
  }

  // 构建列表项
  Widget buildItem(context, index) {
    String char = data[index];
    return ListTile(
      //数字不会重复，所以作为Key
      key: ValueKey(char),
      title: Text(char),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        // 点击时删除
        onPressed: () => onDelete(context, index),
      ),
    );
  }

  void onDelete(context, index) {
    setState(() {
      globalKey.currentState!.removeItem(
        index,
            (context, animation) {
          // 删除过程执行的是反向动画，animation.value 会从1变为0
          var item = buildItem(context, index);
          print('删除 ${data[index]}');
          data.removeAt(index);
          // 删除动画是一个合成动画：渐隐 + 缩小列表项告诉
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              //让透明度变化的更快一些
              curve: const Interval(0.5, 1.0),
            ),
            // 不断缩小列表项的高度
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: 0.0,
              child: item,
            ),
          );
        },
        duration: Duration(milliseconds: 200), // 动画时间为 200 ms
      );
    });
  }
}

///GridView,gridDelegate---SliverGridDelegateWithFixedCrossAxisCount
///该子类实现了一个横轴为固定数量子元素的layout算法
_TestGridView1() {
  return GridView(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //横轴三个子widget
        childAspectRatio: 1.0 //宽高比为1时，子widget
    ),
    children: buildListViewItemList(),
  );
}

List<Widget> buildListViewItemList() {
  List<Widget> list = [];

  ///模拟的8条数据
  for (int i = 0; i < 8; i++) {
    list.add(buildListViewItemWidget(i));
  }
  return list;
}

///创建GridView使用的子布局
Widget buildListViewItemWidget(int index) {
  return new Container(

    ///内容剧中
    alignment: Alignment.center,

    ///根据角标来动态计算生成不同的背景颜色
    color: Colors.cyan[100 * (index % 9)],
    child: new Text('grid item $index'),
  );
}

///GridView.count,构造函数内部使用了SliverGridDelegateWithFixedCrossAxisCount，我们通过它可以快速的创建横轴固定数量子元素的GridView
_TestGridView2() {
  return GridView.count(
    crossAxisCount: 4,
    childAspectRatio: 1.0,
    children: <Widget>[
      Icon(Icons.ac_unit),
      Icon(Icons.airport_shuttle),
      Icon(Icons.all_inclusive),
      Icon(Icons.beach_access),
      Icon(Icons.cake),
      Icon(Icons.free_breakfast),
    ],
  );
}

///GridView,gridDelegate---SliverGridDelegateWithMaxCrossAxisExtent
///该子类实现了一个横轴子元素为固定最大长度的layout算法
_TestGridView3() {
  return GridView(
    padding: EdgeInsets.zero,
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120.0, childAspectRatio: 2.0 //宽高比为2
    ),
    children: <Widget>[
      Icon(Icons.ac_unit),
      Icon(Icons.airport_shuttle),
      Icon(Icons.all_inclusive),
      Icon(Icons.beach_access),
      Icon(Icons.cake),
      Icon(Icons.free_breakfast),
    ],
  );
}

///GridView.extent,构造函数内部使用了SliverGridDelegateWithMaxCrossAxisExtent，我们通过它可以快速的创建纵轴子元素为固定最大长度的的GridView
_TestGridView4() {
  return GridView.extent(
    maxCrossAxisExtent: 120.0,
    childAspectRatio: 2,
    children: <Widget>[
      Icon(Icons.ac_unit),
      Icon(Icons.airport_shuttle),
      Icon(Icons.all_inclusive),
      Icon(Icons.beach_access),
      Icon(Icons.cake),
      Icon(Icons.free_breakfast),
    ],
  );
}

///GridView 无限加载
///GridView.builder,动态创建子widget
class InfiniteGridView extends StatefulWidget {
  @override
  _InfiniteGridViewState createState() => new _InfiniteGridViewState();
}

class _InfiniteGridViewState extends State<InfiniteGridView> {
  List<IconData> _icons = []; //保存Icon数据

  @override
  void initState() {
    // 初始化数据
    _retrieveIcons();
  }

  //模拟异步获取数据
  void _retrieveIcons() {
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      setState(() {
        _icons.addAll([
          Icons.ac_unit,
          Icons.airport_shuttle,
          Icons.all_inclusive,
          Icons.beach_access,
          Icons.cake,
          Icons.free_breakfast
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GridView无限加载列表"),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //每行3列
            childAspectRatio: 1, //显示区域宽高相等
          ),
          physics: BouncingScrollPhysics(),
          itemCount: _icons.length,
          itemBuilder: (context, index) {
            //如果显示到最后一个并且Icon总数小于100时继续获取数据
            if (index == _icons.length - 1 && _icons.length < 100) {
              _retrieveIcons();
            }
            return Icon(_icons[index]);
          },
        ));
  }
}

///CustomScrollView,可以使用Sliver来自定义滚动模型（效果）的组件。它可以包含多种滚动模型
///功能就是 一个页面，顶部需要一个GridView，底部需要一个ListView，而要求整个页面的滑动效果是统一的，即它们看起来是一个整体，类似胶水
class CustomScrollViewTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //因为本路由没有使用Scaffold，为了让子级Widget(如Text)使用
    //Material Design 默认的样式风格,我们使用Material作为本路由的根。
    return Material(
      child: CustomScrollView(
        slivers: <Widget>[

          ///AppBar，包含一个导航栏,
          ///SliverAppBar对应AppBar，两者不同之处在于SliverAppBar可以集成到CustomScrollView。
          ///SliverAppBar可以结合FlexibleSpaceBar实现Material Design中头部伸缩的模型，具体效果
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 50.0, bottom: 15.0),
              title: const Text("CustomScrollView"),
              background: Image.asset(
                "assets/images/lufei.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),

            ///SliverGrid
            ///它用SliverPadding包裹以给SliverGrid添加补白。SliverGrid是一个两列，宽高比为4的网格，它有20个子组件
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //Grid按两列显示
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 4.0),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建子widget
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.cyan[100 * (index % 9)],
                    child: new Text('grid item $index'),
                  );
                },
                childCount: 20,
              ),
            ),
          ),

          ///SliverFixedExtentList：它是一个所有子元素高度都为50像素的列表
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                //创建列表项
                return Container(
                  alignment: Alignment.center,
                  color: Colors.lightBlue[100 * (index % 9)],
                  child: new Text('list item $index'),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}

///KeepAliveWrapper 列表缓存测试
class KeepAliveTest extends StatelessWidget {
  const KeepAliveTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (_, index) {
      return KeepAliveWrapper(
        // 为 true 后会缓存所有的列表项，列表项将不会销毁。
        // 为 false 时，列表项滑出预加载区域后将会别销毁。
        // 使用时一定要注意是否必要，因为对所有列表项都缓存的会导致更多的内存消耗
        keepAlive: true,
        child: ListItem(index: index),
      );
    });
  }
}

class ListItem extends StatefulWidget {
  const ListItem({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text('${widget.index}'));
  }

  @override
  void dispose() {
    LogUtils.i('dispose ${widget.index}');
    super.dispose();
  }
}

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper({
    Key? key,
    this.keepAlive = true,
    required this.child,
  }) : super(key: key);
  final bool keepAlive;
  final Widget child;

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant KeepAliveWrapper oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) {
      // keepAlive 状态需要更新，实现在 AutomaticKeepAliveClientMixin 中
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

///实现一个类似旧版本微信朋友圈顶部头图的功能
class SliverFlexibleHeaderRoute extends StatefulWidget {
  const SliverFlexibleHeaderRoute({Key? key}) : super(key: key);

  @override
  State<SliverFlexibleHeaderRoute> createState() =>
      _SliverFlexibleHeaderRouteState();
}

class _SliverFlexibleHeaderRouteState extends State<SliverFlexibleHeaderRoute> {
  double _initHeight = 250;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics:
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverFlexibleHeader(
          visibleExtent: _initHeight,
          builder: (context, availableHeight, direction) {
            return GestureDetector(
              onTap: () => debugPrint('tap'),
              child: LayoutBuilder(builder: (context, cons) {
                return Image(
                  image: const AssetImage("assets/images/lufei.jpg"),
                  width: 50.0,
                  height: availableHeight,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.cover,
                );
              }),
            );
          },
        ),
        SliverToBoxAdapter(
          child: ListTile(
            onTap: () {
              setState(() {
                _initHeight = _initHeight == 250 ? 150 : 250;
              });
            },
            title: const Text('点击重置高度'),
            trailing: Text('当前高度 $_initHeight'),
          ),
        ),
        buildSliverList(30),
      ],
    );
  }
}

Widget buildSliverList([int count = 5]) {
  return SliverFixedExtentList(
    itemExtent: 50,
    delegate: SliverChildBuilderDelegate(
          (context, index) {
        return ListTile(title: Text('$index'), onTap: () => print(index));
      },
      childCount: count,
    ),
  );
}

///特定Item悬停
class SliverPersistentHeaderToBoxRoute extends StatelessWidget {
  const SliverPersistentHeaderToBoxRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey(1),
      slivers: [
        buildSliverList(5),
        SliverPersistentHeaderToBox.builder(builder: headerBuilder),
        buildSliverList(5),
        SliverPersistentHeaderToBox(child: wTitle('Title 2')),
        buildSliverList(50),
      ],
    );
  }

  // 当 header 固定后显示阴影
  Widget headerBuilder(context, maxExtent, fixed) {
    // 获取当前应用主题，关于主题相关内容将在后面章节介绍，现在
    // 我们要从主题中获取一些颜色
    var theme = Theme.of(context);
    return Material(
      color: fixed ? Colors.white : theme.canvasColor,
      child: wTitle('Title 1'),
      elevation: fixed ? 4 : 0,
      shadowColor: theme.appBarTheme.shadowColor,
    );
  }

  // 我们约定小写字母 w 开头的函数代表是需要构建一个 Widget，这比 buildXX 会更简洁
  Widget wTitle(String text) {
    return Material(
      child: ListTile(
        title: Text(text),
        onTap: () => debugPrint(text),
      ),
    );
  }
}

///NestedScrollView的用法
class NestedScrollViewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _tabs = <String>['猜你喜欢', '今日特价', '发现更多'];
    // 构建 tabBar
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: const Text('商城'),
                  floating: true,
                  snap: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: _tabs.map((String name) {
              return Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: buildSliverList(50),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
