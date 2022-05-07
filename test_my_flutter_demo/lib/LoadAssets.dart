import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:test_my_flutter_demo/widgets/MyIconFont.dart';

///加载assets文件中的内容
class LoadAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('加载assets文件中的内容'),
      ),
      body: Column(
        children: [
          LoadAssetsImg(),
          LoadAssetsFont(),
          SizedBox(
            height: 180.0, // must
            child: LoadAssetsJson(),
          ),
        ],
      ),
    );
  }
}

///加载图片
class LoadAssetsImg extends StatefulWidget {
  @override
  _LoadAssetsImgState createState() => _LoadAssetsImgState();
}

class _LoadAssetsImgState extends State<LoadAssetsImg> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Image.asset("assets/images/iocn_diqiu.png", width: 60, height: 60),
          ],
        ),
        const Image(
            image: AssetImage("assets/images/error_null.png"),
            width: 60,
            height: 60),
        Row(
          ///Flutter默认包含了一套Material Design的字体图标
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Icon(Icons.accessible, color: Colors.green, size: 60.0),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0),
              child: Icon(Icons.error, color: Colors.green, size: 60.0),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Icon(Icons.fingerprint, color: Colors.green, size: 60.0),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0),
          child: Row(
            ///自定义ICON图标
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(IconData(0xe60c, fontFamily: 'IconFont'),
                  color: Colors.red, size: 60.0),
              Icon(IconFont.icon_toufangluru, color: Colors.red, size: 60.0),
            ],
          ),
        ),
      ],
    );
  }
}

///加载文字
class LoadAssetsFont extends StatefulWidget {
  @override
  _LoadAssetsFont createState() => _LoadAssetsFont();
}

class _LoadAssetsFont extends State<LoadAssetsFont> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: Text(
            '测试文字 1',
            style: TextStyle(fontSize: 26.0, color: Colors.red[600]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: Text(
            '测试文字 2',
            style: TextStyle(
                fontFamily: "Charmonman",
                fontSize: 26.0,
                color: Colors.deepOrange[400],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: Text(
            '测试文字--幼圆 3',
            style: TextStyle(
                fontFamily: "youyuan",
                fontSize: 26.0,
                color: Colors.yellow[400]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: Text(
            '测试文字--苹果黑丽 4',
            style: TextStyle(
                fontFamily: "pingguolihei",
                fontSize: 26.0,
                color: Colors.deepOrange[400],
            ),
          ),
        ),
      ],
    );
  }
}

///加载JSON文件
class LoadAssetsJson extends StatefulWidget {
  @override
  _LoadAssetsJson createState() => _LoadAssetsJson();
}

class _LoadAssetsJson extends State<LoadAssetsJson> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString("assets/country.json"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> data = json.decode(snapshot.data.toString());
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Name: ${data[index]["name"]}"),
                      Text("Age: ${data[index]["age"]}"),
                      Text("Height: ${data[index]["height"]}"),
                      Text("Gender: ${data[index]["gender"]}"),
                    ],
                  ),
                );
              },
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
