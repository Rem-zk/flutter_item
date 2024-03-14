import 'dart:convert';
import 'package:dio/dio.dart';

class TixiCategoryModel {
  String name;
  List<TixiSubCategoryModel> children;

  TixiCategoryModel({
    required this.name,
    required this.children,
  });
}

class TixiSubCategoryModel {
  int id;
  String name;
  String link;

  TixiSubCategoryModel({
    required this.id,
    required this.name,
    required this.link,
  });
}


class TixishujuListModel {
  List<TixiCategoryModel> categories = [];
}

class TixishujuListRepository {
  TixishujuListModel model = TixishujuListModel();

  Future<void> getDate() async {
    try {
      Response res = await Dio().get("https://www.wanandroid.com/tree/json");
      Map<String, dynamic> map = jsonDecode(res.toString());
      model.categories.clear();

      for (var categoryData in map['data']) {
        if (categoryData['name'] == '一起学') {
          break;
        }
        List<TixiSubCategoryModel> subCategories = [];
        for (var subCategoryData in categoryData['children']) {
          subCategories.add(
              TixiSubCategoryModel(
                id: subCategoryData['id'],
                name: subCategoryData['name'],
                link: 'https://www.wanandroid.com/article/list/0/json?cid=${subCategoryData['id']}',
          ));
        }
        model.categories.add(TixiCategoryModel(
          name: categoryData['name'],
          children: subCategories,
        ));
      }
    } catch (e) {
      // 打印错误信息
      print(e);
    }
  }
}