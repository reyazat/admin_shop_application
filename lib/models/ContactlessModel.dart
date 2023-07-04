class ContactlessModel {
    List data;
    String status;
    String message;

    ContactlessModel({this.data, this.status, this.message});

    factory ContactlessModel.fromJson(Map<String, dynamic> json) {
        return ContactlessModel(
            data: json['data'] ?? [],
            status: json['status'] ?? '',
            message: json['message'] ?? '',
        );
    }

}