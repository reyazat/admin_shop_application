import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/models/CouponModel.dart';
import 'package:smartshopadmin/provider/coupon/CouponProvider.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/ConfirmDialogWidget.dart';
import 'package:smartshopadmin/widgets/RoundedTextField.dart';
import 'package:smartshopadmin/widgets/SwitchField.dart';

class CouponDetailScreen extends StatefulWidget {
  final CouponModel coupon;

  CouponDetailScreen(this.coupon);

  @override
  State<CouponDetailScreen> createState() => _CouponDetailScreenState();
}

class _CouponDetailScreenState extends State<CouponDetailScreen> {
  final dateFormat = DateFormat('y-MM-dd');
  int logged;
  int shipping;
  int status;
  TextEditingController nameCont;
  TextEditingController codeCont;
  TextEditingController discountCont;
  TextEditingController totalCont;
  TextEditingController totalUseCont;
  TextEditingController customerCont;
  TextEditingController startDateCont;
  TextEditingController endDateCont;

  @override
  void initState() {
    logged = widget.coupon.logged;
    shipping = widget.coupon.shipping;
    status = widget.coupon.status;
    nameCont = TextEditingController(text: widget.coupon.name);
    codeCont = TextEditingController(text: widget.coupon.code);
    discountCont = TextEditingController(text: widget.coupon.discount.toString());
    totalCont = TextEditingController(text: widget.coupon.total.toString());
    totalUseCont = TextEditingController(text: widget.coupon.totalUse.toString());
    customerCont = TextEditingController(text: widget.coupon.customerUse.toString());
    startDateCont = TextEditingController(text: dateFormat.format(widget.coupon.startDate));
    endDateCont = TextEditingController(text: dateFormat.format(widget.coupon.endDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.coupon.name,
          style: Styles.textTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 40),
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.delete),
            onPressed: () {
              ConfirmDialogWidget.show(
                context,
                title: 'Delete Coupon?',
                yes: Text('Delete', style: TextStyle(color: MainColors.red)),
                no: Text('Cancel'),
              ).then((value) async {
                if (value ?? false) {
                  await context.read<CouponProvider>().deleteCoupon(widget.coupon.id);
                  Navigator.pop(context);
                }
              });
            },
          ),
          IconButton(
            icon: Icon(CupertinoIcons.check_mark),
            onPressed: () => editCoupon(),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            UnderlinedTextField(label: 'Name *', controller: nameCont),
                            UnderlinedTextField(label: 'Code *', controller: codeCont),
                            UnderlinedTextField(
                              label: 'Discount (%)',
                              controller: discountCont,
                              keyboardType: TextInputType.number,
                            ),
                            UnderlinedTextField(
                              label: 'Total Amount (£)',
                              controller: totalCont,
                              keyboardType: TextInputType.number,
                            ),
                            UnderlinedTextField(
                              label: 'Uses Per Coupon',
                              controller: totalUseCont,
                              keyboardType: TextInputType.number,
                            ),
                            if (logged == 1)
                              UnderlinedTextField(
                                label: 'Uses Per Customer',
                                controller: customerCont,
                                keyboardType: TextInputType.number,
                              ),
                            UnderlinedTextField(
                              readOnly: true,
                              label: 'Start Date',
                              onTap: () => datePicker(startDateCont),
                              controller: startDateCont,
                            ),
                            UnderlinedTextField(
                              readOnly: true,
                              label: 'End Date',
                              onTap: () => datePicker(endDateCont),
                              controller: endDateCont,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SwitchField(
                              'Customer Login',
                              logged == 1,
                              (value) => setState(() {
                                logged = value ? 1 : 0;
                              }),
                            ),
                            SwitchField(
                              'Free Shipping',
                              shipping == 1,
                              (value) => setState(() {
                                shipping = value ? 1 : 0;
                              }),
                            ),
                            SwitchField(
                              'Enabled',
                              status == 1,
                              (value) => setState(() {
                                status = value ? 1 : 0;
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void datePicker(TextEditingController controller) {
    final dateFormatter = DateFormat('y-M-dd');
    var date = dateFormatter.parse(controller.text);

    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  use24hFormat: true,
                  initialDateTime: date,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDateTime) => date = newDateTime,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                color: MainColors.mainColor,
                child: Text('Select Date', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  controller.text = dateFormat.format(date);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void editCoupon() async {
    if (nameCont.text.isEmpty || codeCont.text.isEmpty) {
      ShowMessageService.showErrorMsg('Name and code fields are required');
    } else if (discountCont.text.isNotEmpty && double.tryParse(discountCont.text) == null) {
      ShowMessageService.showErrorMsg('Discount value is not a valid number');
    } else if (discountCont.text.isNotEmpty &&
        (double.parse(discountCont.text) < 0 || double.parse(discountCont.text) > 100)) {
      ShowMessageService.showErrorMsg('Discount must be in the range 0-100');
    } else if (totalCont.text.isNotEmpty && double.tryParse(totalCont.text) == null) {
      ShowMessageService.showErrorMsg('Total value is not a valid number');
    } else if (codeCont.text.length > 12 || codeCont.text.length < 4) {
      ShowMessageService.showErrorMsg('Code must be between 4 and 12 characters');
    } else {
      var data = {
        "coupon_id": widget.coupon.id,
        "shipping": shipping,
        "name": nameCont.text,
        "code": codeCont.text,
        "logged": logged,
        "date_start": startDateCont.text,
        "date_end": endDateCont.text,
        "discount": discountCont.text,
        "total": totalCont.text,
        "status": status,
        if (logged == 1) "uses_customer": customerCont.text,
        "uses_total": totalUseCont.text,
      };
      await context.read<CouponProvider>().addEditCoupon(data);
      Navigator.pop(context);
    }
  }
}
