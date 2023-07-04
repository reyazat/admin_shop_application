import 'dart:convert';

import 'package:intl/intl.dart';

class ContactLessOrderInfoModel {
    int orderId;
    String invoiceId;
    String orderType;
    String createdAt;
    String readyTime;
    String subTotal;
    String total;
    int tableNumber;
    String status;
    String cardType;
    int cardNumber;
    String fName;
    String lName;
    String phone;
    String email;
    String deliveryAddress;
    String shippingMethod;
    List<Map<String,dynamic>> items;

    ContactLessOrderInfoModel({
        this.orderId,
        this.invoiceId,
        this.orderType,
        this.createdAt,
        this.readyTime,
        this.subTotal,
        this.total,
        this.tableNumber,
        this.status,
        this.cardType,
        this.cardNumber,
        this.fName,
        this.lName,
        this.email,
        this.phone,
        this.deliveryAddress,
        this.shippingMethod,
        this.items

    });

    factory ContactLessOrderInfoModel.fromJson(Map<String, dynamic> json) {
        if(json['order_type'] == 'delivery'){
            json['shipping_method'] = 'Delivery';
        }else if(json['order_type'] == 'dine-in'){
            json['shipping_method'] = 'Dine in (Table: ${json['table_number']})';
        }else{
            json['shipping_method'] = 'Collection';
        }

        final f = new DateFormat('MM/dd/yyyy hh:mm');
        List list = jsonDecode(json['items']);

        return ContactLessOrderInfoModel(
            orderId: json['id']??0,
            invoiceId: json['invoice_id']??'',
            orderType: json['order_type']??'',
            createdAt: f.format(DateTime.parse(json['created_at'])),
            readyTime: f.format(DateTime.parse(json['ready_time'])),
            subTotal: '£'+json['subtotal'].toString(),
            total: '£'+json['total'].toString(),
            tableNumber: json['table_number']??0,
            status: json['status']??'',
            cardType: json['card_type']??'',
            cardNumber: json['card_number']??0,
            fName: json['fname']??'',
            lName: json['lname']??'',
            phone: json['phone']??'',
            email: json['email']??'',
            shippingMethod: json['shipping_method']??'',
            deliveryAddress: json['delivery_address']??'',
            items: List<Map<String,dynamic>>.from(list.map((x) => x)),

        );
    }

}