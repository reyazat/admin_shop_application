import 'package:intl/intl.dart';

class LoyaltyModel {
  static final dateFormatter = DateFormat('y-M-dd');
  final int id;
  final String name;
  final String code;
  final int status;
  final int customerID;
  final double discount;
  final double total;

  LoyaltyModel.fromJson(data)
      : id = int.parse(data['coupon_id']),
        name = data['name'],
        code = data['code'],
        status = data['status'] == 'Enabled' ? 1 : 0,
        discount = double.parse(data['discount']),
        customerID = int.tryParse(data['customer_id'] ?? ''),
        total = double.parse(data['total'].substring(1));

  static List<LoyaltyModel> getListFromJson(data) {
    var list = <LoyaltyModel>[];
    for (var coupon in data) {
      list.add(LoyaltyModel.fromJson(coupon));
    }
    return list;
  }
}
