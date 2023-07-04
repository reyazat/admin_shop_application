import 'package:intl/intl.dart';

class ContactLessOrdersModel {
    int orderId;
    String invoiceId;
    String orderType;
    String createdAt;
    String orderStatus;
    int tableNumber;
    String shippingMethod;
    String total;
    String email;
    String statusColor;

    ContactLessOrdersModel({this.orderId, this.invoiceId, this.orderType, this.createdAt, this.orderStatus, this.tableNumber, this.shippingMethod, this.total, this.email,this.statusColor});

    factory ContactLessOrdersModel.fromJson(Map<String, dynamic> json) {
        if(json['order_type'] == 'delivery'){
            json['shipping_method'] = 'Delivery';
        }else if(json['order_type'] == 'dine-in'){
            json['shipping_method'] = 'Dine in (Table: ${json['table_number']})';
        }else{
            json['shipping_method'] = 'Collection';
        }

        final f = new DateFormat('MM/dd/yyyy hh:mm');

        return ContactLessOrdersModel(
            orderId: json['id']??0,
            invoiceId: json['invoice_id']??'',
            orderType: json['order_type']??'',
            createdAt: f.format(DateTime.parse(json['created_at'].toString())),
            orderStatus: json['status']??'',
            tableNumber: json['table_number']??0,
            shippingMethod: json['shipping_method']??'',
            total: '£'+json['total'].toString(),
            email: json['email']??'',
            statusColor: json['status_color']??'',
        );
    }

}