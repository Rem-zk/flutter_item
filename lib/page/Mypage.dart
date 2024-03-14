import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled3/controller/user.dart';
import 'package:untitled3/page/History_page.dart';
import 'package:untitled3/page/User_Agreement.dart';
import 'package:untitled3/page/usersinformation.dart';
import 'package:untitled3/page/web_page.dart';
import '../navigation.dart';
import 'Collection_page.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {

  final usercontrooler=Get.find<userController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: (){},
                icon: Icon(Icons.qr_code_scanner,color: Colors.black,)
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child:Column(
          children:[
            _bulidInfo(),
            SizedBox(height: 12,),
            NavigationItem(title: "收藏", icon: Icons.star_border,onTap: (){
              Get.to(Collection_page());
            },),
            Divider(height: 0,endIndent:25,indent:48,color: Colors.grey.shade300,),
            NavigationItem(title:"浏览记录", icon: Icons.remove_red_eye_outlined,onTap: (){
              Get.to(History_page());
            },),
            SizedBox(height: 12,),
            NavigationItem(title:"隐私协议",
              icon: Icons.privacy_tip_outlined,
              onTap: (){
                Get.to(useragreement());
              },),
            Divider(height: 0,endIndent:25,indent:48,color: Colors.grey.shade300,),
            NavigationItem(
              title:"用户协议",
              icon: Icons.article_outlined,
              onTap: (){
                Get.to(useragreement());
              },),
            SizedBox(height: 12,),
            NavigationItem(title:"代码页", icon: Icons.web, onTap: (){
              String url='https://github.com/Rem-zk/flutter_item';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewPage(url),
                ),
              );
            },),
            SizedBox(height: 12,),
            NavigationItem(
              title:"问题反馈",
              icon: Icons.send,
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return  AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text('问题反馈',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      content: Text('反馈地址:2310275391@qq.com'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                          // 在对话框中的按钮按下时，关闭对话框
                          Navigator.of(context).pop();
                        },
                          child: Text('返回'),
                        ),
                      ],
                    );
                  }
                );
              },
            ),
          ],
        ),
      ),
    ),
    );
  }



  Container _bulidInfo() {
    return Container(
      height: 100,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 12),
      child:Row(
        children: [
          GestureDetector(
            onTap: (){
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ListTile(
                          title:  Align(
                              alignment: Alignment.center,
                              child: Text('查看头像',style: TextStyle(fontSize: 17),)
                          ),
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.of(context).push(_buildImagePageRoute(usercontrooler.userAvatarPath));
                          },
                        ),
                        ListTile(
                          title: Align(
                              alignment: Alignment.center,
                              child: Text('从相册选择',style: TextStyle(fontSize: 17),)
                          ),
                          onTap: ()  async{
                            await usercontrooler.pickImage();
                            setState(() {});
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
                },
              );
            },
            child: Hero(
              tag: "avatarHero",
              child: CircleAvatar(
                key: UniqueKey(),
                radius: 40,
                backgroundImage: usercontrooler.userAvatarPath.isNotEmpty
                    ? Image.file(File(usercontrooler.userAvatarPath)).image
                    : Image.asset("assets/image.png").image,
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Get.to(userin());
            },
            child: Container(
              width: 306,
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(usercontrooler.name.value,style:TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                      SizedBox(height: 7,),
                      Text(usercontrooler.signature.value,style: TextStyle(color:Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

PageRouteBuilder _buildImagePageRoute(String userAvatarPath) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Material(
          color: Colors.black.withOpacity(0.4), // 控制背景半透明度
          child: Center(
            child: Hero(
              tag: "avatarHero",
              child: getImageWidget(userAvatarPath),
            ),
          ),
        ),
      );
    },
  );
}

Widget getImageWidget(String userAvatarPath) {
  if (userAvatarPath.isNotEmpty) {
    return Image.file(
      File(userAvatarPath),
      fit: BoxFit.contain,
    );
  } else {
    return Image.asset(
      "assets/image.png",
      fit: BoxFit.contain,
    );
  }
}