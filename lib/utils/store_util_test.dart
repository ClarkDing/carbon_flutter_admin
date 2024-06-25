/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description: 存储工具类

import 'package:cry/cry_logger.dart';
import 'package:cry/model/response_body_api.dart';
import 'package:flutter_admin/api/dict_api.dart';
import 'package:flutter_admin/api/menu_api.dart';
import 'package:flutter_admin/api/setting_default_tab.dart';
import 'package:flutter_admin/api/subsystem_api.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/models/menu.dart';
import 'package:flutter_admin/models/subsystem.dart';
import 'package:flutter_admin/models/tab_page.dart';
import 'package:flutter_admin/models/user_info.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class StoreUtilTest {
  static read(String key) {
    return GetStorage().read(key);
  }

  static write(String key, value) {
    GetStorage().write(key, value);
  }

  static hasData(String key) {
    return GetStorage().hasData(key);
  }

  static cleanAll() {
    GetStorage().erase();
  }

  static init() {
    var list = getDefaultTabs();
    writeOpenedTabPageList(list);
    if (list.length > 0) {
      writeCurrentOpenedTabPageId(list.first.id);
    }
  }

  static List<TabPage?> readOpenedTabPageList() {
    var data = read(Constant.KEY_OPENED_TAB_PAGE_LIST);
    return data == null ? [] : List.from(data).map((e) => TabPage.fromMap(e)).toList();
  }

  static writeOpenedTabPageList(List<TabPage?> list) {
    var data = list.map((e) => e!.toMap()).toList();
    write(Constant.KEY_OPENED_TAB_PAGE_LIST, data);
  }

  static String? readCurrentOpenedTabPageId() {
    return read(Constant.KEY_CURRENT_OPENED_TAB_PAGE_ID);
  }

  static writeCurrentOpenedTabPageId(String? data) {
    write(Constant.KEY_CURRENT_OPENED_TAB_PAGE_ID, data);
  }

  static UserInfo getCurrentUserInfo() {
    var data = GetStorage().read(Constant.KEY_CURRENT_USER_INFO);
    return data == null ? UserInfo() : UserInfo.fromMap(data);
  }

  static List<Menu> getMenuList() {
    var data = GetStorage().read(Constant.KEY_MENU_LIST);
    return data == null ? [] : List.from(data).map((e) => Menu.fromMap(e)).toList();
  }

  static List<Subsystem> getSubsystemList() {
    var data = GetStorage().read(Constant.KEY_SUBSYSTEM_LIST);
    return data == null ? [] : List.from(data).map((e) => Subsystem.fromMap(e)).toList();
  }

  static Subsystem? getCurrentSubsystem() {
    var data = GetStorage().read(Constant.KEY_CURRENT_SUBSYSTEM);
    return data == null ? null : Subsystem.fromMap(data);
  }

  static List<TabPage> getDefaultTabs() {
    var data = GetStorage().read(Constant.KEY_DEFAULT_TABS);
    return data == null ? [] : List.from(data).map((e) => TabPage.fromMap(e)).toList();
  }

  static Future<bool?> loadDict() async {

    Map<String, dynamic> dictInfo = json.decode('{"yesno":[{"id":6,"createTime":null,"updateTime":null,"dictId":3,"code":1,"name":"是","createrId":null},{"id":7,"createTime":null,"updateTime":null,"dictId":3,"code":0,"name":"否","createrId":null}],"deptFun":[{"id":"02 a2900d3f7c8a72d05e8309f9b54016","createTime":null,"updateTime":null,"dictId":"a9cff71a8b2d2bb65234a38e0c31f443","code":2,"name":"干活的","createrId":null},{"id":"ec90507742272342127fbc80fcb7379e","createTime":null,"updateTime":null,"dictId":"a9cff71a8b2d2bb65234a38e0c31f443","code":1,"name":"管事的","createrId":null}],"gender":[{"id":8,"createTime":null,"updateTime":null,"dictId":4,"code":1,"name":"男","createrId":null},{"id":9,"createTime":null,"updateTime":null,"dictId":4,"code":2,"name":"女","createrId":null}],"level":[{"id":"21126e1 c005a8389437325861d6ad415","createTime":"2024 - 04 - 24 20: 49: 24","updateTime":"2024 - 04 - 24 20: 49: 24","dictId":"70 fa301d42c3a097f31da7bebd2e4299","code":"B","name":"Level B","createrId":null},{"id":"b45dfbc1f362060c0d914ec5139f0e6d","createTime":"2024 - 04 - 24 20: 49: 24","updateTime":"2024 - 04 - 24 20: 49: 24","dictId":"70 fa301d42c3a097f31da7bebd2e4299","code":"C","name":"Level C","createrId":null},{"id":"f2e99620b1af26dee3804d6ec07a9d40","createTime":"2024 - 04 - 24 20: 49: 24","updateTime":"2024 - 04 - 24 20: 49: 24","dictId":"70 fa301d42c3a097f31da7bebd2e4299","code":"A","name":"Level A","createrId":null}],"isBoss":[],"articleStatus":[{"id":"15 b694e8d8cd2a7fdfe8b4d57b186343","createTime":"2021 - 03 - 18 09: 53: 56","updateTime":"2021 - 03 - 18 09: 53: 56","dictId":"3098 ac0bbe036b038c640e0db1eb574a","code":"draft","name":"草稿","createrId":null},{"id":"867 df0c4bbdde6eac4b7e0ace873bbb5","createTime":"2021 - 03 - 18 09: 53: 56","updateTime":"2021 - 03 - 18 09: 53: 56","dictId":"3098 ac0bbe036b038c640e0db1eb574a","code":"public","name":"公开","createrId":null},{"id":"ce7cc4b68b3c6f42079c0f4ed641b7aa","createTime":"2021 - 03 - 18 09: 53: 56","updateTime":"2021 - 03 - 18 09: 53: 56","dictId":"3098 ac0bbe036b038c640e0db1eb574a","code":"audit","name":"审核","createrId":null}],"SEX":[{"id":"a5252c29329063a82421a15de026fe99","createTime":"2024 - 04 - 19 20: 59: 55","updateTime":"2024 - 04 - 19 20: 59: 55","dictId":"f68c47f5cf214a239d7edb6d5e3a4c68","code":"M","name":"男","createrId":null},{"id":"ec0b6a214ac59cd08c80dd0360f65652","createTime":"2024 - 04 - 19 20: 59: 55","updateTime":"2024 - 04 - 19 20: 59: 55","dictId":"f68c47f5cf214a239d7edb6d5e3a4c68","code":"F","name":"女","createrId":null}],"dept":[{"id":"10","createTime":null,"updateTime":null,"dictId":5,"code":1,"name":"技术部","createrId":null},{"id":11,"createTime":null,"updateTime":null,"dictId":5,"code":2,"name":"产品部","createrId":null},{"id":12,"createTime":null,"updateTime":null,"dictId":5,"code":3,"name":"销售部","createrId":null}]}');

    // ResponseBodyApi responseBodyApi = await UserApi.login(user.toMap());
    ResponseBodyApi responseBodyApi = ResponseBodyApi.fromMap({'success': true, 'code': '0', 'message': 'Test', 'data': dictInfo});


    if (responseBodyApi.success!) {
      StoreUtilTest.write(Constant.KEY_DICT_ITEM_LIST, responseBodyApi.data);
    }
    return responseBodyApi.success;
  }

  // 加载子系统
  static Future<bool?> loadSubsystem() async {
    CryLogger.info('loadSubsystem start');
    Map<String, dynamic> sysInfo = json.decode('{"yesno":[{"id":6,"createTime":null,"updateTime":null,"dictId":3,"code":1,"name":"是","createrId":null},{"id":7,"createTime":null,"updateTime":null,"dictId":3,"code":0,"name":"否","createrId":null}],"deptFun":[{"id":"02 a2900d3f7c8a72d05e8309f9b54016","createTime":null,"updateTime":null,"dictId":"a9cff71a8b2d2bb65234a38e0c31f443","code":2,"name":"干活的","createrId":null},{"id":"ec90507742272342127fbc80fcb7379e","createTime":null,"updateTime":null,"dictId":"a9cff71a8b2d2bb65234a38e0c31f443","code":1,"name":"管事的","createrId":null}],"gender":[{"id":8,"createTime":null,"updateTime":null,"dictId":4,"code":1,"name":"男","createrId":null},{"id":9,"createTime":null,"updateTime":null,"dictId":4,"code":2,"name":"女","createrId":null}],"level":[{"id":"21126e1 c005a8389437325861d6ad415","createTime":"2024 - 04 - 24 20: 49: 24","updateTime":"2024 - 04 - 24 20: 49: 24","dictId":"70 fa301d42c3a097f31da7bebd2e4299","code":"B","name":"Level B","createrId":null},{"id":"b45dfbc1f362060c0d914ec5139f0e6d","createTime":"2024 - 04 - 24 20: 49: 24","updateTime":"2024 - 04 - 24 20: 49: 24","dictId":"70 fa301d42c3a097f31da7bebd2e4299","code":"C","name":"Level C","createrId":null},{"id":"f2e99620b1af26dee3804d6ec07a9d40","createTime":"2024 - 04 - 24 20: 49: 24","updateTime":"2024 - 04 - 24 20: 49: 24","dictId":"70 fa301d42c3a097f31da7bebd2e4299","code":"A","name":"Level A","createrId":null}],"isBoss":[],"articleStatus":[{"id":"15 b694e8d8cd2a7fdfe8b4d57b186343","createTime":"2021 - 03 - 18 09: 53: 56","updateTime":"2021 - 03 - 18 09: 53: 56","dictId":"3098 ac0bbe036b038c640e0db1eb574a","code":"draft","name":"草稿","createrId":null},{"id":"867 df0c4bbdde6eac4b7e0ace873bbb5","createTime":"2021 - 03 - 18 09: 53: 56","updateTime":"2021 - 03 - 18 09: 53: 56","dictId":"3098 ac0bbe036b038c640e0db1eb574a","code":"public","name":"公开","createrId":null},{"id":"ce7cc4b68b3c6f42079c0f4ed641b7aa","createTime":"2021 - 03 - 18 09: 53: 56","updateTime":"2021 - 03 - 18 09: 53: 56","dictId":"3098 ac0bbe036b038c640e0db1eb574a","code":"audit","name":"审核","createrId":null}],"SEX":[{"id":"a5252c29329063a82421a15de026fe99","createTime":"2024 - 04 - 19 20: 59: 55","updateTime":"2024 - 04 - 19 20: 59: 55","dictId":"f68c47f5cf214a239d7edb6d5e3a4c68","code":"M","name":"男","createrId":null},{"id":"ec0b6a214ac59cd08c80dd0360f65652","createTime":"2024 - 04 - 19 20: 59: 55","updateTime":"2024 - 04 - 19 20: 59: 55","dictId":"f68c47f5cf214a239d7edb6d5e3a4c68","code":"F","name":"女","createrId":null}],"dept":[{"id":"10","createTime":null,"updateTime":null,"dictId":5,"code":1,"name":"技术部","createrId":null},{"id":11,"createTime":null,"updateTime":null,"dictId":5,"code":2,"name":"产品部","createrId":null},{"id":12,"createTime":null,"updateTime":null,"dictId":5,"code":3,"name":"销售部","createrId":null}]}');

    ResponseBodyApi responseBodyApi = await SubsystemApi.listEnable();
    if (responseBodyApi.success!) {
      StoreUtilTest.write(Constant.KEY_SUBSYSTEM_LIST, responseBodyApi.data);
      CryLogger.info('loadSubsystem: ${responseBodyApi.data}');
      List<Subsystem> list = responseBodyApi.data == null ? [] : List.from(responseBodyApi.data).map((e) => Subsystem.fromMap(e)).toList();
      if (list.isNotEmpty) {
        StoreUtilTest.write(Constant.KEY_CURRENT_SUBSYSTEM, list[0].toMap());
      }
    }
    return responseBodyApi.success;
  }

  static Future<bool?> loadMenuData() async {
    var currentSubsystem = StoreUtilTest.getCurrentSubsystem();
    if (currentSubsystem == null) {
      return true;
    }
    ResponseBodyApi responseBodyApi = await MenuApi.listAuth(currentSubsystem.id);
    if (responseBodyApi.success!) {
      StoreUtilTest.write(Constant.KEY_MENU_LIST, responseBodyApi.data);
    }
    return responseBodyApi.success;
  }

  static Future<bool?> loadDefaultTabs() async {
    ResponseBodyApi responseBodyApi = await SettingDefaultTabApi.list();
    if (responseBodyApi.success!) {
      StoreUtilTest.write(Constant.KEY_DEFAULT_TABS, responseBodyApi.data);
    }
    return responseBodyApi.success;
  }
}
