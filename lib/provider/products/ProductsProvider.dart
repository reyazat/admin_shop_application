import 'package:flutter/material.dart';
import 'package:smartshopadmin/models/ProductsModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/provider/products/ProductsState.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class ProductsProvider extends ChangeNotifier {

  ProductsState productsState;
  List<ProductsModel> _products = [];
  int _page = 1;
  String _searchText = '';
  String _selectedStatus;

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  List<ProductsModel> get products => _products;

  String get selectedStatus => _selectedStatus;

  set selectedStatus(String value) {
    _selectedStatus = value;
    notifyListeners();
  }

  ProductsProvider() {
    productsState = ProductsInitial();
    init();
  }

  void init() async {
    NotificationService.dismiss();
    await searchProducts();
  }

  Future<void> _fetchProducts() async
  {
    var data = {
      "filter_name": _searchText,
      "sort": "c.date_added",
      "order": "DESC",
      "page": _page,
    };

    await AppNetwork.postData('${Parameters.hostAPI}myapi/products', body: data).then((value)
    {
      if(value.success == true) {
        value.response['products'].forEach((element) {
          ProductsModel productItem = ProductsModel.fromJson(element);
          _products.add(productItem);
        });

        notifyListeners();
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
    });
  }

  Future<void> searchProducts() async
  {
    productsState = ProductsLoading();
    _page = 1;
    _products = [];

    await _fetchProducts();
    productsState = ProductsLoaded();
  }

  void loadingPageProducts() async
  {
    _page++;
    await _fetchProducts();
  }

  Future<void> editProduct({
    String productId,
    String name,
    String quantity,
    String points,
    String price,
    int status,
  }) async {
    ShowMessageService.showLoading();

    var data = {
      "product_id": productId,
      "name": name,
      "quantity": quantity,
      "points": points,
      "price": price,
      "status": status,
    };

    await AppNetwork.postData('${Parameters.hostAPI}myapi/products/add_editproduct', body: data).then((value)
    {
      if(value.success == true) {
        searchProducts();
        ShowMessageService.showSuccessMsg(Constants.editProductSuccessMsg);
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
    });

    ShowMessageService.closeLoading();
  }

}