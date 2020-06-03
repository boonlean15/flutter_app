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
      home:IndexPage(),
    );
  }
}