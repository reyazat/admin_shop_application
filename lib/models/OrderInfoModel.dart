import 'package:smartshopadmin/models/ProductsModel.dart';

class OrderInfoModel {
    String orderId;
    String storeName;
    String storeUrl;
    String invoiceNum;
    String dateAdded;
    String firstName;
    String lastName;
    String customer;
    String customerGroup;
    String email;
    String telePhone;
    String shippingMethod;
    String deliveryTime;
    String paymentMethod;
    String paymentAddress;
    String shippingAddress;
    List<ProductsModel> products;
    List<Map<String,dynamic>> totals;
    String comment;
    String orderStatus;
    String statusColor;
    List<Map<String,dynamic>> orderStatuses;
    String orderStatusId;

    OrderInfoModel({
        this.orderId,
        this.storeName,
        this.storeUrl,
        this.invoiceNum,
        this.dateAdded,
        this.firstName,
        this.lastName,
        this.customer,
        this.customerGroup,
        this.email,
        this.telePhone,
        this.shippingMethod,
        this.deliveryTime,
        this.paymentMethod,
        this.paymentAddress,
        this.shippingAddress,
        this.products,
        this.totals,
        this.comment,
        this.orderStatus,
        this.statusColor,
        this.orderStatusId,
        this.orderStatuses
    });

    factory OrderInfoModel.fromJson(Map<String, dynamic> json) {
        print('Order status : ${json['order_status']}');
        return OrderInfoModel(
            orderId: json['order_id'].toString()??'',
            storeName: json['store_name']??'',
            storeUrl: json['store_url']??'',
            invoiceNum: json['invoice_no']??'',
            dateAdded: json['date_added']??'',
            firstName: json['firstname']??'',
            lastName: json['lastname']??'',
            customer: json['customer'].toString()??'',
            customerGroup: json['customer_group']??'',
            email: json['email']??'',
            telePhone: json['telephone']??'',
            shippingMethod: json['shipping_method']??'',
            deliveryTime: json['delivery_time']??'',
            paymentMethod: json['payment_method']??'',
            paymentAddress: json['payment_address']??'',
            shippingAddress: json['shipping_address']??'',
            products: List<ProductsModel>.from(json["products"].map((i) => ProductsModel.fromJson(i))),
            totals: List<Map<String,dynamic>>.from(json['totals'].map((x) => x)),
            comment: json['comment']??'',
            orderStatus: json['order_status']??'',
            statusColor: json['status_color']??'',
            orderStatuses: List<Map<String,dynamic>>.from(json['order_statuses'].map((x) => x)),
            orderStatusId: json['order_status_id'].toString()??'',
        );
    }

}