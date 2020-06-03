import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapp/page/video_page.dart';
import '../config/index.dart';
import '../page/home_page.dart';
import '../page/member.dart';
import '../page/shopping_cart_page.dart';
import 'package:provide/provide.dart';
import '../provide/CurrentIndexProvide.dart';

class IndexPage extends StatelessWidget{

  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text(KString.homeTitle),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category),
      title: Text(KString.categoryTitle),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      title: Text(KString.shoppingCartTitle),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      title: Text(KString.memberTitle),
    ),
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    VideoPage(),
    ShoppingCartPage(),
    MemberPage()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Provide<CurrentIndexProvide>(
        builder: (context,child,scope){
          int currentIndex = Provide.value<CurrentIndexProvide>(context).currentIndex;
          return Scaffold(
            backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              items: bottomTabs,
              onTap: (index){
                Provide.value<CurrentIndexProvide>(context).changeIndex(index);
              },
            ),
            body: IndexedStack(
              children: tabBodies,
              index: currentIndex,
            ),
          );
        }
    );
  }

}