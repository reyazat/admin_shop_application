import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/helpers/Utility.dart';
import 'package:smartshopadmin/models/ClientsInfoModel.dart';
import 'package:smartshopadmin/provider/clients/ClientsInfoProvider.dart';
import 'package:smartshopadmin/provider/clients/ClientsInfoState.dart';
import 'package:smartshopadmin/provider/clients/ClientsProvider.dart';
import 'package:smartshopadmin/screens/OrderInfoScreen.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/EditDialogWidget.dart';
import 'package:smartshopadmin/widgets/ListToRefreshWdget.dart';
import 'package:smartshopadmin/widgets/RowInfo.dart';

class ClientsInfo extends StatefulWidget {
  static final String routeName = '/ClientsInfo';
  final String customerId;

  ClientsInfo({Key key, this.customerId}) : super(key: key);

  @override
  _ClientsInfoState createState() => _ClientsInfoState();
}

class _ClientsInfoState extends State<ClientsInfo> with SingleTickerProviderStateMixin {
  static const _tabCount = 3;
  TabController _tabController;

  @override
  void initState() {
    context.read<ClientsInfoProvider>().getClientInfo(widget.customerId);
    context.read<ClientsInfoProvider>().getRewardPoints(widget.customerId);

    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColors.subMainColor,
        foregroundColor: MainColors.white,
        title: Text('Clients Details', style: Styles.textTitleStyle.copyWith(
        fontSize: MediaQuery.of(context).size.height / 40,),),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelPadding: EdgeInsets.symmetric(horizontal: screenWidth / 13),
          labelStyle: TextStyle(
            fontSize: screenHeight / 55,
          ),
          tabs: <Widget>[
            Tab(text: 'INFO'),
            Tab(text: 'ORDERS'),
            Tab(text: 'REWARD POINTS'),
          ],
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.1), BlendMode.dstATop
                    ),
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.fitHeight
                ),
              ),
            ),
            TabBarView(
              controller: _tabController,
              children: [
                Consumer<ClientsInfoProvider>(
                  builder: (context, state, child) {
                    print(state.clientsInfoState);


                    if(state.clientsInfoState is ClientsInfoLoading || state.clientsInfoState is ClientsInfoInitial) {
                      ShowMessageService.showLoading();
                      return SizedBox();

                    } else if(state.clientsInfoState is ClientsInfoLoaded) {

                      ClientsInfoModel clientInfo = state.clientInfo;
                      ShowMessageService.closeLoading();

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Client Info",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MainColors.mainColor,
                                        fontSize: screenHeight / 45,
                                      ),
                                    ),
                                    RowInfo(title: 'Name', value: Utility.decodeUtf8('${clientInfo.firstname} ${clientInfo.lastname}')),
                                    RowInfo(
                                      title: 'Email',
                                      value: clientInfo.email,
                                      icon: FontAwesomeIcons.envelopeOpenText,
                                      iconAction: () => Utility.lunchMailTo(context, email: clientInfo.email),
                                    ),
                                    RowInfo(
                                      title: 'Phone',
                                      value: clientInfo.telephone,
                                      icon: FontAwesomeIcons.phone,
                                      iconAction: () => Utility.lunchCall(context, clientInfo.telephone),
                                    ),
                                  ],
                                ),
                              ) ,
                            ),
                            Card(
                              margin: EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Order Info",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MainColors.mainColor,
                                        fontSize: screenHeight / 45,
                                      ),
                                    ),
                                    RowInfo(title: 'Processing orders', value: clientInfo.processing),
                                    RowInfo(title: 'Completed orders', value: clientInfo.completed),
                                    RowInfo(title: 'Cancelled orders', value: clientInfo.cancelled),
                                    RowInfo(title: 'Summary', value: clientInfo.total),
                                  ],
                                ),
                              ) ,
                            ),
                          ],
                        ),
                      );

                    } else {
                      ShowMessageService.closeLoading();
                      return SizedBox();
                    }
                  },
                ),
                Consumer<ClientsInfoProvider>(
                  builder: (context, state, child) {
                    print(state.clientsInfoState);

                    if(state.clientsInfoState is ClientsInfoLoading || state.clientsInfoState is ClientsInfoInitial) {
                      ShowMessageService.showLoading();
                      return SizedBox();

                    } else if(state.clientsInfoState is ClientsInfoLoaded) {

                      List<ClientOrdersModel> clientOrders = state.clientInfo.orders;
                      ShowMessageService.closeLoading();

                      return clientOrders.length == 0
                          ?
                      Center(
                        child: Card(
                          elevation: 5,
                          color: MainColors.white.withOpacity(0.7),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(Constants.noOrders,
                              style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 65),
                            ),
                          ),
                        ),
                      )
                          :
                      Container(
                        width: screenWidth,
                        height: screenHeight,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: clientOrders.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => OrderInfo(orderId: clientOrders[index].orderId),
                                  ));
                                },
                                child: Card(
                                  margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RowInfo(title: 'Order', value: clientOrders[index].orderNumber),
                                        RowInfo(title: 'Status', value: clientOrders[index].status),
                                        RowInfo(title: 'Date Added', value: clientOrders[index].dateAdded),
                                        RowInfo(title: 'Total', value: clientOrders[index].total),
                                      ],
                                    ),
                                  ) ,
                                ),
                              );
                            }
                        ),
                      );
                    } else {
                      ShowMessageService.closeLoading();
                      return SizedBox();
                    }
                  },
                ),
                Consumer<ClientsInfoProvider>(
                  builder: (context, state, child) {
                    print(state.clientsInfoState);

                    if(state.clientsInfoState is ClientsInfoLoading || state.clientsInfoState is ClientsInfoInitial) {
                      ShowMessageService.showLoading();
                      return SizedBox();

                    } else if(state.clientsInfoState is ClientsInfoLoaded) {
                      ShowMessageService.closeLoading();
                      return state.points.length == 0
                          ?
                      Center(
                        child: Card(
                          elevation: 5,
                          color: MainColors.white.withOpacity(0.7),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(Constants.noRewardPoints, style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 65),),
                          ),
                        ),
                      )
                          :
                      Column(
                        children: [
                          Card(
                            color: Colors.white30,
                            margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                            child: Container(
                              width: screenWidth,
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text("Total:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MainColors.black,
                                      fontSize: screenHeight / 45,
                                    ),
                                  ),
                                  SizedBox(width: 90),
                                  Text(state.totalPoints,
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: MainColors.black,
                                      fontSize: screenHeight / 45,
                                    ),
                                  ),
                                ],
                              ),
                            ) ,
                          ),
                          Expanded(
                            child: ListToRefresh(
                              onRefresh: _onRefreshPoints,
                              onLoading: _onLoadingPoints,
                              backGround: false,
                              child: ListView.builder(
                                itemCount: state.points.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Card(
                                        margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                        child: Slidable(
                                          actionPane: SlidableDrawerActionPane(),
                                          actionExtentRatio: 0.25,
                                          secondaryActions: <Widget>[
                                            IconSlideAction(
                                              caption: 'Delete',
                                              color: MainColors.redAction,
                                              iconWidget: Icon(FontAwesomeIcons.trashAlt,
                                                color: Colors.white,
                                                size: MediaQuery.of(context).size.height / 30,
                                              ),
                                              onTap: () => _deleteRewardPoint(
                                                customerId: state.points[index].customerId,
                                                rewardId: int.parse(state.points[index].id),
                                              ),
                                            ),
                                          ],
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RowInfo(title: 'Date Added', value: state.points[index].dateAdded),
                                                RowInfo(title: 'Description', value: state.points[index].description),
                                                RowInfo(title: 'Points', value: state.points[index].points),
                                              ],
                                            ),
                                          ),
                                        ) ,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      ShowMessageService.closeLoading();
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _onRefreshPoints() {
    Provider.of<ClientsInfoProvider>(context, listen: false).getRewardPoints(widget.customerId);
  }

  void _onLoadingPoints() {
    Provider.of<ClientsInfoProvider>(context, listen: false).loadingPagePoints(widget.customerId);
  }

  _deleteRewardPoint({String customerId, int rewardId}) {
    String title = 'Are you sure you want to delete this customer reward point?';

    showCupertinoModalPopup(
        context: context,
        builder: (_) => EditDialogWidget(
            title:Text(title),
            childYes: Text("Delete",
              style: Styles.textActionStyle.copyWith(color: MainColors.redAction, fontSize: MediaQuery.of(context).size.height / 50),
            ),
            onPressYes: () async {
              await context.read<ClientsInfoProvider>().deleteRewardPoint(
                customerId: customerId,
                rewardId: rewardId,
              );

              await context.read<ClientsProvider>().searchClients();

              Navigator.pop(context);
            },
            onPressNo: () => Navigator.pop(context),
            childNo: Text("Cancel",
              style: Styles.textActionStyle.copyWith(color: MainColors.blueAction, fontSize: MediaQuery.of(context).size.height / 50),
            )
        )
    );
  }
  
}