import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/provider/loyalty/LoyaltyProvider.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/SizeStyles.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/RoundedTextField.dart';
import 'package:smartshopadmin/widgets/SwitchField.dart';

class AddLoyaltyScreen extends StatefulWidget {
  @override
  State<AddLoyaltyScreen> createState() => _AddLoyaltyScreenState();
}

class _AddLoyaltyScreenState extends State<AddLoyaltyScreen> {
  final dateFormat = DateFormat('y-MM-dd');
  int status = 1;
  final codeCont = TextEditingController();
  final discountCont = TextEditingController();
  final totalCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Loyalty Code',
          style: Styles.textTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 40),
        ),
        actions: [
          TextButton(
            onPressed: () => addLoyalty(),
            child: Text('Save', style: Styles.textTitleStyle.copyWith(fontSize: SizeStyles.textXL)),
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

  void addLoyalty() async {
    if (codeCont.text.isEmpty) {
      ShowMessageService.showErrorMsg('Code is required');
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
