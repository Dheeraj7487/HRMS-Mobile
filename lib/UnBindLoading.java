import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../provider/loading_provider.dart';

class UnBindLoading extends StatelessWidget {
  final Widget? child;

  UnBindLoading({this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      builder: (context, data, _) {
        return IgnorePointer(
          ignoring: data.isLoading,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              child!,
              if (data.isLoading)
                const Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColor.backgroundColor,
                    child: SpinKitFadingCircle(
                      color: AppColor.appColor,
                      size: 40,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
