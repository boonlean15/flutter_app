import 'package:flutter/material.dart';
import './config/index.dart';
import './page/index_page.dart';
import './provide/CurrentIndexProvide.dart';
import 'package:provide/provide.dart';

void main(){
  var currentIndexProvide = CurrentIndexProvide();
  var providers = Providers();
  providers..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide));//把Provider添加到Providers
  runApp(ProviderNode(child: MyApp(), providers: providers));
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: KString.mainTitle,
      home:Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        height: ScreenUtil.instance.setHeight(800),
        child: FlareActor(
          "flrs/skill.flr",
          alignment: Alignment.center,
          isPaused: false,
//          callback: (anim) {
//            if (anim == "attack") {
//              setState(() {
//                _attack = false;
//              });
//            }
//          },
          animation: "end",
        ),
      ),
    );
    );
  }
}
