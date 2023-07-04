import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/helpers/Utility.dart';
import 'package:smartshopadmin/models/PrinterModel.dart';
import 'package:smartshopadmin/provider/Auth/AuthProvider.dart';
import 'package:smartshopadmin/provider/settings/SettingsHelper.dart';
import 'package:smartshopadmin/provider/settings/SettingsProvider.dart';
import 'package:smartshopadmin/provider/settings/SettingsState.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/EditDialogWidget.dart';
import 'package:smartshopadmin/widgets/InputBuildWidget.dart';
import 'package:smartshopadmin/widgets/ListToRefreshWdget.dart';

class Printer extends StatefulWidget {
  static final String routeName = '/Printer';

  @override
  _PrinterState createState() => _PrinterState();
}

class _PrinterState extends State<Printer> {
  InputBuildWidget _deviceName = InputBuildWidget(
    label: 'Device Name',
    hint: 'Device Name',
    inputType: TextInputType.name,
  );
  InputBuildWidget _deviceIp = InputBuildWidget(
    label: 'Device IP Address',
    hint: 'Device IP Address',
    inputType: TextInputType.numberWithOptions(signed: true, decimal: true),
  );
  InputBuildWidget _devicePort = InputBuildWidget(
    label: 'Device Port Number',
    hint: 'Device Port Number',
    inputType: TextInputType.number,
  );

  @override
  void initState() {
    context.read<SettingsProvider>().initPrinter();
    super.initState();
  }
  @override
  void dispose() {
    _deviceName.controller.dispose();
    _deviceIp.controller.dispose();
    _devicePort.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
        backgroundColor: MainColors.mainColor,
        minRadius: 10.0,
        maxRadius: MediaQuery.of(context).size.height / 25,
        child: IconButton(
            icon: Icon(FontAwesomeIcons.search,
                color: MainColors.white,
                size: MediaQuery.of(context).size.height / 35),
            onPressed: context.read<SettingsProvider>().searchDevice),
      ),
      appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: MainColors.white),
          backgroundColor: MainColors.subMainColor,
          foregroundColor: MainColors.subMainColor,
          title: Text(
            'All Printers',
            style: Styles.textTitleStyle.copyWith(
              fontSize: MediaQuery.of(context).size.height / 40,
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(FontAwesomeIcons.search,
                    color: MainColors.white,
                    size: MediaQuery.of(context).size.height / 35),
                onPressed: context.read<SettingsProvider>().searchDevice),
          ]),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.1), BlendMode.dstATop),
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.fitHeight),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 45,
            ),
            Consumer<SettingsProvider>(
              builder: (context, state, child) {
                print(state.settingsState);
                if (state.settingsState is SettingsLoading ||
                    state.settingsState is SettingsInitial) {
                  ShowMessageService.showLoading();
                  return SizedBox();
                } else if (state.settingsState is SettingsLogOut) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    context.read<AuthProvider>().signOut(context);
                  });
                  return SizedBox();
                } else if (state.settingsState is SettingsLoaded) {
                  ShowMessageService.closeLoading();
                  return state.found == 0
                      ? addPrinter()
                      : ListToRefresh(
                          onRefresh:
                              context.read<SettingsProvider>().searchDevice,
                          backGround: true,
                          child: ListView.builder(
                            itemCount: state.devices.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == state.found) {
                                return addPrinter();
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    secondaryActions: <Widget>[
                                      IconSlideAction(
                                        caption: 'Test Receipt',
                                        color: MainColors.greyLight,
                                        iconWidget: Icon(FontAwesomeIcons.print,color:MainColors.black, size: MediaQuery.of(context).size.height / 30),
                                        onTap: () => SettingsHelper().testPrint(state.devices[index]),
                                      ),
                                      IconSlideAction(
                                        caption: 'Edit',
                                        color: MainColors.amber,
                                        iconWidget: Icon(FontAwesomeIcons.edit,color:MainColors.black, size: MediaQuery.of(context).size.height / 30),
                                        onTap: ()=>addOrEditPrinter(device: state.devices[index],index:index),
                                      ),
                                      IconSlideAction(
                                        caption: 'Delete',
                                        color: MainColors.redAction,
                                        iconWidget: Icon(FontAwesomeIcons.trashAlt,color: MainColors.black, size: MediaQuery.of(context).size.height / 30),
                                        onTap: ()=>deletePrinter(index),
                                      ),
                                    ],
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 15.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.print,
                                            color: MainColors.mainColor,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: InkWell(
                                              onTap: ()=>context.read<SettingsProvider>().checkedPrinter(index),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '${state.devices[index].name}',
                                                    style: Styles.textLabStyle
                                                        .copyWith(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              58,
                                                    ),
                                                  ),
                                                  Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(
                                                        text: 'IP : ',
                                                        style: Styles.textLabStyle
                                                            .copyWith(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              70,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${state.devices[index].ip}:${state.devices[index].port}',
                                                        style: Styles.textLabStyle
                                                            .copyWith(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              70,
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                  Text(
                                                    'Click to select a printer',
                                                    style: Styles.textHintStyle
                                                        .copyWith(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                70),
                                                  ),
                                                  Text(
                                                    'Swipe to edit or delete',
                                                    style: Styles.textHintStyle
                                                        .copyWith(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                70),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          (state.devices[index].checked == true)?
                                          Icon(
                                            FontAwesomeIcons.check,
                                            color: MainColors.mainColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .height /
                                                30,
                                          ):
                                          SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (state.devices
                                      .asMap()
                                      .containsKey(index + 1))
                                    Divider(
                                      thickness: 1,
                                      endIndent: 35,
                                      indent: 35,
                                    ),
                                ],
                              );
                            },
                          ),
                        );
                } else if (state.settingsState is SettingsNetworkError) {
                  ShowMessageService.closeLoading();
                  return Center(
                    child: Card(
                      margin: EdgeInsets.all(30.0),
                      elevation: 5,
                      color: MainColors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0,
                                right: 30.0,
                                left: 30.0,
                                bottom: 0.0),
                            child: Text(
                              Constants.noInternet,
                              style: Styles.errorTextStyle.copyWith(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  ShowMessageService.closeLoading();
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  deletePrinter(int index) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => EditDialogWidget(
            title:Center(child: Text(Constants.deleteConfirm),),
            childYes: Text(
              "Delete",
              style: Styles.textActionStyle.copyWith(
                  color: MainColors.redAction,fontSize: MediaQuery.of(context).size.height / 50
              ),
            ),
            onPressYes: () async {
              context.read<SettingsProvider>().deletePrinter(index);
              Navigator.pop(context);
            },
            onPressNo: (){
              Navigator.pop(context);
            },
            childNo: Text(
              "Cancel",
              style: Styles.textActionStyle.copyWith(
                  color: MainColors.blueAction,fontSize: MediaQuery.of(context).size.height / 50
              ),
            )
        )
    );
  }


  addOrEditPrinter({PrinterModel device,int index}) {
    var cancel;
    String title = 'Add a printer using an IP address and port number.';
    if (device != null) {
      _deviceName.controller.text = device.name;
      _deviceIp.controller.text = device.ip;
      _devicePort.controller.text = device.port.toString();
      title = 'Change Printer Settings';
    }else{
      _deviceName.controller.text = '';
      _deviceIp.controller.text = '';
      _devicePort.controller.text = '';
    }
    showCupertinoModalPopup(
        context: context,
        builder: (_) => EditDialogWidget(
            title:Text(title),
            content: Column(
              children: [
                _deviceName,
                SizedBox(height: 20),
                _deviceIp,
                SizedBox(height: 20),
                _devicePort
              ],
            ),
            childYes: Text(
              "Save",
              style: Styles.textActionStyle.copyWith(
                  color: MainColors.blueAction,fontSize: MediaQuery.of(context).size.height / 50
              ),
            ),
            onPressYes: () async {
              if(Utility.isEmpty(_deviceName.controller.text) != null) {
                cancel = ShowMessageService.showErrorMsg('The device name ${Constants.required}');
                return null;
              }
              if(Utility.isEmpty(_deviceIp.controller.text) != null) {
                cancel = ShowMessageService.showErrorMsg('The device IP ${Constants.required}');
                return null;
              }
              if(Utility.isEmpty(_devicePort.controller.text) != null) {
                cancel = ShowMessageService.showErrorMsg('The device port ${Constants.required}');
                return null;
              }
              context.read<SettingsProvider>().manuallyAdd(PrinterModel(
                  ip: _deviceIp.controller.text,
                  name: _deviceName.controller.text,
                  port: int.parse(_devicePort.controller.text),
                  checked: true
              ),
                  index: index);
              if(cancel!=null)cancel();
              Navigator.pop(context);
            },
            onPressNo: (){
              if(cancel!=null)cancel();
              Navigator.pop(context);
            },
            childNo: Text(
              "Cancel",
              style: Styles.textActionStyle.copyWith(
                  color: MainColors.redAction,fontSize: MediaQuery.of(context).size.height / 50
              ),
            )
        )
    );
  }

  Widget addPrinter({PrinterModel device}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Divider(
          thickness: 1,
          endIndent: 35,
          indent: 35,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: InkWell(
            onTap: ()=>addOrEditPrinter(),
            child: Row(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.plus,
                  color: MainColors.mainColor,
                  size: MediaQuery.of(context).size.height / 30,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    'Add Printer',
                    style: Styles.textLabStyle.copyWith(
                      fontSize: MediaQuery.of(context).size.height / 58,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
