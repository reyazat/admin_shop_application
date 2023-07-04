class ClientsInfoModel {
    String cancelled;
    String completed;
    String customerGroup;
    String customerId;
    String dateAdded;
    String email;
    String firstname;
    String lastname;
    String loyaltyCode;
    String processing;
    String quantity;
    String rewardPoints;
    String telephone;
    String total;
    List<ClientOrdersModel> orders;

    ClientsInfoModel({this.cancelled, this.completed, this.customerGroup, this.customerId, this.dateAdded, this.email, this.firstname,
        this.lastname, this.loyaltyCode, this.processing, this.quantity, this.rewardPoints, this.telephone, this.total, this.orders});

    factory ClientsInfoModel.fromJson(Map<String, dynamic> json) {
        return ClientsInfoModel(
            cancelled: json['cancelled'] ?? '',
            completed: json['completed'] ?? '',
            customerGroup: json['customer_group'] ?? '',
            customerId: json['customer_id'] ?? '',
            dateAdded: json['date_added'] ?? '',
            email: json['email'] ?? '',
            firstname: json['firstname'] ?? '',
            lastname: json['lastname'] ?? '',
            loyaltyCode: json['loyalty_code'] ?? '',
            processing: json['processing'] ?? '',
            quantity: json['quantity'] ?? '',
            rewardPoints: json['reward_points'] ?? '',
            telephone: json['telephone'] ?? '',
            total: json['total'] ?? '',
            orders: json['orders'] != null ? (json['orders'] as List).map((i) => ClientOrdersModel.fromJson(i)).toList() : [],
        );
    }
}

class ClientOrdersModel {
    int customerId;
    String dateAdded;
    String orderId;
    String orderNumber;
    String status;
    String total;

    ClientOrdersModel({this.customerId, this.dateAdded, this.orderId, this.orderNumber, this.status, this.total});

    factory ClientOrdersModel.fromJson(Map<String, dynamic> json) {
    return ClientOrdersModel(
      customerId: json['customer_id'] ?? '',
      dateAdded: json['date_added'] ?? '',
      orderId: json['order_id'] ?? '',
      orderNumber: json['order_number'] ?? '',
      status: json['status'] ?? '',
      total: json['total'] ?? '',
    );
  }
}

class RewardPointsModel {
    String customerId;
    String dateAdded;
    String description;
    String id;
    String points;

    RewardPointsModel({this.customerId, this.dateAdded, this.description, this.id, this.points});

    factory RewardPointsModel.fromJson(Map<String, dynamic> json) {
        return RewardPointsModel(
            customerId: json['customer_id'],
            dateAdded: json['date_added'],
            description: json['description'],
            id: json['id'],
            points: json['points'],
        );
    }
}