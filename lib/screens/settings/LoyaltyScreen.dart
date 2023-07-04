import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/provider/loyalty/LoyaltyProvider.dart';
import 'package:smartshopadmin/provider/loyalty/LoyaltyState.dart';
import 'package:smartshopadmin/screens/settings/AddLoyaltyScreen.dart';
import 'package:smartshopadmin/screens/settings/LoyaltyDetailScreen.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/ConfirmDialogWidget.dart';
import 'package:smartshopadmin/widgets/ListToRefreshWdget.dart';

class Loyalty extends StatelessWidget {
  static const routeName = '/Loyalty';
  final dateFormat = DateFormat('MM/dd/y');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
        backgroundColor: MainColors.mainColor,
        minRadius: 10.0,
        maxRadius: MediaQuery.of(context).size.height / 25,
        child: IconButton(
          icon: Icon(
            FontAwesomeIcons.plus,
            color: MainColors.white,
            size: MediaQuery.of(context).size.height / 35,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AddLoyaltyScreen(),
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Loyalty Codes',
          style: Styles.textTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 40),
        ),
        actions: [
          IconButton(
            onPressed: () => showSortModal(context),
            icon: Icon(Icons.sort, color: MainColors.white),
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
              child: Consumer<LoyaltyProvider>(
                builder: (context, provider, child) {
                  if (provider.state is LoyaltyLoaded) {
                    if (provider.loyaltyList.isNotEmpty) {
                      return ListToRefresh(
                        onRefresh: () => provider.getLoyaltyList(),
                        child: ListView.builder(
                            itemCount: provider.loyaltyList.length,
                            itemBuilder: (context, index) {
                              var loyalty = provider.loyaltyList[index];
                              return Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                secondaryActions: [
                                  IconSlideAction(
                                    color: MainColors.redAction,
                                    icon: CupertinoIcons.delete,
                                    caption: 'Delete',
                                    onTap: () {
                                      ConfirmDialogWidget.show(
                                        context,
                                        title: 'Delete Loyalty Code?',
                                        yes: Text('Delete', style: TextStyle(color: MainColors.red)),
                                        no: Text('Cancel'),
                                      ).then((value) async {
                                        if (value ?? false) {
                                          await context.read<LoyaltyProvider>().deleteLoyalty(loyalty.id);
                                        }
                                      });
                                    },
                                  ),
                                ],
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => LoyaltyDetailScreen(loyalty),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(loyalty.name, style: Styles.textLabStyle),
                                              Text(
                                                '%' + loyalty.discount.toString(),
                                                style: Styles.textLabStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(loyalty.code, style: Styles.textSubtitleStyle),
                                              if (loyalty.status == 0) Text('Disabled'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(child: Text('No loyalty coupons found!'));
                    }
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSortModal(BuildContext context) {
    var sort = context.read<LoyaltyProvider>().sort;

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
        return StatefulBuilder(builder: (context, setState) {
          return SizedBox(
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  Text('Sort', style: Styles.textLargeLabStyle, textAlign: TextAlign.center),
                  ...context.read<LoyaltyProvider>().sortValues.map((e) {
                    return Row(
                      children: <Widget>[
                        Radio(
                          value: e[0],
                          groupValue: sort,
                          onChanged: (value) {
                            sort = value;
                            setState(() {});
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            sort = e[0];
                            setState(() {});
                          },
                          child: Text(e[1], style: Styles.textLabStyle),
                        ),
                      ],
                    );
                  }),
                  Expanded(child: SizedBox()),
                  CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    color: MainColors.mainColor,
                    child: Text('Apply', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<LoyaltyProvider>().sort = sort;
                      context.read<LoyaltyProvider>().getLoyaltyList();
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
