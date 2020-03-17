import 'package:flutter/material.dart';
import 'package:zomato_client/bloc/bloc_provider.dart';
import 'package:zomato_client/bloc/favorite_bloc.dart';
import 'package:zomato_client/data/zomato_api/models/restaurant.dart';
import 'package:zomato_client/ui/screens/restaurant_screen/restaurant_screen.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FavoriteBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: StreamBuilder<List<Restaurant>>(
        stream: bloc.favoritesStream,
        initialData: bloc.favorites,
        builder: (context, snapshot) {
          List<Restaurant> favorites = (snapshot.connectionState == ConnectionState.waiting)
              ? bloc.favorites
              : snapshot.data;

          if (favorites == null || favorites.isEmpty) {
            return Center(child: Text('No favorites'));
          }

          return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
                final restaurant = favorites[index];
                return RestaurantTile(restaurant: restaurant);
            },
          );
        },
      ),
    );
  }
}