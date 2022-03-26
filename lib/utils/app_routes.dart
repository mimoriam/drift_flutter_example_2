import 'package:flutter/material.dart';

/// Models:

/// Screens:
import '../screens/home/home_screen.dart';

/// Widgets:

/// Services:

/// State:

/// Utils/Helpers:
import 'package:routemaster/routemaster.dart';

/// Entry Point:
final routes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
});
