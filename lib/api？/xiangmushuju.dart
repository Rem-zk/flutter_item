import 'dart:convert';
import 'package:dio/dio.dart';

class ShujuListmodel{
  List<String> author=[];
  List<String> pictureUrl=[];
  List<String> Url=[];
  List<String> des=[];
  List<String> titlename=[];
  List<String> time=[];
}
class ShujuListRepository{
  ShujuListmodel model=ShujuListmodel();
  Future<void> getDate(int id) async{
    try{
      model.titlename.clear();
      model.author.clear();
      model.Url.clear();
      model.des.clear();
      model.pictureUrl.clear();
      model.time.clear();
      for(int page=0;page<=3;page++) {
        Response res = await Dio().get('https://www.wanandroid.com/project/list/${page}/json?cid=${id}');
        Map<String, dynamic> map = jsonDecode(res.toString());
        for (var item in map['data']['datas']) {
          model.des.add(item['desc']);
          model.Url.add(item['link']);
          model.titlename.add(item['title']);
          model.author.add(item['author']);
          model.pictureUrl.add(item['envelopePic']);
          model.time.add(item['niceDate']);
        }
      }
    }catch (e) {
      // 打印错误信息
      print(e);
    }
  }
}