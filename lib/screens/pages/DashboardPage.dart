
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/helpers/Utility.dart';
import 'package:smartshopadmin/models/ContactlessProductsModel.dart';
import 'package:smartshopadmin/provider/orders/ContactLessOrdersProvider.dart';
import 'package:smartshopadmin/provider/orders/ContactLessOrdersState.dart';
import 'package:smartshopadmin/provider/products/ContactlessProductsProvider.dart';
import 'package:smartshopadmin/provider/products/ProductsState.dart';
import 'package:smartshopadmin/provider/settings/SettingsHelper.dart';
import 'package:smartshopadmin/screens/ContactLessOrderInfoScreen.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/DropdownField.dart';
import 'package:smartshopadmin/widgets/EditDialogWidget.dart';
import 'package:smartshopadmin/widgets/InputBuildWidget.dart';
import 'package:smartshopadmin/widgets/ListToRefreshWdget.dart';
import 'package:smartshopadmin/widgets/ProductInfo.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {

  FocusNode _searchFocus = new FocusNode();
  final searchTextController = TextEditingController(text: '');
  Widget clearSearchText = SizedBox(width: 1);
  TabController _tabController;
  String _hint = 'Search by order number';

  @override
  void initState() {
    context.read<ContactLessOrdersProvider>().init();
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _searchFocus.addListener(_onSearchFocusChange);
  }
  @override
  void dispose() {
    _tabController.dispose();
    _searchFocus.removeListener(_onSearchFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
                      if(_tabController.index == 0) {
                        context.read<ContactLessOrdersProvider>().searchText = value;
                        context.read<ContactLessOrdersProvider>().searchOrders();
                      } else {
                        context.read<ContactlessProductsProvider>().searchText = value;
                        context.read<ContactlessProductsProvider>().searchProducts();
                      }
                    },
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height / 45, color: MainColors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.search,
                        color: MainColors.white,
                        size: MediaQuery.of(context).size.height / 35,
                      ),
                      hintText: _hint,
                      hintStyle: TextStyle(
                          color: MainColors.white70,
                          fontSize: MediaQuery.of(context).size.height / 50),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                clearSearchText,
              ],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: (int){
            setState(() {
              if(int == 0) {
                _hint = 'Search by order number';
              } else {
                _hint = 'Search by product name';
              }
            });
          },
          indicatorColor: MainColors.white,
          labelPadding: EdgeInsets.symmetric(horizontal: screenWidth / 13),
          labelStyle: TextStyle(
              fontSize: screenHeight / 55, fontWeight: FontWeight.bold),
          tabs: <Widget>[
            Tab(text: 'Orders'),
            Tab(text: 'Products'),
          ],
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

            TabBarView(
              controller: _tabController,
              children: [
                Consumer<ContactLessOrdersProvider>(
                  builder: (context, state, child) {
                    if(state.contactLessOrdersState is ContactLessOrdersLoading || state.contactLessOrdersState is ContactLessOrdersInitial) {
                      ShowMessageService.showLoading();
                      return SizedBox();

                    } else if(state.contactLessOrdersState is ContactLessOrdersLoaded) {
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
                        onRefresh: context.read<ContactLessOrdersProvider>().searchOrders,
                        onLoading:()=> context.read<ContactLessOrdersProvider>().loadingPage(),
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
                                              builder: (context) => ContactLessOrderInfo(orderId: state.ordersList[index].orderId),
                                            )
                                        );
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.fileInvoiceDollar,
                                            color:Color(int.parse(state.ordersList[index].statusColor.substring(1, 7), radix: 16) + 0xFF000000),
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
                                                            text: state.ordersList[index].email,
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
                                                            text: state.ordersList[index].invoiceId,
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
                                                                color:Color(int.parse(state.ordersList[index].statusColor.substring(1, 7), radix: 16) + 0xFF000000),
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
                                                            text: state.ordersList[index].createdAt,
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
                                      onTap: () => context.read<ContactLessOrdersProvider>().changeStatus(index,state.ordersList[index].orderId, 'Preparing'),
                                    ),
                                    IconSlideAction(
                                      caption: 'Complete',
                                      color: MainColors.green,
                                      iconWidget: Icon(FontAwesomeIcons.thumbsUp,
                                        color: MainColors.black,
                                        size: MediaQuery.of(context).size.height / 30,
                                      ),
                                      onTap: () => context.read<ContactLessOrdersProvider>().changeStatus(index,state.ordersList[index].orderId, 'Completed'),
                                    ),
                                    IconSlideAction(
                                      caption: 'Print',
                                      color: MainColors.greyLight,
                                      iconWidget: Icon(FontAwesomeIcons.print,
                                        color: MainColors.black,
                                        size: MediaQuery.of(context).size.height / 30,
                                      ),
                                      onTap: () => SettingsHelper().contactLessOrderPrint(state.ordersList[index].orderId),
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
                Consumer<ContactlessProductsProvider>(
                  builder: (context, state, child) {
                    print(state.productsState);

                    if(state.productsState is ProductsLoading || state.productsState is ProductsInitial) {
                      ShowMessageService.showLoading();
                      return SizedBox();

                    } else if(state.productsState is ProductsLoaded) {
                      ShowMessageService.closeLoading();
                      return state.products.length == 0
                          ?
                      Center(
                        child: Card(
                          elevation: 5,
                          color: MainColors.white.withOpacity(0.7),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(Constants.notFoundProducts,
                              style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 65),
                            ),
                          ),
                        ),
                      )
                          :
                      ListToRefresh(
                        onRefresh: context.read<ContactlessProductsProvider>().searchProducts,
                        backGround: false,
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: screenWidth / 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15
                          ),
                          itemCount: state.products.length,
                          itemBuilder: (context, int index) {
                            return GestureDetector(
                              onTap: () => _editProduct(state.products[index]),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: MainColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: MainColors.grey.withAlpha(100),
                                      offset: Offset(2, 4),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: screenHeight /6,
                                      child: CachedNetworkImage(
                                        imageUrl: state.products[index].image,
                                        imageBuilder: (context, imageProvider) => InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: MainColors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => _circleBox(context, CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => _circleBox(context, Icon(Icons.error)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(Utility.decodeUtf8(state.products[index].name),maxLines: 2,
                                              style: Styles.textLabStyle.copyWith(fontSize: screenHeight / 60),
                                            ),
                                            ProductInfo(title: 'Price', value: state.products[index].price.toString()),
                                            ProductInfo(title: 'Status', value: state.products[index].isVisible),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
          ],
        ),
      ),
    );
  }

  Widget _circleBox(context, child) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MainColors.subMainColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: MainColors.grey.withAlpha(100),
            offset: Offset(2, 4),
            blurRadius: 10,
          )
        ],
      ),
      child: child,
    );
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

            if(_tabController.index == 0) {
              context.read<ContactLessOrdersProvider>().searchText = '';
              context.read<ContactLessOrdersProvider>().searchOrders();
            } else {
              context.read<ContactlessProductsProvider>().searchText = '';
              context.read<ContactlessProductsProvider>().searchProducts();
            }
          },
        );
      });
    } else {
      setState(() {
        clearSearchText = SizedBox(width: 1);
      });
    }
  }

  InputBuildWidget _nameInput = InputBuildWidget(
    hint: 'Name',
    label: 'Name',
    inputType: TextInputType.name,
  );

  InputBuildWidget _priceInput = InputBuildWidget(
    hint: 'Price',
    label: 'Price',
    inputType: TextInputType.numberWithOptions(signed: true, decimal: true),
  );

  _editProduct(ContactlessProductsModel product) {
    String title = 'Edit Product';

    _nameInput.controller.text = Utility.decodeUtf8(product.name);
    _priceInput.controller.text = product.price.toString();
    context.read<ContactlessProductsProvider>().selectedStatus = product.isVisible;

    showCupertinoModalPopup(
        context: context,
        builder: (_) => EditDialogWidget(
            title:Text(title),
            content: Column(
              children: [
                _nameInput,
                SizedBox(height: 20),
                _priceInput,
                SizedBox(height: 20),
                DropdownField(
                  selectedValue: context.read<ContactlessProductsProvider>().selectedStatus,
                  items: ['Enabled', 'Disabled'],
                  onChanged: (value) => context.read<ContactlessProductsProvider>().selectedStatus = value,
                  labelText: 'Status',
                  hintText: 'Status',
                ),
              ],
            ),
            childYes: Text("Save",
              style: Styles.textActionStyle.copyWith(color: MainColors.blueAction, fontSize: MediaQuery.of(context).size.height / 50),
            ),
            onPressYes: () async {
              if(Utility.isEmpty(_nameInput.controller.text) != null ||
                  Utility.isEmpty(_priceInput.controller.text) != null) {
                ShowMessageService.showErrorMsg('All fields is required.');
                return null;
              }

              await context.read<ContactlessProductsProvider>().editProduct(
                productId: product.id,
                name: _nameInput.controller.text,
                price: double.parse(_priceInput.controller.text),
                isVisible: context.read<ContactlessProductsProvider>().selectedStatus == 'Enabled' ? 'on' : 'off',
              );

              Navigator.pop(context);
            },
            onPressNo: () => Navigator.pop(context),
            childNo: Text("Cancel",
              style: Styles.textActionStyle.copyWith(color: MainColors.redAction, fontSize: MediaQuery.of(context).size.height / 50),
            )
        )
    );
  }

}
