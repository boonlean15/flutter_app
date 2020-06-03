import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllPageDetail extends StatelessWidget {
  final String title;
  AllPageDetail({Key key,this.title}): super(key:key);
  @override
  Widget build(BuildContext context) {
          return Container(
              width: ScreenUtil().setWidth(750),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child:Text(title)
          );
  }
}