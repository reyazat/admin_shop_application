import 'package:smartshopadmin/values/Parameters.dart';

class ContactlessProductsModel {
    String desc;
    int id;
    String isVisible;
    int modifiersCnt;
    String name;
    num price;
    String image;

    ContactlessProductsModel({this.desc, this.id, this.isVisible, this.modifiersCnt, this.name, this.price, this.image});

    factory ContactlessProductsModel.fromJson(Map<String, dynamic> json) {
        return ContactlessProductsModel(
            desc: json['desc'] ?? '',
            id: json['id'] ?? 0,
            isVisible: json['is_visible'] != null ? (json['is_visible'] == 'on' ? 'Enabled' : 'Disabled') : '',
            modifiersCnt: json['modifires_cnt'] ?? 0,
            name: json['name'] ?? '',
            price: json['price'] ?? 0,
            image: '${Parameters.contactlessAPI}item/img/${json['id']}?id_company=sv8wmdq3'
        );
    }

}