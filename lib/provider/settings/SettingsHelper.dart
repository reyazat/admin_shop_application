import 'dart:typed_data';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:image/image.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartshopadmin/helpers/Utility.dart';
import 'package:smartshopadmin/models/ContactLessOrderInfoModel.dart';
import 'package:smartshopadmin/models/OrderInfoModel.dart';
import 'package:smartshopadmin/models/PrinterModel.dart';
import 'package:smartshopadmin/models/ProductsModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/provider/orders/OrderHelper.dart';
import 'package:smartshopadmin/services/LoggerService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';


class SettingsHelper{

  static savePrinter(List<PrinterModel> devices) async {
    String printers;
    if(devices != null && devices.length != 0){
      printers = jsonEncode(devices);
    }
    print('******-------*******');
    print(printers);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(printers != null)  preferences.setString("printers", printers) ;

  }

  static Future<List<PrinterModel>> getPrinters() async {
    String printers;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    printers = preferences.getString("printers");
    print('*************');
    print(printers);
    if(printers !=null && printers.isNotEmpty){
      List list = jsonDecode(printers);
      return list.map((i) => PrinterModel.fromJson(i)).toList();
    }
    else return [];
  }

  static Future<List<PrinterModel>> getActivePrinters() async {
    String printers;
    List<PrinterModel> res= [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    printers = preferences.getString("printers");
    if(printers !=null && printers.isNotEmpty){
      List list = jsonDecode(printers);
      for(var item in list) {
        if(item['checked'] == true)
          res.add(PrinterModel.fromJson(item));
        else continue;
      }
    }
    return res;
  }

  void testPrint(PrinterModel device) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final PosPrintResult res = await printer.connect(device.ip, port: device.port);
    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      await printDemoReceipt(printer);
      printer.disconnect();
    }
  }

  Future<void> printDemoReceipt(NetworkPrinter printer) async {
    printer.beep(n: 1,duration: PosBeepDuration.beep50ms);
    // Print image
    final ByteData data = await rootBundle.load('assets/images/printerlogo.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    printer.image(image);

    printer.text(Constants.printerTitle,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    printer.text('200 Kilburn High Road', styles: PosStyles(align: PosAlign.center));
    printer.text('NW6 4JD London',
        styles: PosStyles(align: PosAlign.center));
    printer.text('Phone: ${Constants.phone}',
        styles: PosStyles(align: PosAlign.center));
    printer.text('Web: ${Constants.webAddress}',
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    printer.text('Test Receipt',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    printer.hr();
    printer.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 7),
      PosColumn(
          text: 'Price', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    printer.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'Flat White', width: 7),
      PosColumn(
          text: '2.80', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '2.80', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: '', width: 1),
      PosColumn(text: '( Whole milk, Without flavours )', width: 11, styles: PosStyles(reverse:true)),
    ]);
    printer.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'Americano', width: 7),
      PosColumn(
          text: '2.60', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '2.60', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: '', width: 1),
      PosColumn(text: '( Double, Whole milk, Honeycomb syrup )', width: 11, styles: PosStyles(reverse:true)),
    ]);
    printer.hr();

    printer.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: '£5.40',
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            codeTable: 'CP1252',
          )),
    ]);

    printer.hr(ch: '=', linesAfter: 1);

    // printer.row([
    //   PosColumn(
    //       text: 'Cash',
    //       width: 8,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    //   PosColumn(
    //       text: '\$15.00',
    //       width: 4,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    // ]);
    // printer.row([
    //   PosColumn(
    //       text: 'Change',
    //       width: 8,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    //   PosColumn(
    //       text: '\$4.03',
    //       width: 4,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    // ]);

    //printer.feed(2);
    printer.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.text(timestamp,
        styles: PosStyles(align: PosAlign.center), linesAfter: 2);

    // Print QR Code from image
    // try {
    //   const String qrData = 'example.com';
    //   const double qrSize = 200;
    //   final uiImg = await QrPainter(
    //     data: qrData,
    //     version: QrVersions.auto,
    //     gapless: false,
    //   ).toImageData(qrSize);
    //   final dir = await getTemporaryDirectory();
    //   final pathName = '${dir.path}/qr_tmp.png';
    //   final qrFile = File(pathName);
    //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
    //   final img = decodeImage(imgFile.readAsBytesSync());
    //
    //   //printer.image(img);
    // } catch (e) {
    //   print(e);
    // }

    //Print QR Code using native function
    printer.qrcode(Constants.webAddress);

    printer.feed(1);
    printer.beep(n: 3,duration: PosBeepDuration.beep50ms);
    printer.cut();
  }


  void orderInfoPrint(OrderInfoModel response) async {
    ShowMessageService.showLoading();
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final List<PrinterModel> device = await getActivePrinters();
    if(device.length == 0){
      ShowMessageService.closeLoading();
      ShowMessageService.showErrorMsg(Constants.selectPrinter);
      return null;
    }
    for(var item in device ){
      final PosPrintResult res = await printer.connect(item.ip, port: item.port);
      if (res == PosPrintResult.success) {
        await printOrderReceipt(printer,response);
        printer.disconnect();
      }
    }
    ShowMessageService.closeLoading();
  }

  void contactLessOrderInfoPrint(ContactLessOrderInfoModel response) async {
    ShowMessageService.showLoading();
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final List<PrinterModel> device = await getActivePrinters();
    if(device.length == 0){
      ShowMessageService.closeLoading();
      ShowMessageService.showErrorMsg(Constants.selectPrinter);
      return null;
    }
    for(var item in device ){
      final PosPrintResult res = await printer.connect(item.ip, port: item.port);
      if (res == PosPrintResult.success) {
        await printContactLessOrderReceipt(printer,response);
        printer.disconnect();
      }
    }
    ShowMessageService.closeLoading();
  }

  void orderPrint(String orderId) async {
    ShowMessageService.showLoading();
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final List<PrinterModel> device = await getActivePrinters();
    if(device.length == 0){
      ShowMessageService.closeLoading();
      ShowMessageService.showErrorMsg(Constants.selectPrinter);
      return null;
    }

    await AppNetwork().getOrderInfo({"order_id":"$orderId"}).then((response) async {
      for(var item in device ){
        final PosPrintResult res = await printer.connect(item.ip, port: item.port);
        if (res == PosPrintResult.success) {
          await printOrderReceipt(printer,response);
          printer.disconnect();
        }
      }
      ShowMessageService.closeLoading();
    }).catchError((error) {
      ShowMessageService.closeLoading();
      LoggerService.logger.e(error);
    });

  }


  void contactLessOrderPrint(int orderId) async {
    ShowMessageService.showLoading();
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final List<PrinterModel> device = await getActivePrinters();
    if(device.length == 0){
      ShowMessageService.closeLoading();
      ShowMessageService.showErrorMsg(Constants.selectPrinter);
      return null;
    }

    await AppNetwork().getContactLessOrderInfo(orderId).then((response) async {
      for(var item in device ){
        final PosPrintResult res = await printer.connect(item.ip, port: item.port);
        if (res == PosPrintResult.success) {
          await printContactLessOrderReceipt(printer,response);
          printer.disconnect();
        }
      }
      ShowMessageService.closeLoading();
    }).catchError((error) {
      ShowMessageService.closeLoading();
      LoggerService.logger.e(error);
    });

  }

  Future<void> printOrderReceipt(NetworkPrinter printer,OrderInfoModel response) async {
    printer.beep(n: 1,duration: PosBeepDuration.beep50ms);
    // Print image
    final ByteData data = await rootBundle.load('assets/images/printerlogo.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    printer.image(image);

    printer.text(response.storeName,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          fontType: PosFontType.fontA
        ),
        linesAfter: 1);
    printer.hr(linesAfter:1);
    if(response.firstName.isNotEmpty || response.lastName.isNotEmpty)
    printer.text('Customer : ${Utility.decodeUtf8(response.firstName)} ${Utility.decodeUtf8(response.lastName)}', styles: PosStyles(align: PosAlign.left,bold: true,fontType: PosFontType.fontA),linesAfter: 1);
    if(response.telePhone.isNotEmpty)
    printer.text('Customer Phone : ${response.telePhone}', styles: PosStyles(align: PosAlign.left,bold: true,fontType: PosFontType.fontA),linesAfter: 1);
    printer.text('Order Date : ${response.dateAdded}', styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),linesAfter: 1);
    printer.text('${response.shippingMethod}', styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontB,height: PosTextSize.size2,width: PosTextSize.size2,),
        linesAfter: 1);
    if((!response.shippingMethod.contains('Dine')) && response.deliveryTime.isNotEmpty)
    printer.text('Delivery Time : ${response.deliveryTime}', styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),linesAfter: 1);

    printer.text('Order Num : #${response.orderId}', styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontB,height: PosTextSize.size2,width: PosTextSize.size2,),
        linesAfter: 1);
    if(response.comment.isNotEmpty)
    printer.text('Customer Comment : ${Utility.decodeUtf8(response.comment)}', styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),linesAfter: 1);

    printer.hr(ch: '=', linesAfter: 1);

    printer.row([
      PosColumn(text: 'Qty', width: 1,styles: PosStyles(fontType: PosFontType.fontA),),
      PosColumn(text: '', width: 1,styles: PosStyles(fontType: PosFontType.fontA),),
      PosColumn(text: 'Item', width: 10,styles: PosStyles(fontType: PosFontType.fontA),),
    ]);
    printer.feed(1);
    int inx = 0;
    for(ProductsModel item in response.products){
      inx++;
      printer.row([
        PosColumn(text: '${item.quantity}', width: 1,styles: PosStyles(fontType: PosFontType.fontA)),
        PosColumn(text: '*', width: 1,styles: PosStyles(fontType: PosFontType.fontA)),
        PosColumn(text: '${item.name}', width: 10,styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontB,height: PosTextSize.size2,width: PosTextSize.size2,),),
      ]);
      printer.feed(1);

      if(OrderHelper.getOptions(item.option).isNotEmpty)
      printer.row([
        PosColumn(text: '( ${OrderHelper.getOptions(item.option)} )', width: 12, styles: PosStyles(align: PosAlign.center,fontType: PosFontType.fontA)),
      ]);
      if(response.products.asMap().containsKey(inx))
      printer.hr();
    }



    printer.hr(ch: '=', linesAfter: 1);

    printer.text('Thank you!', styles: PosStyles(align: PosAlign.center, bold: true));
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.text(timestamp, styles: PosStyles(align: PosAlign.center), linesAfter: 2);
    printer.feed(1);
    printer.beep(n: 3,duration: PosBeepDuration.beep50ms);
    printer.cut();

  }

  Future<void> printContactLessOrderReceipt(NetworkPrinter printer,ContactLessOrderInfoModel response) async {
    printer.beep(n: 1,duration: PosBeepDuration.beep50ms);
    // Print image
    final ByteData data = await rootBundle.load('assets/images/printerlogo.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    printer.image(image);

    printer.text('Maison Vie',
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            fontType: PosFontType.fontA
        ),
        linesAfter: 1);
    printer.hr(linesAfter:1);
    if((response.fName!=null && response.fName.isNotEmpty) || (response.lName !=null && response.lName.isNotEmpty))
      printer.text('Customer : ${Utility.decodeUtf8(response.fName)} ${Utility.decodeUtf8(response.lName)}', styles: PosStyles(align: PosAlign.left,bold: true,fontType: PosFontType.fontA),linesAfter: 1);
    if(response.phone!=null && response.phone.isNotEmpty)
      printer.text('Customer Phone : ${response.phone}', styles: PosStyles(align: PosAlign.left,bold: true,fontType: PosFontType.fontA),linesAfter: 1);
    printer.text('Order Date : ${response.createdAt}', styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),linesAfter: 1);
    printer.text('${response.shippingMethod}', styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontB,height: PosTextSize.size2,width: PosTextSize.size2,),
        linesAfter: 1);
    if(response.readyTime!=null && response.readyTime.isNotEmpty)
      printer.text('Delivery Time : ${response.readyTime}', styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),linesAfter: 1);

    printer.text('Order Num : #${response.invoiceId}', styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontB,height: PosTextSize.size2,width: PosTextSize.size2,),
        linesAfter: 1);

    printer.hr(ch: '=', linesAfter: 1);

    printer.row([
      PosColumn(text: 'Qty', width: 1,styles: PosStyles(fontType: PosFontType.fontA),),
      PosColumn(text: '', width: 1,styles: PosStyles(fontType: PosFontType.fontA),),
      PosColumn(text: 'Item', width: 10,styles: PosStyles(fontType: PosFontType.fontA),),
    ]);
    printer.feed(1);
    int inx = 0;
    for(var item in response.items){
      inx++;
      printer.row([
        PosColumn(text: '${item['cnt']}', width: 1,styles: PosStyles(fontType: PosFontType.fontA)),
        PosColumn(text: '*', width: 1,styles: PosStyles(fontType: PosFontType.fontA)),
        PosColumn(text: '${Utility.decodeUtf8(item['item_name'])} ( ${Utility.decodeUtf8(item['category'])} )', width: 10,styles: PosStyles(align: PosAlign.left,fontType: PosFontType.fontB,height: PosTextSize.size2,width: PosTextSize.size2,),),
      ]);
      printer.feed(1);

      if(item['modifiers_name'] != null && item['modifiers_name'].toString().isNotEmpty)
        printer.row([
          PosColumn(text: '( ${Utility.decodeUtf8(item['modifiers_name'].toString())} )', width: 12, styles: PosStyles(align: PosAlign.center,fontType: PosFontType.fontA)),
        ]);
      if(response.items.asMap().containsKey(inx))
        printer.hr();
    }



    printer.hr(ch: '=', linesAfter: 1);

    printer.text('Thank you!', styles: PosStyles(align: PosAlign.center, bold: true));
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.text(timestamp, styles: PosStyles(align: PosAlign.center), linesAfter: 2);
    printer.feed(1);
    printer.beep(n: 3,duration: PosBeepDuration.beep50ms);
    printer.cut();

  }
  // Future<void> testReceipt(NetworkPrinter printer) async {
  //   printer.text(
  //       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  //   printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
  //       styles: PosStyles(codeTable: 'CP1252'));
  //   printer.text('Special 2: blåbærgrød',
  //       styles: PosStyles(codeTable: 'CP1252'));
  //
  //   printer.text('Bold text', styles: PosStyles(bold: true));
  //   printer.text('Reverse text', styles: PosStyles(reverse: true));
  //   printer.text('Underlined text',
  //       styles: PosStyles(underline: true), linesAfter: 1);
  //   printer.text('Align left', styles: PosStyles(align: PosAlign.left));
  //   printer.text('Align center', styles: PosStyles(align: PosAlign.center));
  //   printer.text('Align right',
  //       styles: PosStyles(align: PosAlign.right), linesAfter: 1);
  //
  //   printer.row([
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col6',
  //       width: 6,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //   ]);
  //
  //   printer.text('Text size 200%',
  //       styles: PosStyles(
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ));
  //
  //   // Print image
  //   final ByteData data = await rootBundle.load('assets/images/printerlogo.jpg');
  //   final Uint8List bytes = data.buffer.asUint8List();
  //   final Image image = decodeImage(bytes);
  //   printer.image(image);
  //   // Print image using alternative commands
  //   // printer.imageRaster(image);
  //   // printer.imageRaster(image, imageFn: PosImageFn.graphics);
  //
  //   // Print barcode
  //   final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
  //   printer.barcode(Barcode.upcA(barData));
  //
  //   // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
  //   // printer.text(
  //   //   'hello ! 中文字 # world @ éphémère &',
  //   //   styles: PosStyles(codeTable: PosCodeTable.westEur),
  //   //   containsChinese: true,
  //   // );
  //
  //   printer.feed(2);
  //   printer.cut();
  // }
}