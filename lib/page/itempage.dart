import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled3/api%EF%BC%9F/xiangmushuju.dart';
import 'package:untitled3/page/web_page.dart';
import '../controller/user.dart';
import 'collectionBottomSheet.dart';

class itempage extends StatefulWidget {
  final String leibie;
  final int id;
  const itempage({super.key,required this.leibie,required this.id});

  @override
  State<itempage> createState() => _itempageState();
}

class _itempageState extends State<itempage> {
  final usercontrooler=Get.find<userController>();
  ShujuListRepository shujuListRepository=ShujuListRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 75,
        centerTitle: true,
        title: Text(
          widget.leibie
        ),
        elevation: 1,
        shadowColor: Colors.black,
      ),
      body: FutureBuilder(
        future: shujuListRepository.getDate(widget.id),
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
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index < shujuListRepository.model.titlename.length) {
                        return  Column(
                          children: [
                            GestureDetector(
                              onLongPress:(){
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return collectionDialog(context,shujuListRepository.model.titlename[index],shujuListRepository.model.Url[index],shujuListRepository.model.des[index]);
                                    }
                                );
                              },
                              onTap: (){
                                usercontrooler.addhistory(shujuListRepository.model.titlename[index],shujuListRepository.model.Url[index],shujuListRepository.model.des[index]);
                                String url=shujuListRepository.model.Url[index];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewPage(url),
                                  ),
                                );
                              },
                              child: ListTile(
                                tileColor: Colors.white,
                                leading: Container(
                                  height: 300,
                                    width: 48,
                                    child: Image.network(shujuListRepository.model.pictureUrl[index],fit: BoxFit.cover,)

                                ),
                                title: Text(shujuListRepository.model.titlename[index],maxLines: 2,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(shujuListRepository.model.des[index],maxLines: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time),
                                        Text(shujuListRepository.model.time[index]),
                                        Spacer(),
                                        Text('@${shujuListRepository.model.author[index]}',overflow:TextOverflow.ellipsis,),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Container(width: 20,child: Icon(Icons.navigate_next)),
                              ),
                            ),
                            Divider(height: 0),
                          ],
                        );
                      } else {
                        return Container(
                          child: Center(child:Text("最底端~~",style: TextStyle(color: Colors.grey),)),
                        );
                      }
                    },
                    childCount: shujuListRepository.model.titlename.length+1,
                  ),
                ),
              ],
            );
          }
        }
      ),
    );
  }
}
