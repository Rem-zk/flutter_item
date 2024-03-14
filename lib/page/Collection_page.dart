import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled3/page/collectionBottomSheet.dart';
import 'package:untitled3/page/web_page.dart';
import '../controller/user.dart';


class Collection_page extends StatefulWidget {
  const Collection_page({super.key});

  @override
  State<Collection_page> createState() => _Collection_pageState();
}

class _Collection_pageState extends State<Collection_page> {

  final usercontrooler=Get.find<userController>();


  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('我的收藏'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16),
            sliver: SliverList.separated(
              itemCount: usercontrooler.collections.length + 1,
              itemBuilder: (context,index){
                if (index < usercontrooler.collections.length ){
                return InkWell(
                  onLongPress:(){
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return deleteDialog(context,usercontrooler.collections.length-index-1);
                        }
                    );
                  },
                  onTap: (){
                    String url=usercontrooler.collections[usercontrooler.collections.length-index-1].url;
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
                            Text(usercontrooler.collections[usercontrooler.collections.length-index-1].collectionName,maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            SizedBox(height: 12,),
                            if(usercontrooler.collections[usercontrooler.collections.length-index-1].des!='')
                              Text(usercontrooler.collections[usercontrooler.collections.length-index-1].des,maxLines:2,overflow:TextOverflow.ellipsis)
                            else
                              Text('暂无具体描述')
                          ]
                        ),

                  ),
                );
                }
                else
                {
                  return Container(
                    child: Center(child: Text("长按相关组件进行收藏与取消操作~",
                      style: TextStyle(color: Colors.grey.shade700),)),
                  );
                }
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 12,
              ),
            ),
          )
        ],
      ),
    ));
  }
}
