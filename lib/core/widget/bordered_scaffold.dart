import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class BorderedScaffold extends StatelessWidget {
  final List<Widget> children;
  final Widget? bottomBarChild;
  final AppBar appBar;
  final bool isShowBackground;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry bottomPadding;
  const BorderedScaffold({
    super.key,
    required this.appBar,
    this.isShowBackground = false,
    this.bottomBarChild,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    this.bottomPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 28,
    ),
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: appColors.white,
      bottomNavigationBar:
          bottomBarChild != null
              ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(padding: bottomPadding, child: bottomBarChild),
              )
              : null,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            if (isShowBackground)
              Container(
                decoration: BoxDecoration(
                  color: appColors.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                height: 200,
              ),
            Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
