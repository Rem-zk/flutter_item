import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled3/page/web_page.dart';
import '../api？/newxiangmu.dart';
import '../controller/user.dart';
import 'collectionBottomSheet.dart';

class newitempage extends StatefulWidget {
  final String leibie;
  final NewShujuListRepository model;
  const newitempage({super.key,required this.leibie,required this.model});

  @override
  State<newitempage> createState() => _newitempageState();
}

class _newitempageState extends State<newitempage> {
  final usercontrooler=Get.find<userController>();
  late NewShujuListRepository newShujuListRepository;
  void initState() {
    super.initState();
    newShujuListRepository = widget.model;
  }
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
      body: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (index < newShujuListRepository.model.titlename.length) {
                          return  Column(
                            children: [
                              GestureDetector(
                                onLongPress:(){
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return collectionDialog(context,newShujuListRepository.model.titlename[index],newShujuListRepository.model.Url[index],newShujuListRepository.model.des[index]);
                                      }
                                  );
                                },
                                onTap: (){
                                  usercontrooler.addhistory(newShujuListRepository.model.titlename[index],newShujuListRepository.model.Url[index],newShujuListRepository.model.des[index]);
                                  String url=newShujuListRepository.model.Url[index];
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
                                      child: Image.network(newShujuListRepository.model.pictureUrl[index],fit: BoxFit.cover,)

                                  ),
                                  title: Text(newShujuListRepository.model.titlename[index],maxLines: 2,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(newShujuListRepository.model.des[index],maxLines: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time),
                                          Text(newShujuListRepository.model.time[index]),
                                          Spacer(),
                                          Text('@${newShujuListRepository.model.author[index]}',overflow:TextOverflow.ellipsis,),
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
                      childCount: newShujuListRepository.model.titlename.length+1,
                    ),
                  ),
                ],
              ),
    );
  }
}
