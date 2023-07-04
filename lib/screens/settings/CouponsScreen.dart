import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/provider/coupon/CouponProvider.dart';
import 'package:smartshopadmin/provider/coupon/CouponState.dart';
import 'package:smartshopadmin/screens/settings/AddCouponScreen.dart';
import 'package:smartshopadmin/screens/settings/CouponDetailScreen.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/ConfirmDialogWidget.dart';
import 'package:smartshopadmin/widgets/ListToRefreshWdget.dart';

class Coupons extends StatelessWidget {
  static const routeName = '/Coupons';
  final dateFormat = DateFormat('dd/MM/y');

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
                builder: (BuildContext context) => AddCouponScreen(),
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Coupons',
          style: Styles.textTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 40),
        ),
        actions: [
          IconButton(
            onPressed: () => showSortModal(context),
            icon: Icon(Icons.sort, color: MainColors.white),
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
              child: Consumer<CouponProvider>(
                builder: (context, provider, child) {
                  if (provider.state is CouponLoaded) {
                    if (provider.coupons.isNotEmpty) {
                      return ListToRefresh(
                        onRefresh: () => provider.getCouponList(),
                        child: ListView.builder(
                            itemCount: provider.coupons.length,
                            itemBuilder: (context, index) {
                              var coupon = provider.coupons[index];
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
                                        title: 'Delete Coupon?',
                                        yes: Text('Delete', style: TextStyle(color: MainColors.red)),
                                        no: Text('Cancel'),
                                      ).then((value) async {
                                        if (value ?? false) {
                                          await context.read<CouponProvider>().deleteCoupon(coupon.id);
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
                                        builder: (BuildContext context) => CouponDetailScreen(coupon),
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
                                              Text(coupon.name, style: Styles.textLabStyle),
                                              Text(
                                                '%' + coupon.discount.toString(),
                                                style: Styles.textLabStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(coupon.code, style: Styles.textSubtitleStyle),
                                              if (coupon.status == 0) Text('Disabled'),
                                            ],
                                          ),
                                          Text(
                                            '${dateFormat.format(coupon.startDate)} - ${dateFormat.format(coupon.endDate)}',
                                            style: Styles.textSubtitleStyle,
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
                      return Center(child: Text('No coupons found!'));
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
    var sort = context.read<CouponProvider>().sort;

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
            height: 430,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  Text('Sort', style: Styles.textLargeLabStyle, textAlign: TextAlign.center),
                  ...context.read<CouponProvider>().sortValues.map((e) {
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
                      context.read<CouponProvider>().sort = sort;
                      context.read<CouponProvider>().getCouponList();
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
