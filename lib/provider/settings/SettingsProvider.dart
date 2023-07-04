
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartshopadmin/models/PrinterModel.dart';
import 'package:smartshopadmin/provider/settings/SettingsHelper.dart';
import 'package:smartshopadmin/provider/settings/SettingsState.dart';
import 'package:smartshopadmin/services/LoggerService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';

class SettingsProvider extends ChangeNotifier {
  final info = NetworkInfo();
  SettingsState _settingsState;
  List<PrinterModel> _devices = [];
  int _found = 0;

  List<PrinterModel> get devices => _devices;

  int get found => _found;

  SettingsState get settingsState => _settingsState;

  set settingsState(SettingsState value){
    _settingsState = value;
    notifyListeners();
  }

  SettingsProvider(){
    this.settingsState = SettingsInitial();
    this.init();
  }

  Future<void> checkConnection() async {
    final connection = await DataConnectionChecker().connectionStatus;
    if(connection == DataConnectionStatus.disconnected){
      print("Last results: ${DataConnectionChecker().lastTryResults}");
      this.settingsState = SettingsNetworkError();
    }
  }
  void initPrinter() async {

    await this.checkConnection();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value = preferences.getInt("loginStatus");
    if (value != 1) {
      this.settingsState = SettingsLogOut();
    }else{
      this._devices = await SettingsHelper.getPrinters();
      this._found = devices!=null ? devices.length : 0;
      print('---------------');
      print(found);
      if(found == 0) await searchDevice();
      else
        this.settingsState = SettingsLoaded();
    }
  }

  void init() async {
    await this.checkConnection();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value = preferences.getInt("loginStatus");
    if (value != 1) {
      this.settingsState = SettingsLogOut();
    }else{
      this.settingsState = SettingsLoaded();
    }
  }

  void addPrinter(PrinterModel newMap,{index}){
    if(devices != null && devices.length != 0) {
      bool add = true;
      for (var map in devices) {
        if (map.ip == newMap.ip && map.port == newMap.port) {
          add = false;
        }
      }
      if(add){
        if(index!=null)
          this._devices.insert(index,newMap);
        else
          this._devices.add(newMap);

        this._found = devices.length;
        notifyListeners();
      }

    }else{
      if(index!=null)
        this._devices.insert(index,newMap);
      else
        this._devices.add(newMap);
      this._found = devices.length;
      notifyListeners();
    }
  }

  Future<void> searchDevice() async {
    this.settingsState = SettingsLoading();
    String ip;
    try {
      ip = await info.getWifiIP();
      print('local ip:\t$ip');
    } catch (e) {
      ShowMessageService.showErrorMsg(Constants.wifiError);
      this.settingsState = SettingsLoaded();
      LoggerService.logger.e(e);
      return null;
    }
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    int port = 9100;
    print('subnet:\t$subnet, port:\t$port');
    await checkPort(subnet,port);
  }
  Future<void> checkPort(subnet,port)async {
    this.settingsState = SettingsLoading();
    final stream = NetworkAnalyzer.discover2(subnet, port,timeout: Duration(seconds: 7));
    stream.listen((NetworkAddress address) {
      print('listen with port $port');
      if (address.exists) {
        print('Found device: ${address.ip}');
        addPrinter(PrinterModel(
            ip: address.ip,
            name: 'Printer ${found+1}',
            port: port,
          checked: true
        ));
      }
    })..onDone(() async {
      print('Finish. Found $found device(s)');
      this.settingsState = SettingsLoaded();
      await SettingsHelper.savePrinter(devices);
      this._found = devices.length;
      if(port == 4000) return null;
      if(found == 0) checkPort(subnet,4000);
    })..onError((dynamic e) {
      this.settingsState = SettingsLoaded();
      LoggerService.logger.e(e);
    });
  }

  manuallyAdd(PrinterModel dvs,{int index}) async {
    this.settingsState = SettingsLoading();
    if(index!=null) devices[index].name = dvs.name;
    addPrinter(dvs,index:index);
    await SettingsHelper.savePrinter(devices);
    this._found = devices.length;
    this.settingsState = SettingsLoaded();
    notifyListeners();
  }

  deletePrinter(int index) async {
    this.settingsState = SettingsLoading();
    devices.removeAt(index);
    if(devices == null || devices.length == 0){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.remove("printers") ;
    }
    await SettingsHelper.savePrinter(devices);
    this._found = devices.length;
    this.settingsState = SettingsLoaded();
    notifyListeners();
  }
  checkedPrinter(int index) async {
    this.settingsState = SettingsLoading();
    devices[index].checked = !devices[index].checked;
    await SettingsHelper.savePrinter(devices);
    this._found = devices.length;
    this.settingsState = SettingsLoaded();
    notifyListeners();
  }
}
