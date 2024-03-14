import 'dart:convert';
import 'package:dio/dio.dart';

class WebsiteListModel{
  List<String> Webname=[];
  List<String> category=[];
  List<String> Url=[];
}

class WebsiteListRepository{
  WebsiteListModel model=WebsiteListModel();
  Future<void> getDate() async{
    try{
      model.Webname.clear();
      model.Url.clear();
      model.category.clear();
      Response res = await Dio().get("https://www.wanandroid.com/friend/json");
      Map<String, dynamic> map = jsonDecode(res.toString());
      for(var item in map['data']){
        model.Webname.add(item['name']);
        model.category.add(item['category']);
        model.Url.add(item['link']);
      }
    }catch (e) {
      // 打印错误信息
      print(e);
  }
}
}