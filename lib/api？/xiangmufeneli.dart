import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:untitled3/api%EF%BC%9F/newxiangmu.dart';

class XiangmuListmodel{
  List<String> name=[];
  List<int> id=[];
}

class XiangmuListRepository {
  XiangmuListmodel model = XiangmuListmodel();

  Future<void> getDate(NewShujuListRepository model1) async {
    await model1.getDate();
    try {
      model.name.clear();
      model.id.clear();
      Response res = await Dio().get("https://www.wanandroid.com/project/tree/json");
      Map<String, dynamic> map = jsonDecode(res.toString());
      for(var item in map['data']){
        model.name.add(item['name']);
        model.id.add(item['id']);
      }
    } catch (e) {
      // 打印错误信息
      print(e);
    }
  }
}