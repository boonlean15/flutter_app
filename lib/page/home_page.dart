import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../service/service_method.dart';
import '../config/index.dart';
import 'package:english_words/english_words.dart';
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  List<Map> wrapCustomerList=[];
  int page = 1;
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            KString.yiqiwenhuaTitle,
            style: TextStyle(
              color: Color.fromRGBO(245, 245, 245, 1.0),
              fontSize: 26,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        backgroundColor: KColor.defaultColor,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.person),
            onPressed: (){
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: request(KString.homePageUrl,formData:null),//KString.homePageUrl
        builder: (context,snapshot){
         if(snapshot.hasData){
           var data = jsonDecode(jsonEncode(snapshot.data).toString());
           List<Map> culturesDataList = (data['data']['cultures'] as List).cast(); // 顶部轮播
           List<Map> membersDataList = (data['data']['members'] as List).cast(); // 成员轮播
           List<Map> cultureItemsList = (data['data']['culture'] as List).cast(); //culture
           List<Map> serviceCustomerList = (data['data']['serviceCustomers'] as List).cast(); //服务客户
           return EasyRefresh(
             refreshFooter: ClassicsFooter(
               key:_footerKey,
               bgColor:Colors.grey,
               textColor: Colors.blueAccent,
               moreInfoColor: Colors.blueAccent,
               showMore: true,
               noMoreText: '',
               moreInfo: '加载中',
               loadReadyText:'上拉加载....'
             ),
             child: ListView(
               children: <Widget>[
                 CultureDiy(culturesDataList:culturesDataList),
                 MemberDiy(membersDataList:membersDataList),
                 CultureItem(cultureItemsList:cultureItemsList),
                 ServiceCustomer(serviceCustomerList:serviceCustomerList),
                 _loadMoreService(),
               ],
             ),
             loadMore: ()async{
               print('开始加载更多');
               var formPage={'page': page};
               await  request('getHomeServiceCustomer',formData:formPage).then((val){
                 var data = jsonDecode(jsonEncode(val).toString());
                 print(data.toString());
                 List<Map> newList = (data['data']['serviceCustomers'] as List ).cast();
                 setState(() {
                   wrapCustomerList.addAll(newList);
                   page++;
                 });
               });
             },
           );
         }else if(snapshot.hasError){
           return new Text("${snapshot.error}");
         }else {
           return Container(
             child: Center(
               child: CircularProgressIndicator(),
             ),
           );
         }
        },
      ),

    );
  }
  Widget _loadMoreService(){

    return Container(

        child:Column(
          children: <Widget>[
            hotTitle,
            _wrapServiceList(),
          ],
        )
    );
  }
  Widget hotTitle = Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10.0, 2.0, 0,5.0),
        decoration: BoxDecoration(
            color:Colors.white,
            border: Border(
                bottom: BorderSide(width:0.5,color:Colors.black12)
            )
        ),
        child:Text(
            '客户列表',
            style:TextStyle(color:Colors.black54)
        )
    );
    Widget _wrapServiceList(){
      List<Widget> listWidget = wrapCustomerList.map((item){
        return _item(item);
      }).toList();
      return  Wrap(
        spacing: 2,
        children: listWidget,
      );
    }

    Widget _item(item){
      return InkWell(
          onTap:(){
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(new SnackBar(content: Text('${item['description']}')));
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color:Colors.white,
            padding: EdgeInsets.all(5.0),
            margin:EdgeInsets.only(bottom:3.0),
            child: Column(
              children: <Widget>[
                Image.network(item['image'],width: ScreenUtil().setWidth(333),),
                Text('${item['name']}'),
                Container(
                    margin: EdgeInsets.only(top:15),
                    child:Text(
                      '${item['description']}',
                      style: TextStyle(
                        color:Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                ),
              ],
            ),
          )
      );
  }

  @override
  bool get wantKeepAlive => true;
}
class CultureDiy extends StatelessWidget{

  final List culturesDataList;
  CultureDiy({Key key,this.culturesDataList}):super(key:key);

  @override
  Widget build(BuildContext context) {

    return Container(
      color:Colors.white,
      height: ScreenUtil().setHeight(350),
      width: ScreenUtil().setWidth(400),
      child:Image.network("${culturesDataList[0]['images']}",fit:BoxFit.fill),
    );
  }
}

class MemberDiy extends StatelessWidget {
  final List<Map> membersDataList ;
  MemberDiy({Key key,this.membersDataList}) : super(key:key);
  @override
  Widget build(BuildContext context) {

    return Container(
      width: ScreenUtil().setWidth(400),
      height: ScreenUtil().setHeight(150),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
            '${membersDataList[0]['background']}',
          ),
        ),
      ),
      child: Swiper(
        itemCount: membersDataList.length,
        itemBuilder: (context,index){
          return Container(
            margin: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                 Container(
                     padding: EdgeInsets.fromLTRB(20.0,0,0,0),
                     child: Image.network('${membersDataList[index]['members']['avatar']}',fit:BoxFit.contain),
                 ),
                 Container(
                   padding: EdgeInsets.fromLTRB(50.0,0,0,0),
                   child: Text(
                     '${membersDataList[index]['members']['introduction']}',
                     maxLines: 1,
                     overflow:TextOverflow.ellipsis ,
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: ScreenUtil().setSp(26),
                       fontFamily: FontStyle.italic.toString(),
                     ),
                   ),
                 ),
              ],
            ),
          );
        },
        autoplay: true,
        pagination: new SwiperPagination(),
      ),
    );
  }
}
//文化图片介绍
class CultureItem extends StatelessWidget{
  final List cultureItemsList;
  CultureItem({Key key,this.cultureItemsList}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    if(cultureItemsList.length>10){
      cultureItemsList.removeRange(10, cultureItemsList.length);
    }
    var tempIndex=-1;
    return Container(
      color:Colors.white70,
      margin: EdgeInsets.only(top: 5.0),
      height: ScreenUtil().setHeight(320),
      padding:EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: cultureItemsList.map((item){
          tempIndex++;
          return _gridViewItemUI(context, item,tempIndex);
        }).toList(),
      ),
    );
  }
  Widget _gridViewItemUI(BuildContext context,item,index){
    final _wordList = <WordPair>[]..addAll(generateWordPairs().take(100));
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context){
                final tiles = _wordList.map(
                        (pair){
                      return ListTile(
                        title: new Text(
                          pair.asPascalCase,
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    }
                );
                final divied = ListTile.divideTiles(context:context,tiles: tiles,).toList();
                return new Scaffold(
                  appBar: new AppBar(
                    title: new Text('detailPage'),
                  ),
                  body: new ListView(children: divied),
                );
              }
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width:ScreenUtil().setWidth(95)),
          Text(item['title'])
        ],
      ),
    );
  }
}
class ServiceCustomer extends StatelessWidget {
  final List  serviceCustomerList;

  ServiceCustomer({Key key, this.serviceCustomerList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration:BoxDecoration(
          color:Colors.grey,
          border:Border(
              left: BorderSide(width:0.5,color:Colors.black12)
          )
      ),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _serviceList(context)
        ],
      ),
    );

  }

//标题
  Widget _titleWidget(){
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10.0, 2.0, 0,5.0),
        decoration: BoxDecoration(
            color:Colors.white,
            border: Border(
                bottom: BorderSide(width:0.5,color:Colors.black12)
            )
        ),
        child:Text(
            '服务客户',
            style:TextStyle(color:Colors.blueGrey)
        )
    );
  }

  Widget _serviceList(BuildContext context){

    return  Container(
      height: ScreenUtil().setHeight(380),

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: serviceCustomerList.length,
        itemBuilder: (context,index){
          return _item(index,context);
        },
      ),
    );
  }

  Widget _item(index,context){
    return InkWell(
      onTap: (){
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text('${serviceCustomerList[index]['name']}')));
      },
      child: Container(
        width: ScreenUtil().setWidth(280),
        padding: EdgeInsets.all(8.0),
        decoration:BoxDecoration(
            color:Colors.white,
            border:Border(
                left: BorderSide(width:0.5,color:Colors.black12)
            )
        ),
        child: Column(
          children: <Widget>[
            Image.network(serviceCustomerList[index]['image']),
            Text('${serviceCustomerList[index]['name']}'),
            Container(
              margin: EdgeInsets.only(top:15),
              child:Text(
                '${serviceCustomerList[index]['description']}',
                style: TextStyle(
                  color:Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}