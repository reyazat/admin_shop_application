
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/provider/orders/OrdersProvider.dart';
import 'package:smartshopadmin/provider/orders/OrdersState.dart';
import 'package:smartshopadmin/provider/settings/SettingsHelper.dart';
import 'package:smartshopadmin/screens/OrderInfoScreen.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/ListToRefreshWdget.dart';
import 'package:smartshopadmin/widgets/SelectField.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String dropdownValue = 'Order Num';
  FocusNode _searchFocus = new FocusNode();
  final searchTextController = TextEditingController(text: '');
  Widget clearSearchText = SizedBox(width: 1);

  @override
  void initState() {
    context.read<OrdersProvider>().init();
    _searchFocus.addListener(_onSearchFocusChange);
    super.initState();
  }
  @override
  void dispose() {
    _searchFocus.removeListener(_onSearchFocusChange);
    super.dispose();
  }

  void _onSearchFocusChange() {
    if(_searchFocus.hasFocus) {
      setState(() {
        clearSearchText = GestureDetector(
          child: Icon(FontAwesomeIcons.times,
            color: MainColors.white,
            size: MediaQuery.of(context).size.height / 35,
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            searchTextController.text = '';
            context.read<OrdersProvider>().searchText = '';
            context.read<OrdersProvider>().searchOrders();
          },
        );
      });
    } else {
      setState(() {
        clearSearchText = SizedBox(width: 1);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MainColors.subMainColor,
        foregroundColor: MainColors.subMainColor,
        title: Card(
          elevation: 0,
          margin: EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 20),
          color: MainColors.subMainColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    focusNode: _searchFocus,
                    controller: searchTextController,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.name,
                    onSubmitted: (value) {
                      context.read<OrdersProvider>().searchText = value;
                      context.read<OrdersProvider>().searchOrders();
                    },
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height / 45, color: MainColors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.search,
                        color: MainColors.white,
                        size: MediaQuery.of(context).size.height / 35,
                      ),
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                          color: MainColors.white70,
                          fontSize: MediaQuery.of(context).size.height / 50),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                clearSearchText,
                SizedBox(width: 17),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: SelectField(
                      dropdownItems: <String>['Customer', 'Order Num'],
                      dropdownValue: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          context.read<OrdersProvider>().searchFilter = newValue;
                        });
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

            Consumer<OrdersProvider>(
              builder: (context, state, child) {
                print(state.ordersState);

                if(state.ordersState is OrdersLoading || state.ordersState is OrdersInitial) {
                  ShowMessageService.showLoading();
                  return SizedBox();

                } else if(state.ordersState is OrdersLoaded) {
                  ShowMessageService.closeLoading();
                  return state.ordersList.length == 0
                      ?
                  Center(
                    child: Card(
                      elevation: 5,
                      color: MainColors.white.withOpacity(0.7),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(Constants.noOrders, style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 65),),
                      ),
                    ),
                  )
                      :
                  ListToRefresh(
                    onRefresh: context.read<OrdersProvider>().searchOrders,
                    onLoading:()=> context.read<OrdersProvider>().otherPageOrders(pagePlus: 1),
                    backGround: true,
                    child: ListView.builder(
                      itemCount: state.ordersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: MainColors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 0.5,
                                    )
                                  ],
                                ),
                                child: InkWell(
                                  onTap:(){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderInfo(orderId: state.ordersList[index].orderId),
                                        )
                                    );
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.fileInvoiceDollar,
                                        color:Color(int.parse(state.ordersList[index].statusColor?.substring(1, 7) ?? '000000', radix: 16) + 0xFF000000),
                                        size: MediaQuery.of(context).size.height / 20,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Customer : ',
                                                        style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height /54),

                                                      ),
                                                      TextSpan(
                                                        text: state.ordersList[index].customer,
                                                        style: Styles.textStyle.copyWith(fontSize: MediaQuery.of(context).size.height /55),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Order Number : ',
                                                        style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height /54),

                                                      ),
                                                      TextSpan(
                                                        text: state.ordersList[index].orderId,
                                                        style: Styles.textStyle.copyWith(fontSize: MediaQuery.of(context).size.height /55),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Order Status : ',
                                                        style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height /54),

                                                      ),
                                                      TextSpan(
                                                        text: state.ordersList[index].orderStatus,
                                                        style: Styles.textLargeLabStyle.copyWith(
                                                            color:Color(int.parse(state.ordersList[index].statusColor?.substring(1, 7) ?? '000000', radix: 16) + 0xFF000000),
                                                            fontSize: MediaQuery.of(context).size.height /45),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Delivery : ',
                                                        style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height /54),

                                                      ),
                                                      TextSpan(
                                                        text: state.ordersList[index].shippingMethod,
                                                        style: Styles.textStyle.copyWith(fontSize: MediaQuery.of(context).size.height /55),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Total : ',
                                                        style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height /54),

                                                      ),
                                                      TextSpan(
                                                        text: state.ordersList[index].total,
                                                        style: Styles.textStyle.copyWith(fontSize: MediaQuery.of(context).size.height /55),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Date : ',
                                                        style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height /54),

                                                      ),
                                                      TextSpan(
                                                        text: state.ordersList[index].dateAdded,
                                                        style: Styles.textStyle.copyWith(fontSize: MediaQuery.of(context).size.height /55),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Click to see more details.',
                                                style: Styles.textHintStyle
                                                    .copyWith(
                                                    fontSize: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .height /
                                                        70),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left:8.0),
                                              child: Text(
                                                'Swipe to change status or print.',
                                                style: Styles.textHintStyle
                                                    .copyWith(
                                                    fontSize: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .height /
                                                        70),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios,color: MainColors.mainColor,size: MediaQuery.of(context).size.height / 35,),
                                    ],
                                  ),
                                ),
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Preparing',
                                  color: MainColors.amber,
                                  iconWidget: Icon(FontAwesomeIcons.mortarPestle,
                                    color: MainColors.black,
                                    size: MediaQuery.of(context).size.height / 30,
                                  ),
                                  onTap: () => context.read<OrdersProvider>().changeStatus(index,state.ordersList[index].orderId, 15),
                                ),
                                IconSlideAction(
                                  caption: 'Complete',
                                  color: MainColors.green,
                                  iconWidget: Icon(FontAwesomeIcons.thumbsUp,
                                    color: MainColors.black,
                                    size: MediaQuery.of(context).size.height / 30,
                                  ),
                                  onTap: () => context.read<OrdersProvider>().changeStatus(index,state.ordersList[index].orderId, 5),
                                ),
                                IconSlideAction(
                                  caption: 'Print',
                                  color: MainColors.greyLight,
                                  iconWidget: Icon(FontAwesomeIcons.print,
                                    color: MainColors.black,
                                    size: MediaQuery.of(context).size.height / 30,
                                  ),
                                  onTap: () => SettingsHelper().orderPrint(state.ordersList[index].orderId),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
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

}
