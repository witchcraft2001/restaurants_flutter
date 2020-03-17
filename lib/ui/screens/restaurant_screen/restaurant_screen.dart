import 'package:flutter/material.dart';
import 'package:zomato_client/bloc/bloc_provider.dart';
import 'package:zomato_client/bloc/restaurant_bloc.dart';
import 'package:zomato_client/data/zomato_api/models/location.dart';
import 'package:zomato_client/data/zomato_api/models/restaurant.dart';
import 'package:zomato_client/ui/image_container.dart';
import 'package:zomato_client/ui/screens/favorite_screen/favorite_screen.dart';
import 'package:zomato_client/ui/screens/restaurant_details_screen/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  final Location location;

  const RestaurantScreen({Key key, @required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => FavoriteScreen())),
          ),
        ],
      ),
      body: _buildSearch(context),
    );
  }

  Widget _buildSearch(BuildContext context) {
    final bloc = RestaurantBloc(location);

    return BlocProvider<RestaurantBloc>(
      bloc: bloc,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'What do you want to eat?'),
              onChanged: (query) => bloc.submitQuery(query),
            ),
          ),
          Expanded(
            child: _buildStreamBuilder(bloc),
          )
        ],
      ),
    );
  }

  Widget _buildStreamBuilder(RestaurantBloc bloc) {
    return StreamBuilder(
      stream: bloc.stream,
      builder: (context, snapshot) {
        final results = snapshot.data;
        if (results == null) {
          return Center(child: Text('Enter a restaurant name or cuisine type'));
        }

        if (results.isEmpty) {
          return Center(child: Text('No results'));
        }

        return _buildSearchResult(results);
      },
    );
  }

  Widget _buildSearchResult(List<Restaurant> results) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final restaurant = results[index];
          return RestaurantTile(restaurant: restaurant);
        }
    );
  }
}

class RestaurantTile extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantTile({Key key, @required this.restaurant,}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImageContainer(
        width: 50,
          height: 50,
          url: restaurant.thumbUrl,
      ),
      title: Text(restaurant.name),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
          ),
        );
      },
    );
  }
}

