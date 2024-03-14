import 'dart:convert';
import 'package:dio/dio.dart';

class Dateofnavigationmodel {
  String name;
  List<Datemodel> datemodel;
  Dateofnavigationmodel({required this.name,required this.datemodel});
}
class Datemodel{
  String title;
  String Url;
  String desc;
  Datemodel({required this.Url,required this.title,required this.desc});
}


class DateofnavigationRepository{
  List<Dateofnavigationmodel> categories = [];
  Future<void> getDate() async{
    try{

      categories.clear();
      Response res = await Dio().get("https://www.wanandroid.com/navi/json");
      Map<String, dynamic> map = jsonDecode(res.toString());
      for(var item in map['data']){
        if (item['name'] == '在线学习'||item['name'] == '求职招聘'||item['name'] == '三方分享') {
          continue;
        }
        List<Datemodel> datemodel=[];
        for(var subitem in item['articles']){
          datemodel.add(Datemodel(Url: subitem['link'], title: subitem['title'],desc: subitem['chapterName']));
        }
        categories.add(Dateofnavigationmodel(name: item['name'], datemodel: datemodel));

      }
      } catch (e) {
      // 打印错误信息
      print(e);
    }
  }
}