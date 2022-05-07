import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_my_flutter_demo/PublicPracticalMethod.dart';

///基础组件
class BasicComponents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return TextComponent();
    // return ButtonComponent();
    // return ImageComponent();
    // return TestFieldComponent();
    // return TextForm();
    return ProgressRoute();
  }
}

///Text
class TextComponent extends StatefulWidget {
  @override
  _TextComponent createState() => _TextComponent();
}

class _TextComponent extends State<TextComponent> {
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  bool _discoloration = false; //变色开关

  @override
  void dispose() {
    //用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text组件'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red[300],
            width: 500.0,
            child: const Text(
              "Hello world",
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            color: Colors.deepOrange[300],
            width: 500.0,
            child: Text(
              "Hello world! I'm Jack." * 4,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            color: Colors.yellow[300],
            width: 500.0,
            child: const Text(
              "Hello world",
              textScaleFactor: 1.5,
            ),
          ),
          Container(
            color: Colors.greenAccent[400],
            width: 450.0,
            child: Text(
              "Hello world" * 8,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 450.0,
            child: Text(
              "Hello world",
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 20.0,
                height: 1.5,
                background: Paint()..color = Colors.yellow,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ),
          Container(
            width: 450.0,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: "我将会成为"),
                  TextSpan(
                    text: "【海贼王】",
                    style: TextStyle(
                        fontSize: 26.0,
                        color: _discoloration ? Colors.green : Colors.red),
                    recognizer: _tapGestureRecognizer
                      ..onTap = () {
                        setState(() {
                          _discoloration = !_discoloration;
                          LogUtils.i("我被点击了");
                        });
                      },
                  ),
                  const TextSpan(text: "的男人"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///button
class ButtonComponent extends StatefulWidget {
  @override
  _ButtonComponent createState() => _ButtonComponent();
}

class _ButtonComponent extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Button组件"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  LogUtils.i("ElevatedButton按钮  被点击了");
                },
                child: const Text("ElevatedButton按钮"),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              LogUtils.i("TextButton按钮  被点击了");
            },
            child: const Text("TextButton按钮"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => _textButtonColor(context, states)),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              LogUtils.i("OutlinedButton按钮  被点击了");
            },
            child: const Text("OutlinedButton按钮"),
          ),
          IconButton(
            onPressed: () {
              LogUtils.i("IconButton按钮  被点击了");
            },
            icon: const Icon(Icons.thumb_up),
          ),
        ],
      ),
    );
  }
}

///设置 TextButton按钮背景色方法
_textButtonColor(BuildContext context, Set<MaterialState> states) {
  if (states.contains(MaterialState.pressed)) {
    return Theme.of(context).colorScheme.primary.withOpacity(0.5);
  } else {
    return Colors.purple[200];
  }
}

///图片控件
class ImageComponent extends StatefulWidget {
  @override
  _ImageComponent createState() => _ImageComponent();
}

class _ImageComponent extends State<ImageComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("图片控件"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: NetworkImage(
                    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201408%2F31%2F20140831001338_C5RuV.png&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650781475&t=8c4b3c83096b07d6a8c16c82f5dea6d2"),
                width: 90.0,
                height: 90.0,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Image(
              image: NetworkImage(
                  "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201408%2F31%2F20140831001338_C5RuV.png&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650781475&t=8c4b3c83096b07d6a8c16c82f5dea6d2"),
              width: 90.0,
              height: 90.0,
              color: Colors.blue,
              colorBlendMode: BlendMode.difference,
            ),
          ),
        ],
      ),
    );
  }
}

///输入框控件
class TestFieldComponent extends StatefulWidget {
  @override
  _TestFieldComponent createState() => _TestFieldComponent();
}

class _TestFieldComponent extends State<TestFieldComponent> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      LogUtils.i("获取输入框的内容 =-= ${_nameController.text}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("输入框控件"),
      ),
      body: Column(
        children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "请输入用户名",
              fillColor: Colors.blue.shade100,
              filled: true,
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            controller: _nameController,
          ),
          Container(
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "您的登录密码",
                fillColor: Colors.blue.shade100,
                filled: true,
                prefixIcon: Icon(Icons.lock),
                // 未获得焦点下划线设为灰色
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                //获得焦点下划线设为蓝色
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              obscureText: true,
            ),
          ),
          buildTextField1(),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                  child: const Text('确定'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

///自定义TextFormField 设定border大小
Widget buildTextField() {
  return Container(
    margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
    padding: const EdgeInsets.all(8.0),
    alignment: Alignment.center,
    height: 60.0,
    decoration: BoxDecoration(
      color: Colors.blueGrey,
      border: Border.all(color: Colors.black54, width: 1.0),
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: TextFormField(
      decoration: const InputDecoration.collapsed(
        hintText: 'hello',
      ),
    ),
  );
}

///自定义TextField
Widget buildTextField1() {
  return Theme(
    data: ThemeData(primaryColor: Colors.red, hintColor: Colors.blue),
    child: Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    ),
  );
}

/**
 * 输入框验证
 */
class TextForm extends StatefulWidget {
  _TextFormState createState() => new _TextFormState();
}

class _TextFormState extends State<TextForm> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("输入框表单"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Form(
          autovalidateMode: AutovalidateMode.always, key: _formKey, //开启自动校验
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                controller: _unameController,
                decoration: InputDecoration(
                  labelText: "用户名",
                  hintText: "用户名或邮箱",
                  icon: Icon(Icons.person),
                ),
                validator: (v) {
                  return v!.trim().isNotEmpty ? null : "用户名不能为空";
                },
              ),
              TextFormField(
                controller: _pwdController,
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "您的登录密码",
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                //校验密码
                validator: (v) {
                  return v!.trim().length > 5 ? null : "密码不能少于6位";
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
//                       child: RaisedButton(
//                         padding: EdgeInsets.all(15.0),
//                         child: Text("登录"),
// //                        color: Theme.of(context).primaryColor,
//                         textColor: Colors.white,
//                         onPressed: () {
//                           //在这里不能通过此方式获取FormState，context不对
//                           //print(Form.of(context));
//
//                           // 通过_formKey.currentState 获取FormState后，
//                           // 调用validate()方法校验用户名密码是否合法，校验
//                           // 通过后再提交数据。
//                           if ((_formKey.currentState as FormState).validate()) {
//                             //验证通过提交数据
//                             print(
//                                 "用户名：${_unameController.text} =-= 密码：${_pwdController.text}");
//                           }
//                         },
//                       ),

                      child: ElevatedButton(
                        onPressed: () {
                          //在这里不能通过此方式获取FormState，context不对
                          //通过_formKey.currentState 获取FormState后，
                          //调用validate()方法校验用户名密码是否合法，校验
                          //通过后再提交数据
                          if ((_formKey.currentState as FormState).validate()) {
                            //验证通过提交数据
                            LogUtils.i(
                                "用户名：${_unameController.text} =-= 密码：${_pwdController.text}");
                          }
                        },
                        child: const Text("登录",
                            style: TextStyle(color: Colors.deepOrange)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => _textButtonColor(context, states)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/**
 * 进度指示器
 */
class ProgressRoute extends StatefulWidget {
  @override
  _ProgressRouteState createState() => _ProgressRouteState();
}

class _ProgressRouteState extends State<ProgressRoute>
    with SingleTickerProviderStateMixin {
  //使用到动画效果所以加入SingleTickerProviderStateMixin

  late AnimationController _animationController;

  @override
  void initState() {
//动画执行时间3秒
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animationController.forward();
    _animationController.addListener(() => setState(() => {}));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: ColorTween(begin: Colors.grey, end: Colors.blue)
                  .animate(_animationController), // 从灰色变成蓝色
              value: _animationController.value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: ColorTween(begin: Colors.grey, end: Colors.blue)
                  .animate(_animationController), // 从灰色变成蓝色
              value: _animationController.value,
            ),
          )
        ],
      ),
    );
  }
}
