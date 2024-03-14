
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("详情内容",style: TextStyle(fontSize: 20),),
        toolbarHeight: 60,
      ),
      body:WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url))
          ..setNavigationDelegate(
              NavigationDelegate(
              onNavigationRequest: (NavigationRequest request){
                if (request.url.startsWith('https://www.taobao.com/')||url.startsWith('https://www.tmall.com/')||url.startsWith('https://www.jd.com/')||url.startsWith('https://www.pinduoduo.com/')) {
                  return NavigationDecision.prevent;  // 阻止导航
                } else {
                  return NavigationDecision.navigate;  // 允许导航
                }
              }
            )
        )
      )
    );
  }
}