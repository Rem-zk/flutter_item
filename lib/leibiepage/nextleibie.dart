import 'package:flutter/material.dart';
import 'package:untitled3/api%EF%BC%9F/actuallyinformation.dart';
import '../api？/firstpage.dart';
import '../page/collectionBottomSheet.dart';
import '../page/web_page.dart';

class Nextliebiao extends StatefulWidget {
  final String leibie;
  final int id;
  const Nextliebiao({Key? key,required this.leibie,required this.id}): super(key: key);

  @override
  State<Nextliebiao> createState() => _NextliebiaoState();
}

class _NextliebiaoState extends State<Nextliebiao> {
  TixisubsubListRepository tixisubsubListRepository=TixisubsubListRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 60,
          centerTitle: true,
          title: Text(widget.leibie),
        ),
        body:FutureBuilder(
          future: tixisubsubListRepository.getDate(widget.id),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black54,
                backgroundColor: Colors.grey.shade500,
              )
            );
            }else if(snapshot.hasError){
              return Text("Error:${snapshot.error}");
            }else{
              return CustomScrollView(
                //shrinkWrap: true,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (index < tixisubsubListRepository.model.titleName.length) {
                          return buildColumn(index);
                        } else {
                          return Container(
                            child: Center(child:Text("最底端~~",style: TextStyle(color: Colors.grey),)),
                          );
                        }
                      },
                      childCount: tixisubsubListRepository.model.titleName.length+1,
                    ),
                  ),
                ],
              );
            }
          },
        )
    );
  }
  Widget buildColumn(int buildindex) {
    return GestureDetector(
      onLongPress:(){
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return collectionDialog(context,tixisubsubListRepository.model.titleName[buildindex],tixisubsubListRepository.model.Url[buildindex],widget.leibie);
            }
        );
      },
      onTap: (){
        String url=tixisubsubListRepository.model.Url[buildindex];
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
        height: 190,
        width: 380,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tixisubsubListRepository.model.titleName[buildindex],maxLines: 2,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text(widget.leibie,softWrap:true,maxLines: 3,overflow:TextOverflow.fade,style: TextStyle(fontSize: 16,color: Colors.grey.shade600),),
            Row(
              children: [
                Icon(Icons.access_time),
                Text(tixisubsubListRepository.model.time[buildindex]),
                SizedBox(width: 12,),
                if(tixisubsubListRepository.model.author[buildindex]=='')
                  Row(children: [
                    Text('分享人:',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                    Text(tixisubsubListRepository.model.shareuser[buildindex])
                  ],)
                else if(tixisubsubListRepository.model.author[buildindex].length <=20 )
                  Row(children: [
                    Text('作者:',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                    Text(tixisubsubListRepository.model.author[buildindex],overflow:TextOverflow.ellipsis,),
                  ],
                  )
                else
                  Row(
                    children: [
                      Text('作者:',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                      Text('未知',overflow:TextOverflow.ellipsis,),
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
