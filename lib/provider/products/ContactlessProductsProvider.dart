import 'package:flutter/material.dart';
import 'package:smartshopadmin/models/ContactlessProductsModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/provider/products/ProductsState.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class ContactlessProductsProvider extends ChangeNotifier {

  ProductsState productsState;
  List<ContactlessProductsModel> _products = [];
  String _searchText = '';
  String _selectedStatus;

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  List<ContactlessProductsModel> get products => _products;

  String get selectedStatus => _selectedStatus;

  set selectedStatus(String value) {
    _selectedStatus = value;
    notifyListeners();
  }

  ContactlessProductsProvider() {
    productsState = ProductsInitial();
    init();
  }

  void init() async {
    NotificationService.dismiss();
    await searchProducts();
  }

  Future<void> searchProducts() async
  {
    productsState = ProductsLoading();
    _products = [];

    await AppNetwork.getContactless('${Parameters.contactlessAPI}menu/1').then((value)
    {
      if(value.status == 'success') {
        value.data.forEach((element) {
          if(element['items'] != null && element['items'].length > 0) {

            element['items'].forEach((item) {
              ContactlessProductsModel productItem = ContactlessProductsModel.fromJson(item);
              _products.add(productItem);
            });

          }
        });

        if(_searchText != '') {
          _products = _products.where((item) => (item.name).toLowerCase().contains(_searchText.toLowerCase())).toList();
        }

        notifyListeners();
      } else {
        ShowMessageService.showErrorMsg(value.message);
      }
    });

    productsState = ProductsLoaded();
  }

  Future<void> editProduct({
    int productId,
    String name,
    num price,
    String isVisible,
  }) async {
    ShowMessageService.showLoading();

    var data = {
      "mode": 'edit',
      "id": productId,
      "name": name,
      "price": price,
      "is_visible": isVisible,
    };

    await AppNetwork.postContactless('${Parameters.contactlessAPI}item', body: data).then((value)
    {
      if(value.status == 'success') {
        searchProducts();
        ShowMessageService.showSuccessMsg(Constants.editProductSuccessMsg);
      } else {
        ShowMessageService.showErrorMsg(value.message);
      }
    });

    ShowMessageService.closeLoading();
  }

}