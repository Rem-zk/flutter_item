import 'dart:convert';
import 'package:dio/dio.dart';

class RecommendListModel{
  List<String> titleName=[]; //文章的主题名称
  List<String> Url=[]; //文章内容的URL地址
  List<String> time=[]; //文章的发布时间
  List<String> author=[];//文章作者
  List<String> desc=[];//描述
  List<String> shareuser=[];
}

class RecommendListRepository{
  RecommendListModel model=RecommendListModel();
  Future<void> getDate() async{
    try{
      model.titleName.clear();
      model.Url.clear();
      model.time.clear();
      model.author.clear();
      model.desc.clear();
      model.shareuser.clear();
      for(int page=0;page<=3;page++){
        Response res = await Dio().get("https://www.wanandroid.com/article/list/$page/json");
        Map<String, dynamic> map = jsonDecode(res.toString());
        for(var item in map['data']['datas']){
          model.titleName.add(item['title']);
          model.Url.add(item['link']);
          model.time.add(item['niceDate']);
          model.author.add(item['author']);
          model.desc.add(item['desc']);
          model.shareuser.add(item['shareUser']);
        }
      }
    } catch (e) {
      // 打印错误信息
      print(e);
    }
  }
}