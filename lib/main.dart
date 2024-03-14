import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled3/controller/user.dart';
import 'package:untitled3/page/Homepage.dart';
import 'package:untitled3/page/Mypage.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('${(await getApplicationDocumentsDirectory()).path}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final usercontroller =Get.put(userController());

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: page()//login_page(),
    );
  }
}

class page extends StatefulWidget {
  const page({super.key});
  @override
  State<page> createState() => _pageState();
}

class _pageState extends State<page> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Homepage(),
    Mypage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor:Colors.black,
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            items:const[
              BottomNavigationBarItem(
                  icon:Icon(Icons.home_outlined),
                  label: "首页"
              ),
              BottomNavigationBarItem(
                  icon:Icon(Icons.person_2_outlined),
                  label: "我的"
              )
            ]
        ),
    );
  }
  }









