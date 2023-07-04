class ClientsModel {
    String customerGroup;
    String customerId;
    String dateAdded;
    String email;
    String loyaltyCode;
    String rewardPoints;
    String name;
    String status;
    String total;

    ClientsModel({this.customerGroup, this.customerId, this.dateAdded, this.email, this.loyaltyCode, this.rewardPoints, this.name, this.status, this.total});

    factory ClientsModel.fromJson(Map<String, dynamic> json) {
        return ClientsModel(
            customerGroup: json['customer_group'] ?? '',
            customerId: json['customer_id'] ?? '',
            dateAdded: json['date_added'] ?? '',
            email: json['email'] ?? '',
            loyaltyCode: json['loyalty_code'] ?? '',
            rewardPoints: json['reward_points'] ?? '',
            name: json['name'] ?? '',
            status: json['status'] ?? '',
            total: json['total'] ?? '',
        );
    }
}