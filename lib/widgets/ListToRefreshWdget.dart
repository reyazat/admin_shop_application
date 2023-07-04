
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListToRefresh extends StatefulWidget {
  final Function onRefresh;
  final Function onLoading;
  final Widget child;
  final bool backGround ;
  ListToRefresh({@required this.onRefresh, @required this.child, this.onLoading, this.backGround});

  @override
  _ListToRefreshState createState() => _ListToRefreshState();
}

class _ListToRefreshState extends State<ListToRefresh> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _onRefresh() async {
    await widget.onRefresh();
    _refreshController.refreshCompleted();
  }
  void _onLoading() async{
    await widget.onLoading();
    _refreshController.loadComplete();
  }
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return RefreshConfiguration(
      dragSpeedRatio: 0.91,
      enableLoadingWhenNoData: false,
      enableRefreshVibrate: false,
      enableLoadMoreVibrate: false,

      child: Container(
          width: width,
          height: height ,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),

          decoration: widget.backGround == true ? BoxDecoration(
            color: MainColors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ) : BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: (widget.onLoading!=null) ? true:false,
            header: WaterDropMaterialHeader(
              backgroundColor: MainColors.mainColor,
            ),
            footer: CustomFooter(
              builder: (BuildContext context,LoadStatus mode){
                print(mode);
                Widget body ;
                if(mode==LoadStatus.idle){
                  body =  SizedBox();
                }
                else if(mode==LoadStatus.loading){
                  body =  CircularProgressIndicator(color: MainColors.mainColor,);
                }
                else if(mode == LoadStatus.failed){
                  body = SizedBox();
                }
                else if(mode == LoadStatus.canLoading){
                  body = SizedBox();
                }
                else{
                  body = SizedBox();
                }
                return Container(
                  height: 55.0,
                  child: Center(child:body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: widget.child,
          )
      ),
    );
  }
}
