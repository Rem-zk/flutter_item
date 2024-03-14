import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled3/usersetting.dart';
import '../controller/user.dart';

class userin extends StatefulWidget {
  const userin({super.key});

  @override
  State<userin> createState() => _userinState();
}

class _userinState extends State<userin> {


  @override
  Widget build(BuildContext context) {

    final usercontrooler=Get.find<userController>();

    final usersetting=[
      {"title":"昵称","tailing":Obx(() => Text(usercontrooler.name.value)),"ontap":(){showDialog(context: context, builder: (BuildContext context){return changebuild(context,'修改昵称');});}},
      {"title":"性别","tailing":Obx(() => Text(usercontrooler.sex.value)),"ontap":(){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Text("设置性别",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    SizedBox(height: 8,),
                    ListTile(
                      title: Align(
                        alignment: Alignment.center,
                        child: Text("男"),
                      ),
                      onTap: (){
                        usercontrooler.sex.value="\u2642";
                        usercontrooler.saveSexOfUser();
                        Navigator.pop(context);
                      },
                    ),
                    Divider(height: 0,color: Colors.grey.shade300,),
                    ListTile(
                      title: Align(
                        alignment: Alignment.center,
                        child: Text("女"),
                      ),
                      onTap: (){
                        usercontrooler.sex.value="\u2640";
                        usercontrooler.saveSexOfUser();
                        Navigator.pop(context);
                      },
                    ),
                    Divider(height: 0,color: Colors.grey.shade300,),
                    ListTile(
                      title: Align(
                        alignment: Alignment.center,
                        child: Text("秘密"),
                      ),
                      onTap: (){
                        usercontrooler.sex.value="这是个秘密";
                        usercontrooler.saveSexOfUser();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      }},
      {"title":"个性签名","tailing":Obx(() => Text(usercontrooler.signature.value)),"ontap":(){showDialog(context: context, builder: (BuildContext context){return changebuild(context,'修改个性签名');});}},
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      appBar: AppBar(
        title: Text('编辑资料'),
        backgroundColor : Colors.white,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16),
            sliver: SliverList.separated(
              itemCount: usersetting.length +1, // 增加一项
              itemBuilder: (context, index) {
                if (index < usersetting.length) {
                  // 构建列表项
                  return user_setting(
                    title: usersetting[index]["title"] as String,
                    tailing: usersetting[index]["tailing"] as Widget,
                    onTap: usersetting[index]["ontap"] as Function(),
                  );
                } else {
                  // 在列表底部添加一句话的项
                  return Container(
                    child: Center(child: Text("让世界遇到你",
                      style: TextStyle(color: Colors.grey.shade700),)),
                  );
                }
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 12,
              ),
            ),
          ),
        ],
      )
    );
  }
}



Widget changebuild(BuildContext context,String title){
  final formKey=GlobalKey<FormState>();
  final usercontrooler=Get.find<userController>();
  String neirong="";
  return Dialog(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      height: 230,
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: 12,),
          Form(
            key: formKey,
              child: TextFormField(
                initialValue: title!='修改昵称'? usercontrooler.signature.value:usercontrooler.name.value,
                onChanged: (value){neirong=value;},
                validator: (value){
                  if((value!=null&&value.isEmpty )|| value==null){
                    return '内容不能为空';
                  }
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: "请输入",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              )
          ),
          Row(
            children: [
              Spacer(),
              TextButton(
                  onPressed: (){
                if(!formKey.currentState!.validate()){
                return;}
                Navigator.of(context).pop();}, child: Text('取消')),
              TextButton(onPressed: (){
                if(!formKey.currentState!.validate()){
                  return;
                };
                title!="修改昵称"?usercontrooler.setsignature(neirong):usercontrooler.setname(neirong);
                usercontrooler.saveUserCredentials(usercontrooler.name.value, usercontrooler.signature.value);
                Navigator.of(context).pop();
              }, child: Text('确认')),
            ],
          )
        ],
      ),
    ),
  );
}
