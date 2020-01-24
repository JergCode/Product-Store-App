import 'package:flutter/material.dart';

class SlideFromRightAnimation extends PageRouteBuilder {
  final Widget page;
  SlideFromRightAnimation({
    this.page,
  }) : super(
          pageBuilder: (context, animation, secondaryAnitmation) => page,
          transitionsBuilder: (context, animation, secondaryAnitmation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(1.0, 0.0),
                ).animate(secondaryAnitmation),
                child: child,
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 300),
        );
}
