import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/provider/coupon/CouponProvider.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/SizeStyles.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/RoundedTextField.dart';
import 'package:smartshopadmin/widgets/SwitchField.dart';

class AddCouponScreen extends StatefulWidget {
  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final dateFormat = DateFormat('y-MM-dd');
  int logged = 1;
  int shipping = 1;
  int status = 1;
  final nameCont = TextEditingController();
  final codeCont = TextEditingController();
  final discountCont = TextEditingController();
  final totalCont = TextEditingController();
  final totalUseCont = TextEditingController();
  final customerCont = TextEditingController();
  final startDateCont = TextEditingController();
  final endDateCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Coupon',
          style: Styles.textTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 40),
        ),
        actions: [
          TextButton(
            onPressed: () => addCoupon(),
            child: Text('Save', style: Styles.textTitleStyle.copyWith(fontSize: SizeStyles.textXL)),
          )
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
    var date = controller.text.isNotEmpty ? dateFormatter.parse(controller.text) : DateTime.now();

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

  addCoupon() async {
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
