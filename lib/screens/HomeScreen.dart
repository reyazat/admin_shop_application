import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartshopadmin/provider/Auth/AuthProvider.dart';
import 'package:smartshopadmin/provider/HomeProvider.dart';
import 'package:smartshopadmin/provider/HomeState.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/screens/pages/ClientsPage.dart';
import 'package:smartshopadmin/screens/pages/DashboardPage.dart';
import 'package:smartshopadmin/screens/pages/OrdersPage.dart';
import 'package:smartshopadmin/screens/pages/ProductsPage.dart';
import 'package:smartshopadmin/screens/pages/SettingsPage.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/LoadingWidget.dart';
class Home extends StatefulWidget {
  static final String routeName = '/Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static List pages = [DashboardPage(), ClientsPage(), OrdersPage(), ProductsPage(), SettingsPage()];

  @override
  void initState() {
    context.read<HomeProvider>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: ConvexAppBar.badge({},
          initialActiveIndex: context.watch<HomeProvider>().selectedIndex,
          elevation: 5,
          //optional, default as 0
          style: TabStyle.reactCircle,
          backgroundColor: MainColors.mainColor,
          color: MainColors.white,
          key: context.watch<HomeProvider>().appBarKey,

          items: [
            TabItem(icon: FontAwesomeIcons.shoppingBasket,title: 'C.L.Order'),
            TabItem(icon: FontAwesomeIcons.users,title: 'Customers'),
            TabItem(icon: FontAwesomeIcons.fileInvoiceDollar,title: 'Orders'),
            TabItem(icon: FontAwesomeIcons.boxOpen,title: 'Products'),
            TabItem(icon: FontAwesomeIcons.ellipsisH,title: 'Settings'),
          ],

          onTap: (int i) {
              context.read<HomeProvider>().changeTab(i);
          },
        ),
        body: Consumer<HomeProvider>(
          builder: (context, state, child){
            if(state.homeState is HomeLoading || state.homeState is HomeInitial) {
              return LoadingWidget();
            }else if(state.homeState is HomeLogOut){
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                context.read<AuthProvider>().signOut(context);
              });
              return SizedBox();
            }else if(state.homeState is HomeLoaded){
              return pages[context.watch<HomeProvider>().selectedIndex];
            }else if(state.homeState is HomeNetworkError){
              return Center(child: Card(
                margin: EdgeInsets.all(30.0),
                elevation: 5,
                color: MainColors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0,right: 30.0,left: 30.0,bottom: 0.0),
                      child: Text(Constants.noInternet,style: Styles.errorTextStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 65),),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          Phoenix.rebirth(context);
                        },
                        style: Styles.buttonStyle,
                        child: Text(
                          'Reload',
                          style: Styles.textTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),);
            }else{
              return SizedBox();
            }
          },
        ),
    );
  }
}
