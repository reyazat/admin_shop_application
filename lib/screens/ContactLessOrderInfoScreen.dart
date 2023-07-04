import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartshopadmin/helpers/Utility.dart';
import 'package:smartshopadmin/provider/Auth/AuthProvider.dart';
import 'package:smartshopadmin/provider/orders/ContactLessOrderInfoProvider.dart';
import 'package:smartshopadmin/provider/orders/ContactLessOrdersProvider.dart';
import 'package:smartshopadmin/provider/settings/SettingsHelper.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/LoadingWidget.dart';
import 'package:smartshopadmin/widgets/RowInfo.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ContactLessOrderInfo extends StatefulWidget {
  static final String routeName = '/ContactLessOrderInfo';
  final orderId;

  const ContactLessOrderInfo({Key key, this.orderId}) : super(key: key);

  @override
  _ContactLessOrderInfoState createState() => _ContactLessOrderInfoState();
}

class _ContactLessOrderInfoState extends State<ContactLessOrderInfo>
    with SingleTickerProviderStateMixin {
  static const _tabCount = 3;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _tabCount, vsync: this);
    context.read<ContactLessOrderInfoProvider>().init();
    context.read<ContactLessOrderInfoProvider>().getOrderInfo(widget.orderId);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColors.subMainColor,
        foregroundColor: MainColors.white,
        title: Text(
          'Order Details',
          style: Styles.textTitleStyle.copyWith(
            fontSize: MediaQuery.of(context).size.height / 40,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.print,
                color: MainColors.white,
                size: MediaQuery.of(context).size.height / 35,
              ),
              onPressed: () => SettingsHelper()
                  .contactLessOrderInfoPrint(context.read<ContactLessOrderInfoProvider>().orderInfo),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: MainColors.white,
          labelPadding: EdgeInsets.symmetric(horizontal: screenWidth / 13),
          labelStyle: TextStyle(
              fontSize: screenHeight / 55, fontWeight: FontWeight.bold),
          tabs: <Widget>[
            Tab(text: 'INFO'),
            Tab(text: 'DELIVERY'),
            Tab(text: 'PRODUCTS'),
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
                        Colors.black.withOpacity(0.1), BlendMode.dstATop),
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.fitHeight),
              ),
            ),
            TabBarView(
              controller: _tabController,
              children: [
                Consumer<ContactLessOrderInfoProvider>(
                  builder: (context, state, child) {
                    if (state.orderInfoState is ContactLessOrderInfoLoading ||
                        state.orderInfoState is ContactLessOrderInfoInitial) {
                      return LoadingWidget();
                    } else if (state.orderInfoState is ContactLessOrderInfoLogOut) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        context.read<AuthProvider>().signOut(context);
                      });
                      return SizedBox();
                    } else if (state.orderInfoState is ContactLessOrderInfoLoaded) {
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
                                    Text(
                                      "Order Info",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MainColors.mainColor,
                                        fontSize: screenHeight / 45,
                                      ),
                                    ),
                                    RowInfo(
                                        title: 'Order Number :',
                                        value: '${state.orderInfo.invoiceId}'),
                                    RowInfo(
                                      title: 'Total :',
                                      value:
                                          state.orderInfo.total,
                                    ),
                                    RowInfo(
                                      title: 'Order Date : ',
                                      value: '${state.orderInfo.createdAt}',
                                    ),
                                    Container(
                                      width: screenWidth,
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: screenWidth / 3,
                                            alignment: Alignment.centerLeft,
                                            child: Text('Order Status : ',
                                              style: TextStyle(
                                                color: MainColors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenHeight / 55,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: screenWidth / 1.5,
                                              alignment: Alignment.centerLeft,
                                              child: Text('${state.orderInfo.status}',
                                                style: Styles.textLargeLabStyle.copyWith(
                                                    fontSize: MediaQuery.of(context).size.height /50),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth,
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Container(
                                        width: screenWidth,
                                        alignment: Alignment.center,
                                        child: ToggleSwitch(
                                          minWidth: screenWidth/3,
                                          minHeight: 50,
                                          initialLabelIndex: state.initToggleSwitch,
                                          cornerRadius: 20.0,
                                          activeFgColor: MainColors.white,
                                          inactiveBgColor: MainColors.greyLight,
                                          inactiveFgColor: MainColors.dark,
                                          totalSwitches: 2,
                                          labels: ['Preparing', 'Completed'],
                                          icons: [FontAwesomeIcons.mortarPestle, FontAwesomeIcons.thumbsUp],
                                          activeBgColors: [[MainColors.amber],[MainColors.green]],
                                          customTextStyles:[
                                            Styles.textLabStyle.copyWith(
                                                fontSize: MediaQuery.of(context).size.height /70),
                                            Styles.textLabStyle.copyWith(
                                                fontSize: MediaQuery.of(context).size.height /70)],
                                          onToggle: (index) {
                                            state.initToggleSwitch =index;
                                            if(index ==1){

                                              state.changeStatus(index,state.orderInfo.orderId, 'Completed');
                                            }
                                            if(index ==0){
                                              state.changeStatus(index,state.orderInfo.orderId, 'Preparing');
                                            }
                                            context.read<ContactLessOrdersProvider>().searchOrders();
                                          },
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 45,
                            ),
                            Card(
                              margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Customer Info",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MainColors.mainColor,
                                        fontSize: screenHeight / 45,
                                      ),
                                    ),
                                    RowInfo(
                                        title: 'Full Name : ',
                                        value:
                                            '${Utility.decodeUtf8(state.orderInfo.fName)}  ${Utility.decodeUtf8(state.orderInfo.lName)}'),

                                    if(state.orderInfo.email!=null && state.orderInfo.email.isNotEmpty)
                                    RowInfo(
                                      title: 'Email :',
                                      value: '${state.orderInfo.email}',
                                      icon: FontAwesomeIcons.envelopeOpenText,
                                      iconAction: () => Utility.lunchMailTo(
                                          context,
                                          email: state.orderInfo.email),
                                    ),
                                    if(state.orderInfo.phone!=null && state.orderInfo.phone.isNotEmpty)
                                    SizedBox(
                                      height: 20,
                                    ),
                                    if(state.orderInfo.phone!=null && state.orderInfo.phone.isNotEmpty)
                                    RowInfo(
                                      title: 'Phone :',
                                      value: '${state.orderInfo.phone}',
                                      icon: FontAwesomeIcons.phone,
                                      iconAction: () => Utility.lunchCall(
                                          context, state.orderInfo.phone),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state.orderInfoState is ContactLessOrderInfoNetworkError) {
                      return Center(
                        child: Card(
                          margin: EdgeInsets.all(30.0),
                          elevation: 5,
                          color: MainColors.white,
                          child: Padding(
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
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                Consumer<ContactLessOrderInfoProvider>(
                  builder: (context, state, child) {
                    if (state.orderInfoState is ContactLessOrderInfoLoading ||
                        state.orderInfoState is ContactLessOrderInfoInitial) {
                      return LoadingWidget();
                    } else if (state.orderInfoState is ContactLessOrderInfoLogOut) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        context.read<AuthProvider>().signOut(context);
                      });
                      return SizedBox();
                    } else if (state.orderInfoState is ContactLessOrderInfoLoaded) {
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
                                    Text(
                                      "Payment Info",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MainColors.mainColor,
                                        fontSize: screenHeight / 45,
                                      ),
                                    ),
                                    RowInfo(
                                        title: 'Payment Method :',
                                        value:
                                            '${state.orderInfo.cardType}'),
                                    RowInfo(
                                        title: 'Card Number :',
                                        value:
                                        '${state.orderInfo.cardNumber}'),
                                    RowInfo(
                                      title: 'Total :',
                                      value:
                                          state.orderInfo.total,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 45,
                            ),
                            Card(
                              margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Delivery Info",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MainColors.mainColor,
                                        fontSize: screenHeight / 45,
                                      ),
                                    ),
                                    RowInfo(
                                        title: 'Delivery : ',
                                        value:
                                            '${state.orderInfo.shippingMethod}'),
                                    if (state.orderInfo.readyTime!=null && state.orderInfo.readyTime.isNotEmpty)
                                      RowInfo(
                                          title: 'Delivery Time : ',
                                          value:
                                              '${state.orderInfo.readyTime}'),
                                    if (state.orderInfo.deliveryAddress!=null && state.orderInfo.deliveryAddress.isNotEmpty)
                                      RowInfo(
                                        title: 'Delivery Address :',
                                        value:
                                            '${Utility.decodeUtf8(state.orderInfo.deliveryAddress)}',
                                        icon: FontAwesomeIcons.mapMarkedAlt,
                                        iconAction: () => Utility.lunchAddress(
                                            context,
                                            Utility.decodeUtf8(state
                                                .orderInfo.deliveryAddress)),
                                      ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state.orderInfoState is ContactLessOrderInfoNetworkError) {
                      return Center(
                        child: Card(
                          margin: EdgeInsets.all(30.0),
                          elevation: 5,
                          color: MainColors.white,
                          child: Padding(
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
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                Consumer<ContactLessOrderInfoProvider>(
                  builder: (context, state, child) {
                    if (state.orderInfoState is ContactLessOrderInfoLoading ||
                        state.orderInfoState is ContactLessOrderInfoInitial) {
                      return LoadingWidget();
                    } else if (state.orderInfoState is ContactLessOrderInfoLogOut) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        context.read<AuthProvider>().signOut(context);
                      });
                      return SizedBox();
                    } else if (state.orderInfoState is ContactLessOrderInfoLoaded) {

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 45,
                            ),
                            Card(
                              margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: screenWidth / 12,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Qty',
                                        style: TextStyle(
                                          color: MainColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenHeight / 55,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth / 1.32,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Item',
                                        style: TextStyle(
                                          color: MainColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenHeight / 55,
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: Container(
                                        width: screenWidth / 6,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Total',
                                          style: TextStyle(
                                            color: MainColors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenHeight / 55,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            for (var item in state.orderInfo.items)
                              Card(
                                margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: screenWidth / 12,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              item['cnt'],
                                              style: TextStyle(
                                                color: MainColors.black,
                                                fontSize: screenHeight / 60,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth / 1.32,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${Utility.decodeUtf8(item['item_name'])}',
                                              style: TextStyle(
                                                color: MainColors.black,
                                                fontSize: screenHeight / 60,
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child: Container(
                                              width: screenWidth / 6,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                item['total'],
                                                style: TextStyle(
                                                  color: MainColors.black,
                                                  fontSize: screenHeight / 60,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if(item['modifiers_name'] != null && item['modifiers_name'].toString().isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: screenWidth / 6,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Options',
                                                style: TextStyle(
                                                  color: MainColors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenHeight / 55,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: screenWidth / 2,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '( ${Utility.decodeUtf8(item['modifiers_name'].toString())} )',
                                                  style: TextStyle(
                                                    color: MainColors.black,
                                                    fontSize: screenHeight / 60,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            Card(
                              margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: screenWidth / 6,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'TOTAL',
                                        style: TextStyle(
                                          color: MainColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenHeight / 55,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: screenWidth / 1.2,
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          state.orderInfo.total,
                                          style: TextStyle(
                                            color: MainColors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenHeight / 55,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state.orderInfoState is ContactLessOrderInfoNetworkError) {
                      return Center(
                        child: Card(
                          margin: EdgeInsets.all(30.0),
                          elevation: 5,
                          color: MainColors.white,
                          child: Padding(
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
                        ),
                      );
                    } else {
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
}
