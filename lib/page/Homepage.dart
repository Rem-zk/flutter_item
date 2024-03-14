import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:untitled3/api%EF%BC%9F/dateofnavigaton.dart';
import 'package:untitled3/api%EF%BC%9F/firstpage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:untitled3/api%EF%BC%9F/newxiangmu.dart';
import 'package:untitled3/api%EF%BC%9F/tixishuju.dart';
import 'package:untitled3/api%EF%BC%9F/xiangmufeneli.dart';
import 'package:untitled3/page/collectionBottomSheet.dart';
import 'package:untitled3/page/itempage.dart';
import 'package:untitled3/page/newitempage.dart';
import 'package:untitled3/page/web_page.dart';
import '../api？/CommonWebsites.dart';
import '../controller/user.dart';
import '../leibiepage/leibie.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin{

  final usercontrooler=Get.find<userController>();
  NewShujuListRepository newShujuListRepository=NewShujuListRepository();
  XiangmuListRepository xiangmuListRepository=XiangmuListRepository();
  TixishujuListRepository tixishujuListRepository = TixishujuListRepository();
  RecommendListRepository recommendListRepository = RecommendListRepository();
  WebsiteListRepository websiteListRepository=WebsiteListRepository();
  DateofnavigationRepository dateofnavigationRepository=DateofnavigationRepository();
  List<Tab> _tabList = [
    Tab(
      child: Text("广场"),
    ),
    Tab(
      child: Text("项目"),
    ),
    Tab(
      child: Text("导航数据"),
    ),
    Tab(
      child: Text("体系数据"),
    ),
  ];
  late TabController _tabController;

  @override

  void initState(){
    super.initState();
    //fetchData();
    _tabController=TabController(length:_tabList.length, vsync: this);
  }


  Future<void> fetchData() async {
    try {
      await recommendListRepository.getDate();
      // 数据获取完成后，可以在这里更新 UI 或执行其他操作
      setState(() {});
    } catch (e) {
      // 处理异常
      print(e);
    }
  }

  Future<void> _onRefresh() async {
    // 模拟网络请求延迟
    await Future.delayed(Duration(seconds: 2));
    // 更新数据
    fetchData();
    _refreshController.refreshCompleted();
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);



  @override
  void dispose(){
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
        appBar: AppBar(
          elevation:0,
          shadowColor: Colors.white,
          surfaceTintColor:Colors.white,
          toolbarHeight: 100,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text("Android app",style: TextStyle(color: Colors.black),),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: TabBar(
              indicatorColor: Colors.blue,
              isScrollable: true,
              labelColor: Colors.black,
              controller: _tabController,
              //labelPadding: EdgeInsets.symmetric(horizontal: 30.0),
              tabs: _tabList,
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Color.fromRGBO(250, 250, 250, 1),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(12),
                height: 120,
                child: Column(
                  children: [
                    SizedBox(height: 18,),
                    Text('可能有用',style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
                    SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('app开发~',softWrap:true,maxLines: 2,style: TextStyle(fontSize: 16),),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child:
                  FutureBuilder(future: websiteListRepository.getDate(),
                      builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(snapshot.hasError){
                      return Text('Error:${snapshot.error}');
                    }else{
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder:(context, index) => Divider(height: 0,endIndent:25,indent:48,color: Colors.grey.shade300,),
                        itemCount: websiteListRepository.model.Webname.length,
                        itemBuilder: (context, index) {
                          Color itemColor = Color.fromRGBO(254, 254, 254, 1);
                          return ListTile(
                            tileColor: itemColor,
                            leading: Icon(Icons.public),
                            trailing: Icon(Icons.navigate_next),
                            title: Text(websiteListRepository.model.Webname[index],style: TextStyle(fontSize: 17),),
                              onLongPress:(){
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return collectionDialog(context,websiteListRepository.model.Webname[index],websiteListRepository.model.Url[index],'常用网站：${websiteListRepository.model.category[index]}');
                                    }
                                );
                              },
                              onTap: (){
                                usercontrooler.addhistory(websiteListRepository.model.Webname[index],websiteListRepository.model.Url[index],'常用网站：${websiteListRepository.model.category[index]}');
                                String url=websiteListRepository.model.Url[index];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewPage(url),
                                  ),
                                );
                              },
                          );
                        },
                      );
                    }
                  }
                  )
              ),
            ],
          ),
        ),
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 40,
        body: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      // Swiped right
                      _tabController.animateTo(_tabController.index - 1);
                    } else if (details.primaryVelocity! < 0) {
                      // Swiped left
                      _tabController.animateTo(_tabController.index + 1);
                    }
                  },
                  child: TabBarView(
                        controller: _tabController,
                        children: [
                          FutureBuilder(
                              future: recommendListRepository.getDate(),
                              builder: (context,snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black54,
                                      backgroundColor: Colors.grey.shade500,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return SmartRefresher(
                                    controller: _refreshController,
                                    onRefresh: _onRefresh,
                                    child: CustomScrollView(
                                      slivers: [
                                        SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                                (context, index) {
                                                  if (index < recommendListRepository.model.titleName.length) {
                                                    return buildColumn(index);
                                                  } else {
                                                    return Container(
                                                      child: Center(child: Text("到最底端了~",
                                                        style: TextStyle(color: Colors.grey),)),
                                                    );
                                                  }
                                                  },
                                            childCount: recommendListRepository.model.titleName.length + 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                              ),
                          FutureBuilder(
                            future: xiangmuListRepository.getDate(newShujuListRepository),
                            builder: (context,snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black54,
                                    backgroundColor: Colors.grey.shade500,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CustomScrollView(
                                  slivers: [
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate((context, index) {
                                          if(index==0)
                                            return  Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:BorderRadius.circular(10)
                                              ),
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      Get.to(newitempage(leibie: '最新项目', model: newShujuListRepository));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text('最新项目!',style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
                                                        Spacer(),
                                                        Text('查看更多'),
                                                        Icon(Icons.navigate_next),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 6,),
                                                  Container(
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,  // 边框颜色
                                                          width: 1.0,          // 边框宽度
                                                        ),
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        buildnewitem(context,0),
                                                        Divider(height: 0,),
                                                        buildnewitem(context,1),
                                                        Divider(height: 0,),
                                                        buildnewitem(context,2),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          if (index==1)
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.all(12),
                                              child: Text('项目类别：',style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
                                            );
                                          else if(index>=2&&index<xiangmuListRepository.model.name.length+1)
                                            return GestureDetector(
                                              onTap: (){
                                                Get.to(itempage(leibie: xiangmuListRepository.model.name[index-2], id: xiangmuListRepository.model.id[index-2]));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: index==2? BorderRadius.only(topRight:  Radius.circular(10.0),topLeft: Radius.circular(10.0)) :BorderRadius.zero
                                                      ),
                                                      margin: EdgeInsets.symmetric(vertical:0.0,horizontal: 12),
                                                      padding: EdgeInsets.all(12),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(xiangmuListRepository.model.name[index-2],style: TextStyle(fontSize: 18,),),
                                                          Spacer(),
                                                          Icon(Icons.navigate_next),
                                                        ],
                                                      )
                                                  ),
                                                  Divider(height: 0,indent:25,endIndent: 25,),
                                                ],
                                              ),
                                            );
                                          else if(index==xiangmuListRepository.model.name.length+1)
                                            return GestureDetector(
                                              onTap: (){
                                                Get.to(itempage(leibie: xiangmuListRepository.model.name[index-2], id: xiangmuListRepository.model.id[index-2]));
                                              },
                                              child: Container(
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(10.0),bottomRight: Radius.circular(10.0))
                                                  ),
                                                  margin: EdgeInsets.symmetric(vertical:0.0,horizontal: 12),
                                                  padding: EdgeInsets.all(12),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(xiangmuListRepository.model.name[index-2],style: TextStyle(fontSize: 18,),),
                                                      Spacer(),
                                                      Icon(Icons.navigate_next),
                                                    ],
                                                  )
                                              ),
                                            );
                                          else
                                            return Container(
                                              margin: EdgeInsets.all(12),
                                              child: Center(child:Text("到最底端了~",style: TextStyle(color: Colors.grey),)),
                                            );
                                        },
                                            childCount:xiangmuListRepository.model.name.length+3
                                        )
                                    )
                                  ],
                                );
                              }},
                          ),

                          FutureBuilder(future: dateofnavigationRepository.getDate(),
                              builder: (context,snapshot){
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return Center(child:
                                  CircularProgressIndicator(
                                    color: Colors.black54,
                                    backgroundColor: Colors.grey.shade500,
                                  ),);
                                }
                                else if(snapshot.hasError){
                                  return Text('Error:${snapshot.error}');
                                }else{
                                  return CustomScrollView(
                                    slivers: <Widget>[
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                            if(index<dateofnavigationRepository.categories.length)
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:BorderRadius.circular(10)
                                              ),
                                              margin: EdgeInsets.all(12),
                                              padding: EdgeInsets.all(6),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      '${dateofnavigationRepository.categories[index].name}:',
                                                      style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  // Here, you can use any appropriate widget to display your data,
                                                  // such as ListView, Column, or Row.
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: dateofnavigationRepository.categories[index].datemodel.length,
                                                    itemBuilder: (context, itemIndex) {
                                                      final item = dateofnavigationRepository.categories[index].datemodel[itemIndex];
                                                      return ListTile(
                                                        title: Text(item.title),
                                                        subtitle: Text(item.title),
                                                        trailing: Icon(Icons.navigate_next),
                                                        onLongPress:(){
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return collectionDialog(context,item.title,item.Url,item.title);
                                                              }
                                                          );
                                                        },
                                                        onTap: (){
                                                          usercontrooler.addhistory(item.title,item.Url,item.title);
                                                          String url=item.Url;
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => WebViewPage(url),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                             else{
                                              return Container(
                                                margin: EdgeInsets.all(12),
                                                child: Center(
                                                  child: Text("到最底端了~", style: TextStyle(color: Colors.grey)),
                                                ),
                                              );
                                            }
                                          },
                                          childCount: dateofnavigationRepository.categories.length+1
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                          ),

                          FutureBuilder(future: tixishujuListRepository.getDate(),
                              builder: (context,snapshot){
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return Center(child:
                                  CircularProgressIndicator(
                                    color: Colors.black54,
                                    backgroundColor: Colors.grey.shade500,
                                  ),);
                                }
                                else if(snapshot.hasError){
                                  return Text('Error:${snapshot.error}');
                                }else{
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:BorderRadius.circular(10)
                                    ),
                                    margin: EdgeInsets.all(12),
                                    child: ListView.separated(
                                      padding: EdgeInsets.all(3),
                                      separatorBuilder:(context, index) => Divider(height: 0,endIndent:25,indent:48,color: Colors.grey.shade300,),
                                      itemCount: tixishujuListRepository.model.categories.length,
                                      itemBuilder: (context, index) {
                                        Color itemColor = Color.fromRGBO(254, 254, 254, 1);
                                        return ListTile(
                                          tileColor: itemColor,
                                          leading: Icon(Icons.sort),
                                          trailing: Icon(Icons.navigate_next),
                                          title: Text(tixishujuListRepository.model.categories[index].name,style: TextStyle(fontSize: 17),),
                                          onTap: (){
                                            Get.to(leibeipage(leibie: tixishujuListRepository.model.categories[index].name, model: tixishujuListRepository.model.categories[index].children));
                                          },
                                        );
                                      },
                                    ),
                                  );
                                }
                              }
                          ),
                        ]
        )
        )
    );
  }

  Color getColorBasedOnNum(int num) {
    switch (num) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.amber;
    // 可以根据需要添加更多的情况
      default:
        return Colors.black;
    }
  }

  GestureDetector buildnewitem(BuildContext context,int num) {
    Color model=getColorBasedOnNum(num);
    return GestureDetector(
      onTap:(){
        usercontrooler.addhistory(newShujuListRepository.model.titlename[num],newShujuListRepository.model.Url[num],newShujuListRepository.model.des[num]);
        String url=newShujuListRepository.model.Url[num];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(url),
          ),
        );
        },
      child: Container(
        height: 60,
        child: Row(
          children: [
            SizedBox(width: 6,),
            Text('No.${num+1}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: model),),
            SizedBox(width: 6,),
            Expanded(
              child: Text('${newShujuListRepository.model.titlename[num]}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 18)),
            ),
            Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }


  Widget buildColumn(int buildindex) {
    return GestureDetector(
      onLongPress:(){
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return collectionDialog(context,recommendListRepository.model.titleName[buildindex],recommendListRepository.model.Url[buildindex],recommendListRepository.model.desc[buildindex]);
        }
        );
      },
      onTap: (){
        usercontrooler.addhistory(recommendListRepository.model.titleName[buildindex],recommendListRepository.model.Url[buildindex],recommendListRepository.model.desc[buildindex]);
        String url=recommendListRepository.model.Url[buildindex];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(url),
          ),
        );
      },
      child: Container(
              margin: EdgeInsets.all(9),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              height: 185,
              width: 380,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recommendListRepository.model.titleName[buildindex],maxLines: 2,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  if(recommendListRepository.model.desc[buildindex]=='')
                    Text("该文无具体描述,详情请点击查看",style: TextStyle(fontSize: 16,color: Colors.grey.shade600),)
                  else
                      Text(recommendListRepository.model.desc[buildindex],softWrap:true,maxLines: 3,overflow:TextOverflow.fade,style: TextStyle(fontSize: 16,color: Colors.grey.shade600),),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      Text(recommendListRepository.model.time[buildindex]),
                      SizedBox(width: 12,),
                      if(recommendListRepository.model.author[buildindex]=='')
                        Row(children: [
                          Text('分享人:',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          Text(recommendListRepository.model.shareuser[buildindex])
                          ],)
                      else
                        Row(children: [
                          Text('作者:',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          Text(recommendListRepository.model.author[buildindex]),
                        ],
                        ),
                      Spacer(),
                      Icon(Icons.chevron_right,size: 30,)
                    ],
                  )
                ],
              ),
      ),
    );
  }
}