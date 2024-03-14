import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Article{
  var collectionName ='';
  var url='';
  var des='';
}

class userController extends GetxController {
  var browsing_history=<Article>[].obs;
  var collections=<Article>[].obs;
  //final collection_num=0.obs;
  final sex = '未知'.obs;
  String userAvatarPath = "";
  SharedPreferences? prefs;
  final name = "默认".obs;
  final signature = "除了吃饭就是睡觉".obs;

  void addhistory(String name,String url,String des){
    var newHistory = Article();
    newHistory.collectionName=name;
    newHistory.url=url;
    newHistory.des=des;
    // 检查是否已存在相同的记录
    var existingIndex = browsing_history.indexWhere((history) =>
    history.collectionName == newHistory.collectionName &&
        history.url == newHistory.url &&
        history.des == newHistory.des);
    if (existingIndex != -1) {
      // 如果存在相同的记录，则删除旧记录
      browsing_history.removeAt(existingIndex);
    }
    browsing_history.add(newHistory);
    saveHistory();
  }
  void clearhistory(){
    browsing_history.clear();
  }

  void addcollection(String name,String url,String des){
    var newCollection = Article();
    newCollection.collectionName=name;
    newCollection.url=url;
    newCollection.des=des;
    if (!collections.any((collection) =>
    collection.collectionName == newCollection.collectionName &&
        collection.url == newCollection.url &&
        collection.des == newCollection.des)) {
      collections.add(newCollection);
      saveCollection();
      Get.snackbar("Favorite successfully", '', duration: Duration(seconds: 2));
    } else {
      // 如果已存在相同的内容，可以选择执行一些操作或者提醒用户
      Get.snackbar("该内容已收藏过", '', duration: Duration(seconds: 2));
    }
    //collection_num.value=collection_num.value+1;
    //saveCollection_num();
  }

  void deletecollection(int index){
    collections.removeAt(index);
    saveCollection();
  }

 // Future<void> saveCollection_num() async{
  //  prefs!.setInt('collection_num', collection_num.value);
  //}

  void chushihua() {
    name.value = '默认';
    signature.value = '除了吃饭就是睡觉';
    sex.value='未知';
  }

  void setname (String value){
    name.value=value;
    saveUserCredentials(name.value, signature.value);
  }
  void setsignature (String value){
    signature.value=value;
    saveUserCredentials(name.value, signature.value);
  }

  @override
  void onClose() {
    saveSexOfUser();
    saveUserCredentials(name.value, signature.value);
    saveUserAvaterPath(userAvatarPath);
    super.onClose();
  }

  Future<void> onInit() async {
    // 初始化SharedPreferences
    prefs = await SharedPreferences.getInstance();

    // 从SharedPreferences加载用户信息
    name.value = prefs!.getString('name') ?? '';
    signature.value = prefs!.getString('signature') ?? '';
    userAvatarPath = prefs!.getString('useravaterpath') ?? '';
    sex.value = prefs!.getString('sex') ?? '';

    String? collectionsJson = prefs!.getString('collections');
    if (collectionsJson != null && collectionsJson.isNotEmpty) {
      List<dynamic> collectionsList = jsonDecode(collectionsJson);
      collections.value = collectionsList
          .map((item) => Article()
        ..collectionName = item['collectionName']
        ..url = item['url']
        ..des = item['des'])
          .toList();
    }

    String? historyJson = prefs!.getString('history');
    if(historyJson !=null && historyJson.isNotEmpty){
      List<dynamic> historyList=jsonDecode(historyJson);
      browsing_history.value = historyList
          .map((item) => Article()
        ..collectionName=item['historyName']
        ..url = item['url']
        ..des= item['des'])
      .toList();
    }

    super.onInit();
    if (name.value == '' && signature.value == '') chushihua();
  }

  Future<void> saveHistory() async{
    List<Map<String, String>> historyData = browsing_history
        .map((acticle) => {
      'historyName': acticle.collectionName,
      'url': acticle.url,
      'des': acticle.des,
    })
        .toList();
    String historyJson =jsonEncode(historyData);
    prefs!.setString('history', historyJson);
  }

  Future<void> saveCollection() async{
    // 将collections转换为List<Map<String, String>>
    List<Map<String, String>> collectionsData = collections
        .map((acticle) => {
      'collectionName': acticle.collectionName,
      'url': acticle.url,
      'des': acticle.des,
    })
        .toList();

    // 将List<Map<String, String>>转换为JSON字符串
    String collectionsJson = jsonEncode(collectionsData);

    // 保存JSON字符串到SharedPreferences
    prefs!.setString('collections', collectionsJson);
  }


  Future<void> saveSexOfUser() async {
    prefs!.setString('sex', sex.value);
  }

  Future<void> saveUserCredentials(String name, String signature) async {
    // 将用户信息保存到SharedPreferences
    prefs!.setString('name', name);
    prefs!.setString('signature', signature);
  }

  Future<void> saveUserAvaterPath(String pickerFile) async {
    prefs!.setString('useravaterpath', pickerFile);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String avatarPath = '${appDocDir.path}/avatar.png';
        // 删除旧的图片文件
        if (File(avatarPath).existsSync()) {
          File(avatarPath).deleteSync();
        }
        // 使用 copy 方法，而不是 copySync，以避免阻塞 UI 线程
        await File(pickedFile.path).copy(avatarPath);

        userAvatarPath = avatarPath;
        saveUserAvaterPath(avatarPath);

        Get.snackbar("Successfully Change", '', duration: Duration(seconds: 3));
      }
    } catch (e) {
      // 处理异常，例如文件拷贝失败
      print('Error picking image: $e');
      Get.snackbar("Error", "Failed to pick image", duration: Duration(seconds: 3));
    }
  }
}