import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/models/LoyaltyModel.dart';
import 'package:smartshopadmin/provider/loyalty/LoyaltyProvider.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/ConfirmDialogWidget.dart';
import 'package:smartshopadmin/widgets/RoundedTextField.dart';
import 'package:smartshopadmin/widgets/SwitchField.dart';

class LoyaltyDetailScreen extends StatefulWidget {
  final LoyaltyModel loyalty;

  LoyaltyDetailScreen(this.loyalty);

  @override
  State<LoyaltyDetailScreen> createState() => _LoyaltyDetailScreenState();
}

class _LoyaltyDetailScreenState extends State<LoyaltyDetailScreen> {
  final dateFormat = DateFormat('y-MM-dd');
  int status;
  TextEditingController codeCont;
  TextEditingController discountCont;
  TextEditingController totalCont;

  @override
  void initState() {
    status = widget.loyalty.status;
    codeCont = TextEditingController(text: widget.loyalty.code);
    discountCont = TextEditingController(text: widget.loyalty.discount.toString());
    totalCont = TextEditingController(text: widget.loyalty.total.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.loyalty.name,
          style: Styles.textTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 40),
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.delete),
            onPressed: () {
              ConfirmDialogWidget.show(
                context,
                title: 'Delete Loyalty Code?',
                yes: Text('Delete', style: TextStyle(color: MainColors.red)),
                no: Text('Cancel'),
              ).then((value) async {
                if (value ?? false) {
                  await context.read<LoyaltyProvider>().deleteLoyalty(widget.loyalty.id);
                  Navigator.pop(context);
                }
              });
            },
          ),
          IconButton(
            icon: Icon(CupertinoIcons.check_mark),
            onPressed: () => editLoyalty(),
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

  void editLoyalty() async {
    if (codeCont.text.isEmpty) {
      ShowMessageService.showErrorMsg('Name and code fields are required');
    } else if (discountCont.text.isNotEmpty && double.tryParse(discountCont.text) == null) {
      ShowMessageService.showErrorMsg('Discount value is not a valid number');
    } else if (totalCont.text.isNotEmpty && double.tryParse(totalCont.text) == null) {
      ShowMessageService.showErrorMsg('Total value is not a valid number');
    } else if (discountCont.text.isNotEmpty &&
        (double.parse(discountCont.text) < 0 || double.parse(discountCont.text) > 100)) {
      ShowMessageService.showErrorMsg('Discount must be in the range 0-100');
    } else if (codeCont.text.length > 12 || codeCont.text.length < 4) {
      ShowMessageService.showErrorMsg('Code must be between 4 and 12 characters');
    } else {
      var data = {
        "coupon_id": widget.loyalty.id,
        "loyalty": "1",
        "code": codeCont.text,
        "discount": discountCont.text,
        "total": totalCont.text,
        "status": status,
      };
      await context.read<LoyaltyProvider>().addEditLoyalty(data);
      Navigator.pop(context);
    }
  }
}
