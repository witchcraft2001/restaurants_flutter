import 'package:flutter/material.dart';
import 'package:zomato_client/bloc/bloc_provider.dart';
import 'package:zomato_client/bloc/location_bloc.dart';
import 'package:zomato_client/data/zomato_api/models/location.dart';
import 'package:zomato_client/ui/screens/location_screen/location_screen.dart';
import 'package:zomato_client/ui/screens/restaurant_screen/restaurant_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationBloc>(
      bloc: LocationBloc(),
      child: MaterialApp(
        title: 'Restaurant Finder',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Location>(
      stream: BlocProvider.of<LocationBloc>(context).locationStream,
      builder: (context, snapshot) {
        final location = snapshot.data;

        if (location == null)
          return LocationScreen();

        return RestaurantScreen(location: location);
      }
    );
  }
}

