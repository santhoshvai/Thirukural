import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import '../utils.dart';
import '../models/kurals.dart';

class KuralBloc {

  List<int> _allFavsIndices = [];
  Kurals kurals;
  final _favIndexAdditionController = StreamController<int>();
  final _favIndexRemovalController = StreamController<int>();
  final _allFavKuralIndicesSubject = BehaviorSubject<List<int>>(seedValue: []);
  final _fetchingFavoritesSubject = BehaviorSubject<bool>(seedValue: true);
  final _fetchingKuralsSubject = BehaviorSubject<bool>(seedValue: true);

  KuralBloc(BuildContext context) {
    _favIndexAdditionController.stream.listen(_handleAddition);
    _favIndexRemovalController.stream.listen(_handleRemoval);
    _readKurals(context);
    _readFavs();
  }

  /// This is the input of additions to favs. Use this to signal
  /// to the component that user is trying to add a fav.
  Sink<int> get favAddition => _favIndexAdditionController.sink;

  /// This is the input of deletions to favs. Use this to signal
  /// to the component that user is trying to remove a fav.
  Sink<int> get favRemoval => _favIndexRemovalController.sink;

  /// We're using the `distinct()` transform so that only values that are
  /// in fact a change will be published by the stream.
  Stream<bool> get fetchingFavs => _fetchingFavoritesSubject.stream.distinct();
  Stream<bool> get fetchingKurals => _fetchingKuralsSubject.stream.distinct();

  /// This is the stream of fav kural indices.
  Stream<List<int>> get favKuralIndices => _allFavKuralIndicesSubject.stream;

  void _readKurals(BuildContext context) async {
    String kuralJson = await DefaultAssetBundle
        .of(context)
        .loadString('assets/kuralList.json');
    kurals = new Kurals.fromJson(kuralJson);
    _fetchingKuralsSubject.add(false);
  }

  void _readFavs() async {
    _allFavsIndices = (await readFavorites()).toList();
    _allFavsIndices.sort();
    _allFavKuralIndicesSubject.add(_allFavsIndices);
    _fetchingFavoritesSubject.add(false);
  }

  /// Take care of closing streams.
  void dispose() {
    _allFavKuralIndicesSubject.close();
    _fetchingFavoritesSubject.close();
    _fetchingKuralsSubject.close();
    _favIndexAdditionController.close();
    _favIndexRemovalController.close();
  }

  /// Business logic for adding new favorites
  void _handleAddition(int favIndex) {
    _allFavsIndices.add(favIndex);
    _updateFavsAndPersist();
  }

  /// Business logic for adding new favorites
  void _handleRemoval(int favIndex) {
    _allFavsIndices.remove(favIndex);
    _updateFavsAndPersist();
  }

  void _updateFavsAndPersist() {
    writeFavoriteList(_allFavsIndices.toSet());
    _allFavKuralIndicesSubject.add(_allFavsIndices);
  }
}
