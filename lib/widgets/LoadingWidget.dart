
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:smartshopadmin/values/MainColors.dart';
import 'package:smartshopadmin/values/SizeStyles.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Card(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MainColors.mainColor,),
                SizedBox(width: SizeStyles.XL,),
                JumpingText('Please wait...'),
              ],
            ),
          )
      ),

    );
  }
}
