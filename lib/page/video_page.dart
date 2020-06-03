import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import '../service/service_method.dart';
import '../config/index.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => new _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Map> choices;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 7);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length)
      return;
    _tabController.animateTo(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('AppBar Bottom Widget'),
          leading: new IconButton(
            tooltip: 'Previous choice',
            icon: const Icon(Icons.arrow_back),
            onPressed: () { _nextPage(-1); },
          ),
          actions: <Widget>[
            new IconButton(
              icon: const Icon(Icons.arrow_forward),
              tooltip: 'Next choice',
              onPressed: () { _nextPage(1); },
            ),
          ],
          bottom: new PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: new Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: new Container(
                height: 48.0,
                alignment: Alignment.center,
                child: new TabPageSelector(controller: _tabController),
              ),
            ),
          ),
        ),
        body:FutureBuilder(
          future: request(KString.videoPageUrl,formData:null),//KString.homePageUrl
          builder: (context,snapshot){
            if(snapshot.hasData){
              var data = jsonDecode(jsonEncode(snapshot.data).toString());
              List<Map> videoDataList = (data['data']['videos'] as List).cast(); // 轮播视频
              List<Widget> listVideoCard = videoDataList.map((item){
                return VideoCard(video:item);
              }).toList();
              return TabBarView(
                controller: _tabController,
                children:listVideoCard,
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
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  const VideoCard({ Key key, this.video }) : super(key: key);

  final Map video;
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new Container(
        child:Column(
          children: <Widget>[
            Chewie(
              new VideoPlayerController.network(video['url']),
              key:UniqueKey(),
              aspectRatio: 16 / 9,
              autoPlay: !true,
              looping: true,
              showControls: true,
              autoInitialize: !true,
              // 占位图
              placeholder: new Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      '${video['poster']}',
                    ),
                  ),
                ),
              ),

              // 拖动条样式颜色
              materialProgressColors: new ChewieProgressColors(
                playedColor: Colors.red,
                handleColor: Colors.blue,
                backgroundColor: Colors.grey,
                bufferedColor: Colors.lightGreen,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: (video['listContent'] as List).cast().length,
                    itemBuilder: (context,index){
                      return _item(index,context);
                    }
                ),
            ),
          ],
        ),
    );
  }
  Widget _item(index,context){
    List<Map> contents = (video['listContent'] as List).cast();
    return InkWell(
      onTap: (){
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text('${contents[index]['description']}')));
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
            Image.network('${contents[index]['url']}'),
            Text('${contents[index]['name']}'),
            Container(
                margin: EdgeInsets.only(top:15),
                child:Text(
                  '${contents[index]['description']}',
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
