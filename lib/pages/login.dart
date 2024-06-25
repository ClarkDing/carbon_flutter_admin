/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description: 登录

import 'package:cry/common/application_context.dart';
import 'package:cry/common/face_recognition.dart';
import 'package:cry/common/face_service_import.dart';
import 'package:flutter/material.dart';
import 'package:cry/cry.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:cry/model/response_body_api.dart';
import 'package:flutter_admin/pages/common/lang_switch.dart';
import 'package:flutter_admin/utils/store_util_test.dart';
import 'package:flutter_admin/api/user_api.dart';
import 'package:flutter_admin/models/user.dart';
import '../generated/l10n.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  User user = new User();
  String error = "";
  FocusNode focusNodeUserName = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  bool isFaceRecognition = false;

  @override
  void initState() {
    super.initState();
    focusNodeUserName.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: _buildPageContent(),
      ),
    );
  }

  // 面部识别登录
  Widget _buildPageContent() {
    var appName = Text(
      S.of(context).sysName,
      style: TextStyle(fontSize: 16, color: Colors.blue),
      textScaleFactor: 3.2,
    );
    return isFaceRecognition
        ? FaceRecognition(
            onFountFace: (CameraImage cameraImage, String imagePath, List<Face> faces) async {
              String faceData = FaceService().toData(cameraImage, faces[0]);
              var responseBodyApi = await UserApi.loginByFace(faceData);
              if (!responseBodyApi.success!) {
                setState(() {
                  this.isFaceRecognition = false;
                });
                return;
              }
              _loginSuccess(responseBodyApi);
            },
            onBack: () {
              setState(() {
                this.isFaceRecognition = false;
              });
            },
          )
        : Container(
            color: Colors.cyan.shade100,
            child: ListView(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [LangSwitch()],
                ),
                Center(child: appName),
                SizedBox(height: 20.0),
                _buildLoginForm(),
                SizedBox(height: 20.0),
                Column(
                  children: [
                    Text(S.of(context).admin + '：admin/admin'),
                    Text(S.of(context).loginTip),
                  ],
                )
              ],
            ),
          );
  }

  Container _buildLoginForm() {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: 500,
              height: 360,
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        focusNode: focusNodeUserName,
                        initialValue: user.userName,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: S.of(context).username,
                          icon: Icon(
                            Icons.people,
                            color: Colors.blue,
                          ),
                        ),
                        onSaved: (v) {
                          user.userName = v;
                        },
                        validator: (v) {
                          return v!.isEmpty ? S.of(context).usernameRequired : null;
                        },
                        onFieldSubmitted: (v) {
                          focusNodePassword.requestFocus();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        focusNode: focusNodePassword,
                        obscureText: true,
                        initialValue: user.password,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: S.of(context).password,
                          icon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                        ),
                        onSaved: (v) {
                          user.password = v;
                        },
                        validator: (v) {
                          return v!.isEmpty ? S.of(context).passwordRequired : null;
                        },
                        onFieldSubmitted: (v) {
                          _login();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (ApplicationContext.instance.cameras.length > 0)
                          TextButton(
                            child: Text(
                              '人脸登录',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              setState(() {
                                this.isFaceRecognition = true;
                              });
                            },
                          ),
                        TextButton(
                          child: Text(
                            S.of(context).register,
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: _register,
                        ),
                        TextButton(
                          child: Text(
                            S.of(context).forgetPassword,
                            style: TextStyle(color: Colors.black45),
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.blue.shade600,
                child: Icon(Icons.person),
              ),
            ],
          ),
          Container(
            height: 360,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 420,
              child: FilledButton(
                onPressed: _login,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))),
                ),
                child: Text(S.of(context).login, style: TextStyle(color: Colors.white70, fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _register() {
    Cry.pushNamed('/register');
  }

  // 登录
  _login() async {
    var form = formKey.currentState!;
    if (!form.validate()) {
      return;
    }
    form.save();

    Map<String, dynamic> loginInfo = json.decode('{"currentUserInfo":{"id":"ef8297d1c7333cdc6aeefa96bb8fb89f","createTime":"2020 - 08 - 20 02: 39: 35","updateTime":"2024 - 05 - 09 20: 58: 48","userId":"db288d951c390afb08c8341088bd90fa","nickName":"cry","avatarUrl":"http: //www.cairuoyu.com/f/p4/u-20230907160512866-1898476488.png","gender":1,"country":null,"province":null,"city":null,"name":"cairuoyu6","school":null,"major":null,"birthday":"1984 - 10 - 16","entrance":null,"hometown":" 广东省,汕尾市,城区","memo":null,"deptId":"a51eb6c64d4b6d42fbdeef781fd2a892","userName":"admin","deptName":"QQ群"},"token":"eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIxIiwic3ViIjoiZGIyODhkOTUxYzM5MGFmYjA4YzgzNDEwODhiZDkwZmEiLCJpc3MiOiJ1c2VyIiwiaWF0IjoxNzE4Nzk3MzY5fQ.G7JPg0KEsFSoy_1uctO4fi9pSLzbY7auCQLg04doHtg"}');

    // ResponseBodyApi responseBodyApi = await UserApi.login(user.toMap());
    ResponseBodyApi responseBodyApi = ResponseBodyApi.fromMap({'success': true, 'code': '200', 'message': 'Test', 'data': loginInfo});
    if (!responseBodyApi.success!) {
      focusNodePassword.requestFocus();
      return;
    }
    _loginSuccess(responseBodyApi);
  }

  _loginSuccess(ResponseBodyApi responseBodyApi) async {
    print("_loginSuccess start");
    StoreUtilTest.write(Constant.KEY_TOKEN, responseBodyApi.data[Constant.KEY_TOKEN]);
    StoreUtilTest.write(Constant.KEY_CURRENT_USER_INFO, responseBodyApi.data[Constant.KEY_CURRENT_USER_INFO]);
    print("loadDict start");
    await StoreUtilTest.loadDict();
    print("loadSubsystem start");
    await StoreUtilTest.loadSubsystem();
    print("loadMenuData start");
    await StoreUtilTest.loadMenuData();
    print("loadDefaultTabs start");
    await StoreUtilTest.loadDefaultTabs();
    StoreUtilTest.init();

    Cry.pushNamed('/');
  }
}
