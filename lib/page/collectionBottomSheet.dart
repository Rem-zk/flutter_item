import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/user.dart';

Widget collectionDialog(BuildContext context,String name,String url,String des) {

  final usercontrooler=Get.find<userController>();

    return Container(
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ListTile(
            title:  Align(
                alignment: Alignment.center,
                child: Text('收藏',style: TextStyle(fontSize: 17),)
            ),
            onTap: (){
              usercontrooler.addcollection(name,url,des);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title:  Align(
                alignment: Alignment.center,
                child: Text('取消',style: TextStyle(fontSize: 17),)
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
}


Widget deleteDialog(BuildContext context,int index) {

  final usercontrooler=Get.find<userController>();

  return Container(
    height: 120,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ListTile(
          title:  Align(
              alignment: Alignment.center,
              child: Text('取消收藏',style: TextStyle(fontSize: 17),)
          ),
          onTap: (){
            usercontrooler.deletecollection(index);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title:  Align(
              alignment: Alignment.center,
              child: Text('取消',style: TextStyle(fontSize: 17),)
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}