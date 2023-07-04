import 'package:smartshopadmin/helpers/Utility.dart';

class OrderHelper{

  static String getTotal(List<Map<String,dynamic>> totals){
    String total = '£0.00';
    for(var item in totals){
      if(item['title'] =='Total')
        total = item['text'].toString();
    }
    return total;
  }

  static String getSubTotal(List<Map<String,dynamic>> totals){
    String total = '£0.00';
    for(var item in totals){
      if(item['title'] =='Sub-Total')
        total = item['text'].toString();
    }
    return total;
  }
  static String getOptions(List<Map<String,dynamic>> options){
    String optionsST = '';
    if(options.length > 0) {
      for (var opt in options) {
        optionsST = (optionsST.length > 0 ? (optionsST + ", ") : optionsST) + (Utility.decodeUtf8(opt['value']) ?? " ");
      }
    }
    return optionsST;
  }


}