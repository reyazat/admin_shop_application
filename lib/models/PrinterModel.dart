class PrinterModel {
  String name;
  String ip;
  int port;
  bool checked;


  PrinterModel({
    this.name,
    this.ip,
    this.port,
    this.checked
  });

  factory PrinterModel.fromJson(Map<String, dynamic> element) {
    return PrinterModel(
        name: element["name"] == null || element["name"] == "" ? null : element['name'],
        ip: element["ip"] == null || element["ip"] == "" ? null : element['ip'],
        port: element["port"] == null || element["port"] == "" ? null : element['port'],
        checked: element["checked"] == null || element["checked"] == "" ? false : element['checked']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "name": this.name,
      "ip": this.ip,
      "port": this.port,
      "checked": this.checked,
    };
  }

}
