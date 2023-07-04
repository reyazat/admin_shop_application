import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/helpers/Utility.dart';
import 'package:smartshopadmin/models/ProductsModel.dart';
import 'package:smartshopadmin/provider/products/ProductsProvider.dart';
import 'package:smartshopadmin/provider/products/ProductsState.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/DropdownField.dart';
import 'package:smartshopadmin/widgets/EditDialogWidget.dart';
import 'package:smartshopadmin/widgets/InputBuildWidget.dart';
import 'package:smartshopadmin/widgets/ListToRefreshWdget.dart';
import 'package:smartshopadmin/widgets/ProductInfo.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  FocusNode _searchFocus = new FocusNode();
  final searchTextController = TextEditingController(text: '');
  Widget clearSearchText = SizedBox(width: 1);

  @override
  void initState() {
    context.read<ProductsProvider>().init();
    super.initState();

    _searchFocus.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    _searchFocus.removeListener(_onSearchFocusChange);
    _searchFocus.dispose();
    searchTextController.dispose();
    _nameInput.controller.dispose();
    _priceInput.controller.dispose();
    _quantityInput.controller.dispose();
    _pointsInput.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MainColors.subMainColor,
        foregroundColor: MainColors.white,
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
                      context.read<ProductsProvider>().searchText = value;
                      context.read<ProductsProvider>().searchProducts();
                    },
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height / 45, color: MainColors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.search,
                        color: MainColors.white,
                        size: MediaQuery.of(context).size.height / 35,
                      ),
                      hintText: 'Search by name...',
                      hintStyle: TextStyle(
                          color: MainColors.white,
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
            Consumer<ProductsProvider>(
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
                    onRefresh: context.read<ProductsProvider>().searchProducts,
                    onLoading: context.read<ProductsProvider>().loadingPageProducts,
                    backGround: false,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: screenWidth / 2,
                          childAspectRatio: 0.60,
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
                                  height: screenHeight /5,
                                  child: CachedNetworkImage(
                                      imageUrl: state.products[index].image??'',
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
                                          style: Styles.textLabStyle.copyWith(fontSize: screenHeight / 59),
                                        ),
                                        ProductInfo(title: 'Price', value: state.products[index].price),
                                        ProductInfo(title: 'Quantity', value: state.products[index].quantity),
                                        ProductInfo(title: 'Status', value: state.products[index].status),
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
            context.read<ProductsProvider>().searchText = '';
            context.read<ProductsProvider>().searchProducts();
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

  InputBuildWidget _quantityInput = InputBuildWidget(
    hint: 'Quantity',
    label: 'Quantity',
    inputType: TextInputType.numberWithOptions(signed: true, decimal: true),
  );

  InputBuildWidget _pointsInput = InputBuildWidget(
    hint: 'Points',
    label: 'Points',
    inputType: TextInputType.numberWithOptions(signed: true, decimal: true),
  );

  _editProduct(ProductsModel product) {
    String title = 'Edit Product';

    _nameInput.controller.text = Utility.decodeUtf8(product.name);
    _priceInput.controller.text = product.price;
    _quantityInput.controller.text = product.quantity;
    _pointsInput.controller.text = product.points;
    context.read<ProductsProvider>().selectedStatus = product.status;

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
                _quantityInput,
                SizedBox(height: 20),
                _pointsInput,
                SizedBox(height: 20),
                DropdownField(
                  selectedValue: context.read<ProductsProvider>().selectedStatus,
                  items: ['Enabled', 'Disabled'],
                  onChanged: (value) => context.read<ProductsProvider>().selectedStatus = value,
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
                  Utility.isEmpty(_priceInput.controller.text) != null ||
                  Utility.isEmpty(_quantityInput.controller.text) != null ||
                  Utility.isEmpty(_pointsInput.controller.text) != null) {
                ShowMessageService.showErrorMsg('All fields is required.');
                return null;
              }

              await context.read<ProductsProvider>().editProduct(
                productId: product.productId,
                name: _nameInput.controller.text,
                quantity: _quantityInput.controller.text,
                points: _pointsInput.controller.text,
                price: _priceInput.controller.text,
                status: context.read<ProductsProvider>().selectedStatus == 'Enabled' ? 1 : 0,
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
