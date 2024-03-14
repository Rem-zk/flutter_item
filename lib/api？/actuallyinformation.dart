import 'dart:convert';
import 'package:dio/dio.dart';

class TixisubsubListModel{
  List<String> titleName=[]; //文章的主题名称
  List<String> Url=[]; //文章内容的URL地址
  List<String> time=[]; //文章的发布时间
  List<String> author=[];//文章作者
  List<String> shareuser=[];
}

class TixisubsubListRepository{
  TixisubsubListModel model=TixisubsubListModel();
  Future<void> getDate(int id) async{
    try{
      model.titleName.clear();
      model.Url.clear();
      model.time.clear();
      model.author.clear();
      model.shareuser.clear();
      for(int page=0;page<=3;page++) {
        Response res = await Dio().get(
            "https://www.wanandroid.com/article/list/${page}/json?cid=${id}");
        Map<String, dynamic> map = jsonDecode(res.toString());
        for (var item in map['data']['datas']) {
          model.titleName.add(item['title']);
          model.Url.add(item['link']);
          model.time.add(item['niceDate']);
          model.author.add(item['author']);
          model.shareuser.add(item['shareUser']);
        }
      }
    }catch (e) {
      // 打印错误信息
      print(e);
    }
  }
}