import 'package:intl/intl.dart';

class CouponModel {
  static final dateFormatter = DateFormat('y-M-dd');
  final int id;
  final String name;
  final String code;
  final int shipping;
  final int status;
  final int logged;
  final int totalUse;
  final int customerUse;
  final DateTime startDate;
  final DateTime endDate;
  final double discount;
  final double total;

  CouponModel.fromJson(data)
      : id = int.parse(data['coupon_id']),
        name = data['name'],
        code = data['code'],
        shipping = int.parse(data['shipping']),
        status = data['status'] == 'Enabled' ? 1 : 0,
        logged = int.parse(data['logged']),
        totalUse = int.parse(data['uses_total']),
        customerUse = int.parse(data['uses_customer']),
        startDate = dateFormatter.parse(data['date_start']),
        endDate = dateFormatter.parse(data['date_end']),
        discount = double.parse(data['discount']),
        total = double.parse(data['total'].substring(1));

  static List<CouponModel> getListFromJson(data) {
    var list = <CouponModel>[];
    for (var coupon in data) {
      list.add(CouponModel.fromJson(coupon));
    }
    return list;
  }
}
