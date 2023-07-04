
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smartshopadmin/helpers/Utility.dart';
import 'package:smartshopadmin/provider/clients/ClientsProvider.dart';
import 'package:smartshopadmin/provider/clients/ClientsState.dart';
import 'package:smartshopadmin/screens/ClientsInfoScreen.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';
import 'package:smartshopadmin/widgets/EditDialogWidget.dart';
import 'package:smartshopadmin/widgets/InputBuildWidget.dart';
import 'package:smartshopadmin/widgets/ListToRefreshWdget.dart';
import 'package:smartshopadmin/widgets/SelectField.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key key}) : super(key: key);

  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  String dropdownValue = 'Email';

  FocusNode _searchFocus = new FocusNode();
  final searchTextController = TextEditingController(text: '');
  Widget clearSearchText = SizedBox(width: 1);

  @override
  void initState() {
    context.read<ClientsProvider>().init();
    super.initState();

    _searchFocus.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    _searchFocus.removeListener(_onSearchFocusChange);
    _searchFocus.dispose();
    searchTextController.dispose();
    _pointComment.controller.dispose();
    _pointNumber.controller.dispose();
    _loyaltyCode.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: MainColors.subMainColor,
          foregroundColor: MainColors.white,
          title: Card(
            elevation: 0,
            margin: EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 20),
            color: MainColors.subMainColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      focusNode: _searchFocus,
                      controller: searchTextController,
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.name,
                      onSubmitted: (value) {
                        context.read<ClientsProvider>().searchText = value;
                        context.read<ClientsProvider>().searchClients();
                      },
                      style: TextStyle(fontSize: MediaQuery.of(context).size.height / 45, color: MainColors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.search,
                            color: MainColors.white,
                            size: MediaQuery.of(context).size.height / 35,
                        ),
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: MainColors.white,
                          fontSize: MediaQuery.of(context).size.height / 50),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  clearSearchText,
                  SizedBox(width: 17),
                  Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: SelectField(
                      dropdownItems: <String>['Email', 'Name'],
                      dropdownValue: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          context.read<ClientsProvider>().searchFilter = newValue;
                        });
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.1), BlendMode.dstATop),
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.fitHeight),
              ),
            ),
            Consumer<ClientsProvider>(
              builder: (context, state, child) {
                print(state.clientsState);

                if(state.clientsState is ClientsLoading || state.clientsState is ClientsInitial) {
                  ShowMessageService.showLoading();
                  return SizedBox();

                } else if(state.clientsState is ClientsLoaded) {
                  ShowMessageService.closeLoading();
                  return state.clients.length == 0
                      ?
                  Center(
                    child: Card(
                      elevation: 5,
                      color: MainColors.white.withOpacity(0.7),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(Constants.noCustomers,
                          style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 65),
                        ),
                      ),
                    ),
                  )
                      :
                  ListToRefresh(
                    onRefresh: context.read<ClientsProvider>().searchClients,
                    onLoading: context.read<ClientsProvider>().loadingPageClients,
                    backGround: false,
                    child: ListView.builder(
                      itemCount: state.clients.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Add Point',
                                  color: Colors.orange,
                                  iconWidget: Icon(FontAwesomeIcons.star,
                                    color: Colors.black,
                                    size: MediaQuery.of(context).size.height / 30,
                                  ),
                                  onTap: () => _addRewardPoint(index, state.clients[index].customerId),
                                ),
                                state.clients[index].loyaltyCode == '' ?
                                  IconSlideAction(
                                    caption: 'Add Loyalty',
                                    color: MainColors.amber,
                                    iconWidget: Icon(FontAwesomeIcons.gratipay,
                                      color: Colors.black,
                                      size: MediaQuery.of(context).size.height / 30,
                                    ),
                                    onTap: () => _addLoyalty(index, state.clients[index].customerId),
                                  ) :
                                  IconSlideAction(
                                    caption: 'Delete Loyalty',
                                    color: MainColors.redAction,
                                    iconWidget: Icon(FontAwesomeIcons.trashAlt,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.height / 30,
                                    ),
                                    onTap: () => _deleteLoyalty(index, state.clients[index].customerId),
                                  ),
                              ],
                              child: GestureDetector(
                                onTap: () {
                                  print('************');
                                  print(state.clients.toString());
                                  print(state.clients[index].toString());
                                  print(state.clients[index].customerId);

                                  Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ClientsInfo(customerId: state.clients[index].customerId),
                                  ));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                  padding: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 0.5,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(state.clients[index].loyaltyCode == '' ? FontAwesomeIcons.userAlt : FontAwesomeIcons.gratipay,
                                        color: MainColors.mainColor,
                                        size: MediaQuery.of(context).size.height / 30,
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 4),
                                              child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Name: ',
                                                        style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height /54),

                                                      ),
                                                      TextSpan(
                                                        text: Utility.decodeUtf8(state.clients[index].name),
                                                        style: Styles.textStyle.copyWith(fontSize: MediaQuery.of(context).size.height /55),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 6),
                                              child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Email: ',
                                                        style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height /54),

                                                      ),
                                                      TextSpan(
                                                        text: state.clients[index].email,
                                                        style: Styles.textStyle.copyWith(fontSize: MediaQuery.of(context).size.height /55),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 5),
                                              child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Total: ',
                                                        style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height /54),

                                                      ),
                                                      TextSpan(
                                                        text: state.clients[index].total,
                                                        style: Styles.textStyle.copyWith(fontSize: MediaQuery.of(context).size.height /55),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Reward Points: ',
                                                      style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height /54),

                                                    ),
                                                    TextSpan(
                                                      text: state.clients[index].rewardPoints != '' ?  state.clients[index].rewardPoints : '0',
                                                      style: Styles.textStyle.copyWith(fontSize: MediaQuery.of(context).size.height /55),
                                                    ),
                                                  ]
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                        color: MainColors.mainColor,
                                        size: MediaQuery.of(context).size.height / 35,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  ShowMessageService.closeLoading();
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchFocusChange() {
    if(_searchFocus.hasFocus) {
      setState(() {
        clearSearchText = GestureDetector(
          child: Icon(FontAwesomeIcons.times,
            color: MainColors.white,
            size: MediaQuery.of(context).size.height / 35,
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            searchTextController.text = '';
            context.read<ClientsProvider>().searchText = '';
            context.read<ClientsProvider>().searchClients();
          },
        );
      });
    } else {
      setState(() {
        clearSearchText = SizedBox(width: 1);
      });
    }
  }

  InputBuildWidget _pointComment = InputBuildWidget(
    hint: 'Comment',
    label: 'Comment',
    inputType: TextInputType.name,
  );

  InputBuildWidget _pointNumber = InputBuildWidget(
    hint: 'Point',
    label: 'Point',
    inputType: TextInputType.numberWithOptions(signed: true, decimal: true),
  );

  _addRewardPoint(int index, customerId) {
    String title = 'Add a Reward Point';

    _pointComment.controller.text = '';
    _pointNumber.controller.text = '';

    showCupertinoModalPopup(
        context: context,
        builder: (_) => EditDialogWidget(
            title:Text(title),
            content: Column(
              children: [
                _pointComment,
                SizedBox(height: 20),
                _pointNumber,
              ],
            ),
            childYes: Text("Save",
              style: Styles.textActionStyle.copyWith(color: MainColors.blueAction, fontSize: MediaQuery.of(context).size.height / 50),
            ),
            onPressYes: () async {
              if(Utility.isEmpty(_pointComment.controller.text) != null) {
                ShowMessageService.showErrorMsg('The comment ${Constants.required}');
                return null;
              }

              if(Utility.isEmpty(_pointNumber.controller.text) != null) {
                ShowMessageService.showErrorMsg('The point ${Constants.required}');
                return null;
              }

              await context.read<ClientsProvider>().addRewardPoint(
                index: index,
                customerId: customerId,
                comment: _pointComment.controller.text,
                reward: _pointNumber.controller.text,
              );

              Navigator.pop(context);
            },
            onPressNo: () => Navigator.pop(context),
            childNo: Text("Cancel",
              style: Styles.textActionStyle.copyWith(color: MainColors.redAction, fontSize: MediaQuery.of(context).size.height / 50),
            )
        )
    );
  }

  InputBuildWidget _loyaltyCode = InputBuildWidget(
    hint: 'Loyalty Code',
    label: 'Loyalty Code',
    inputType: TextInputType.numberWithOptions(signed: true, decimal: true),
  );

  _addLoyalty(int index, customerId) {
    String title = 'Add a Loyalty Code';

    _loyaltyCode.controller.text = '';

    showCupertinoModalPopup(
        context: context,
        builder: (_) => EditDialogWidget(
            title:Text(title),
            content: Column(
              children: [
                _loyaltyCode,
              ],
            ),
            childYes: Text("Save",
              style: Styles.textActionStyle.copyWith(color: MainColors.blueAction,fontSize: MediaQuery.of(context).size.height / 50),
            ),
            onPressYes: () async {
              if(Utility.isEmpty(_loyaltyCode.controller.text) != null) {
                ShowMessageService.showErrorMsg('The loyalty code ${Constants.required}');
                return null;
              }

              await context.read<ClientsProvider>().addLoyalty(
                index: index,
                customerId: customerId,
                customerCode: _loyaltyCode.controller.text,
              );
              Navigator.pop(context);
            },
            onPressNo: () => Navigator.pop(context),
            childNo: Text("Cancel",
              style: Styles.textActionStyle.copyWith(color: MainColors.redAction,fontSize: MediaQuery.of(context).size.height / 50),
            )
        )
    );
  }

  _deleteLoyalty(int index, customerId) {
    String title = 'Are you sure you want to delete this customer loyalty code?';

    showCupertinoModalPopup(
        context: context,
        builder: (_) => EditDialogWidget(
            title:Text(title),
            childYes: Text("Delete",
              style: Styles.textActionStyle.copyWith(color: MainColors.redAction, fontSize: MediaQuery.of(context).size.height / 50),
            ),
            onPressYes: () async {
              await context.read<ClientsProvider>().deleteLoyalty(
                index: index,
                customerId: customerId,
              );

              Navigator.pop(context);
            },
            onPressNo: () => Navigator.pop(context),
            childNo: Text("Cancel",
              style: Styles.textActionStyle.copyWith(color: MainColors.blueAction, fontSize: MediaQuery.of(context).size.height / 50),
            )
        )
    );
  }

}
