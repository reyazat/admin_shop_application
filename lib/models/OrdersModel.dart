class OrdersModel {
    String orderId;
    String customer;
    String orderStatus;
    String total;
    String dateAdded;
    String dateModified;
    String shippingCode;
    String shippingMethod;
    String statusColor;

    OrdersModel({this.orderId, this.customer, this.orderStatus, this.total, this.dateAdded, this.dateModified, this.shippingCode, this.shippingMethod,this.statusColor});

    factory OrdersModel.fromJson(Map<String, dynamic> json) {
        return OrdersModel(
            orderId: json['order_id'],
            customer: json['customer'],
            orderStatus: json['order_status'],
            total: json['total'],
            dateAdded: json['date_added'],
            dateModified: json['date_modified'],
            shippingCode: json['shipping_code'],
            shippingMethod: json['shipping_method'],
            statusColor: json['status_color'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['order_id'] = this.orderId;
        data['customer'] = this.customer;
        data['order_status'] = this.orderStatus;
        data['total'] = this.total;
        data['date_added'] = this.dateAdded;
        data['date_modified'] = this.dateModified;
        data['shipping_code'] = this.shippingCode;
        data['shipping_method'] = this.shippingMethod;
        data['status_color'] = this.statusColor;
        return data;
    }
}