import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartshopadmin/helpers/Utility.dart';
import 'package:smartshopadmin/models/ProductsModel.dart';
import 'package:smartshopadmin/provider/Auth/AuthProvider.dart';
import 'package:smartshopadmin/provider/orders/OrderHelper.dart';
import 'package:smartshopadmin/provider/orders/OrderInfoProvider.dart';
import 'package:smartshopadmin/provider/orders/OrdersProvider.dart';
import 'package:smartshopadmin/provider/settings/SettingsHelper.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/LoadingWidget.dart';
import 'package:smartshopadmin/widgets/RowInfo.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OrderInfo extends StatefulWidget {
  static final String routeName = '/OrderInfo';
  final orderId;

  const OrderInfo({Key key, this.orderId}) : super(key: key);

  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo>
    with SingleTickerProviderStateMixin {
  static const _tabCount = 3;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _tabCount, vsync: this);
    context.read<OrderInfoProvider>().init();
    context.read<OrderInfoProvider>().getOrderInfo(widget.orderId);
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
                  .orderInfoPrint(context.read<OrderInfoProvider>().orderInfo),
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
                Consumer<OrderInfoProvider>(
                  builder: (context, state, child) {
                    if (state.orderInfoState is OrderInfoLoading ||
                        state.orderInfoState is OrderInfoInitial) {
                      return LoadingWidget();
                    } else if (state.orderInfoState is OrderInfoLogOut) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        context.read<AuthProvider>().signOut(context);
                      });
                      return SizedBox();
                    } else if (state.orderInfoState is OrderInfoLoaded) {
                      if(state.orderInfo.orderStatus == 'Completed'){
                        state.initToggleSwitch = 1;
                      }
                      if(state.orderInfo.orderStatus == 'Preparing'){
                        state.initToggleSwitch = 0;
                      }
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
                                        value: '${state.orderInfo.orderId}'),
                                    RowInfo(
                                      title: 'Total :',
                                      value: OrderHelper.getTotal(
                                          state.orderInfo.totals),
                                    ),
                                    RowInfo(
                                      title: 'Order Date : ',
                                      value: '${state.orderInfo.dateAdded}',
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
                                            child: Text('${state.orderInfo.orderStatus}',
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

                                            state.changeStatus(index,state.orderInfo.orderId, 5);
                                          }
                                          if(index ==0){
                                            state.changeStatus(index,state.orderInfo.orderId, 15);
                                          }
                                          context.read<OrdersProvider>().searchOrders();
                                        },
                                      ),
                                    ),
                                  ),
                                    if(state.orderInfo.comment.isNotEmpty)
                                    RowInfo(
                                      title: 'Comment : ',
                                      value:
                                          '${Utility.decodeUtf8(state.orderInfo.comment)}',
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
                                            '${Utility.decodeUtf8(state.orderInfo.firstName)}  ${Utility.decodeUtf8(state.orderInfo.lastName)}'),
                                    RowInfo(
                                        title: 'Customer Group : ',
                                        value:
                                            '${state.orderInfo.customerGroup}'),
                                    if(state.orderInfo.email.isNotEmpty)
                                    RowInfo(
                                      title: 'Email :',
                                      value: '${state.orderInfo.email}',
                                      icon: FontAwesomeIcons.envelopeOpenText,
                                      iconAction: () => Utility.lunchMailTo(
                                          context,
                                          email: state.orderInfo.email),
                                    ),
                                    if(state.orderInfo.telePhone.isNotEmpty)
                                    SizedBox(
                                      height: 20,
                                    ),
                                    if(state.orderInfo.telePhone.isNotEmpty)
                                    RowInfo(
                                      title: 'Phone :',
                                      value: '${state.orderInfo.telePhone}',
                                      icon: FontAwesomeIcons.phone,
                                      iconAction: () => Utility.lunchCall(
                                          context, state.orderInfo.telePhone),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state.orderInfoState is OrderInfoNetworkError) {
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
                Consumer<OrderInfoProvider>(
                  builder: (context, state, child) {
                    if (state.orderInfoState is OrderInfoLoading ||
                        state.orderInfoState is OrderInfoInitial) {
                      return LoadingWidget();
                    } else if (state.orderInfoState is OrderInfoLogOut) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        context.read<AuthProvider>().signOut(context);
                      });
                      return SizedBox();
                    } else if (state.orderInfoState is OrderInfoLoaded) {
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
                                            '${state.orderInfo.paymentMethod}'),
                                    RowInfo(
                                      title: 'Total :',
                                      value: OrderHelper.getTotal(
                                          state.orderInfo.totals),
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
                                    if (state.orderInfo.deliveryTime.isNotEmpty)
                                      RowInfo(
                                          title: 'Delivery Time : ',
                                          value:
                                              '${state.orderInfo.deliveryTime}'),
                                    if (state
                                        .orderInfo.shippingAddress.isNotEmpty)
                                      RowInfo(
                                        title: 'Delivery Address :',
                                        value:
                                            '${Utility.decodeUtf8(state.orderInfo.shippingAddress)}',
                                        icon: FontAwesomeIcons.mapMarkedAlt,
                                        iconAction: () => Utility.lunchAddress(
                                            context,
                                            Utility.decodeUtf8(state
                                                .orderInfo.shippingAddress)),
                                      ),
                                    if (state.orderInfo.telePhone.isNotEmpty)
                                      SizedBox(
                                        height: 20,
                                      ),
                                    if (state.orderInfo.telePhone.isNotEmpty)
                                      RowInfo(
                                        title: 'Customer Phone :',
                                        value: '${state.orderInfo.telePhone}',
                                        icon: FontAwesomeIcons.phone,
                                        iconAction: () => Utility.lunchCall(
                                            context, state.orderInfo.telePhone),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state.orderInfoState is OrderInfoNetworkError) {
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
                Consumer<OrderInfoProvider>(
                  builder: (context, state, child) {
                    if (state.orderInfoState is OrderInfoLoading ||
                        state.orderInfoState is OrderInfoInitial) {
                      return LoadingWidget();
                    } else if (state.orderInfoState is OrderInfoLogOut) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        context.read<AuthProvider>().signOut(context);
                      });
                      return SizedBox();
                    } else if (state.orderInfoState is OrderInfoLoaded) {

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
                                      width: screenWidth / 1.7,
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
                                    Container(
                                      width: screenWidth / 6,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Price',
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
                            for (ProductsModel item in state.orderInfo.products)
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
                                              item.quantity,
                                              style: TextStyle(
                                                color: MainColors.black,
                                                fontSize: screenHeight / 60,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth / 1.7,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${Utility.decodeUtf8(item.name)}',
                                              style: TextStyle(
                                                color: MainColors.black,
                                                fontSize: screenHeight / 60,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth / 6,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              item.price,
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
                                                item.total,
                                                style: TextStyle(
                                                  color: MainColors.black,
                                                  fontSize: screenHeight / 60,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if(OrderHelper.getOptions(item.option).isNotEmpty)
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
                                                  '( ${OrderHelper.getOptions(item.option)} )',
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
                                          OrderHelper.getSubTotal(state.orderInfo.totals),
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
                    } else if (state.orderInfoState is OrderInfoNetworkError) {
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
