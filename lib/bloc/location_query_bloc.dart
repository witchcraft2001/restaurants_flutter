import 'dart:async';

import 'package:zomato_client/bloc/bloc.dart';
import 'package:zomato_client/data/zomato_api/models/location.dart';
import 'package:zomato_client/data/zomato_api/zomato_client.dart';

class LocationQueryBloc implements Bloc {
  final _controller = StreamController<List<Location>>();
  final _client = ZomatoClient();
  Stream<List<Location>> get locationStream => _controller.stream;

  void submitQuery(String query) async {
    final results = await _client.fetchLocations(query);
    _controller.sink.add(results);
  }

  @override
  void dispose() {
    _controller.close();
  }
}