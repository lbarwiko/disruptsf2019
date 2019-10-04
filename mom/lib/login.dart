import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  static const String BASE_URL = "https://bcb0d5ab.ngrok.io";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(child: Builder(
        builder: (context) {
          return WebView(
            initialUrl: "$BASE_URL/auth",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              controller.complete(webViewController);
            },
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) {
                    print('token ${message.message}');
                    getAccessToken(token: message.message);
                  })
            ]),
          );
        },
      )),
    );
  }

  void getAccessToken({String token}) async {
    var response = await http
        .post('$BASE_URL/get_access_token', body: {'public_token': token});
    print('res ${response.body}');
    storeToken(response.body);
    Navigator.pop(context);
  }

  Future storeToken(String body) async {
    Map<String, dynamic> response = json.decode(body);
    String token = response['access_token'];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('access_token', token);
  }
}
