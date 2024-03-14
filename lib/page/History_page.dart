import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled3/page/collectionBottomSheet.dart';
import 'package:untitled3/page/web_page.dart';
import '../controller/user.dart';


class History_page extends StatefulWidget {
  const History_page({super.key});

  @override
  State<History_page> createState() => History_pageState();
}

class History_pageState extends State<History_page> {

  final usercontrooler=Get.find<userController>();


  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('浏览记录'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return
                      AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text('确定要清空历史记录吗',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        content: Text('被清除的数据将无法被找回'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                                },
                              child: Text('取消')
                          ),
                          TextButton(
                            onPressed: () {
                              usercontrooler.clearhistory();
                              Navigator.of(context).pop();
                              },
                            child: Text('确定'),
                          ),
                        ],
                      );
                  }
                  );
              },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 6),
            sliver: SliverList.separated(
              itemCount: usercontrooler.browsing_history.length + 1,
              itemBuilder: (context,index){
                if (index < usercontrooler.browsing_history.length ){
                  return InkWell(
                    onTap: (){
                      String url=usercontrooler.browsing_history[usercontrooler.browsing_history.length-index-1].url;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(url),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                      child:
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(usercontrooler.browsing_history[usercontrooler.browsing_history.length-index-1].collectionName,maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            SizedBox(height: 12,),
                            if(usercontrooler.browsing_history[usercontrooler.browsing_history.length-index-1].des!='')
                              Text(usercontrooler.browsing_history[usercontrooler.browsing_history.length-index-1].des,maxLines:2,overflow:TextOverflow.ellipsis)
                            else
                              Text('暂无具体描述'),
                          ]
                      ),

                    ),
                  );
                }
                else
                {
                  return Container(
                    child:  Column(
                      children: [
                        SizedBox(height: 11,),
                        Text("被记录的过去",
                          style: TextStyle(color: Colors.grey.shade700),),
                      ],
                    )
                  );
                }
              },
              separatorBuilder: (context, index) => Divider(height: 0,),
            ),
          )
        ],
      ),
    ));
  }
}
