import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled3/api%EF%BC%9F/tixishuju.dart';
import 'package:untitled3/leibiepage/nextleibie.dart';

class leibeipage extends StatelessWidget {
  final String leibie;
  final List<TixiSubCategoryModel> model;
  const leibeipage({Key?key,required this.leibie,required this.model}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      appBar:AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        title: Text(leibie,),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.separated(
        separatorBuilder:(context, index) =>SizedBox(height: 8,),
        itemCount: model.length,
        itemBuilder: (context, index) {
          Color itemColor=Colors.white;
          return ListTile(
            tileColor: itemColor,
            leading: Icon(Icons.near_me),
            trailing: Icon(Icons.navigate_next),
            title: Text(model[index].name,style: TextStyle(fontSize: 17),),
            onTap: (){
              Get.to(Nextliebiao(leibie: model[index].name, id: model[index].id));
            },
          );
        },
      ),
    );
  }
}


