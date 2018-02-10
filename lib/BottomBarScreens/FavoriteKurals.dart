import 'package:flutter/material.dart';
import '../constants.dart';
import '../kurals.dart';
import '../utils.dart';

typedef void FavEditCallback(int index);

class FavoriteKurals extends StatefulWidget {
  final Kurals _kurals;

  FavoriteKurals(this._kurals);

  @override
  _FavoriteKuralsState createState() => new _FavoriteKuralsState(_kurals);
}

class _FavoriteKuralsState extends State<FavoriteKurals> {
  final Kurals _kurals;
  bool _fetching = true;
  List<Kural> _favKurals = [];
  List<int> _allFavsIndices = [];
  ListModel<int> _list;
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();

  _FavoriteKuralsState(this._kurals);

  _getFavorites() async {
    List<int> allFavsIndices = (await readFavorites()).toList();
    allFavsIndices.sort();
    List<Kural> favKurals = [];
    for (int index in allFavsIndices) {
      favKurals.add(_kurals.kurals[index]);
    }

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _fetching = false;
      _favKurals = favKurals;
      _allFavsIndices = allFavsIndices;
    });
  }

  _removeFromFavs(int index) async {
    setState(() {
      _allFavsIndices.remove(index);
    });
    writeFavoriteList(_allFavsIndices.toSet());
  }

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  Widget _getCentreProgress() {
    return new Center(
      child: new CircularProgressIndicator(
        value: null,
      ),
    );
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return new CardItem(
      animation: animation,
      index: index,
      kural: _favKurals[index],
      kuralIndex: _allFavsIndices[index],
      onFavEdit: _removeFromFavs,
    );
  }

  Widget _getBody() {
    if (_fetching) {
      return _getCentreProgress();
    }
//    return new ListView.builder(
//      itemCount: _allFavsIndices.length,
//      itemBuilder: (BuildContext context, int index) {
//        return _getListTile(index, _allFavsIndices[index], _favKurals[index], _removeFromFavs);
//      },
//    );
    return new AnimatedList(
      key: _listKey,
      initialItemCount: _allFavsIndices.length,
      itemBuilder: _buildItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getBody();
  }
}

/// Keeps a Dart List in sync with an AnimatedList.
///
/// The [insert] and [removeAt] methods apply to both the internal list and the
/// animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that mutate the
/// list must make the same changes to the animated list in terms of
/// [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    this.listKey,
    this.removedItemBuilder,
    Iterable<E> initialItems,
  }) : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = new List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index, (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  int get length => _items.length;
  E operator [](int index) => _items[index];
  int indexOf(E item) => _items.indexOf(item);
}

Widget _getListTile(int index, int kuralIndex, Kural kural, FavEditCallback onFavEdit) {
  return new Card(
    child: new Column(
      children: <Widget>[
        new ListTile(
          title: new Text(
            kural.tamil,
          ),
          isThreeLine: true,
          subtitle: new Text("$kKural ${kuralIndex+1}"),
        ),
        new ButtonTheme.bar(
          // make buttons use the appropriate styles for cards
          child: new ButtonBar(
            children: <Widget>[
              new FlatButton(
                child: const Text('REMOVE'),
                onPressed: () => onFavEdit(kuralIndex),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class CardItem extends StatelessWidget {
  const CardItem({
    Key key,
    this.animation,
    this.onFavEdit,
    this.kural,
    this.index,
    this.kuralIndex,
  }) : assert(animation != null),
        assert(index != null && index >= 0),
        assert(kuralIndex != null && kuralIndex >= 0),
        super(key: key);

  final Animation<double> animation;
  final FavEditCallback onFavEdit;
  final int index;
  final int kuralIndex;
  final Kural kural;

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
      opacity: animation,
      child: _getListTile(index, kuralIndex, kural, onFavEdit),
    );
  }
}