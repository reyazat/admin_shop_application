import 'package:flutter/material.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/Styles.dart';

class VerticalMenuWidget extends StatelessWidget {
  VerticalMenuWidget({
    @required this.text,
    @required this.icon,
    this.press,
    this.lable
  });

  final String text;
  final String lable;
  final Widget icon;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: MainColors.white
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 20.0),
            child: Row(
              children: [
                icon,
                SizedBox(width: MediaQuery.of(context).size.height / 30),
                Expanded(child: Text(text,style: Styles.textLabStyle.copyWith(fontSize: MediaQuery.of(context).size.height / 58,),)),
                lable != null ?
                CircleAvatar(
                  backgroundColor: MainColors.mainColor,
                  child: Text(lable,style: TextStyle(color: MainColors.white,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height / 60),),
                ):Container(),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_ios,color: MainColors.mainColor,size: MediaQuery.of(context).size.height / 35,),
              ],
            ),
          ),
        ),
    );
  }
}
