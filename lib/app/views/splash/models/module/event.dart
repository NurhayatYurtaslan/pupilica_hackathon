import 'package:flutter/material.dart';

abstract class SplashEvent {}

class SplashInitialEvent extends SplashEvent {
  final BuildContext context;
  SplashInitialEvent(this.context);
}
