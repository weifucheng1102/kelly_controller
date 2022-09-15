import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class MenuController extends GetxController {
  final List<String> title = [
    'Menu',
    'Connection',
    'Parameters',
    'Monitor Control',
    'Data Visualization',
    'Firmware',
    'UserApp Settings'
  ];
  final List<String> image = [
    'menu.png',
    'connection.png',
    'parameter.png',
    'control.png',
    'data.png',
    'firmware.png',
    'setting.png'
  ];
  final List<String> unImage = [
    'un_menu.png',
    'un_connection.png',
    'un_parameter.png',
    'un_control.png',
    'un_data.png',
    'un_firmware.png',
    'un_setting.png'
  ];

  RxInt selectIndex = 0.obs;

  ///底部菜单选中按钮
  RxInt bottomMenuIndex = 0.obs;
}
