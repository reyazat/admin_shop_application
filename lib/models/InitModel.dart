class InitModel {
  final bool success;
  final dynamic response;

  InitModel({
    this.success,
    this.response,
  });

  factory InitModel.fromJson(Map<String, dynamic> element) {
    return InitModel(
        success: element["success"] == null || element["success"] == "" ? null : element['success'],
        response:  element["response"] == null || element["response"] == "" ? null : element['response'] );
  }
}
