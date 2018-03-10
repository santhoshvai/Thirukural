import 'package:flutter/material.dart';
import '../constants.dart';
import '../kurals.dart';
import '../utils.dart';

class KuralDetail extends StatefulWidget {
  final Kural kural;
  final String athigaram;
  final String paal;
  final int index;

  KuralDetail(this.kural, this.athigaram, this.paal, this.index);

  @override
  _KuralDetailState createState() => new _KuralDetailState(kural, athigaram, paal, index);
}

class _KuralDetailState extends State<KuralDetail> {
  final Kural kural;
  final String athigaram;
  final String paal;
  final int index;
  bool _isFavorite = false;
  Set<int> _allFavs = [].toSet();

  _KuralDetailState(this.kural, this.athigaram, this.paal, this.index);

  _share() {
  }

  _favoriteToggle() {
    if (!_isFavorite) {
      _allFavs.add(index);
    } else {
      _allFavs.remove(index);
    }
    writeFavoriteList(_allFavs);

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  _findIfFavorite() async {
    _allFavs = await readFavorites();
    _isFavorite = _allFavs.contains(index);
  }

  @override
  void initState() {
    super.initState();
    _findIfFavorite();
  }

  /*
  Font sizes:
    subheading - 17
    body - 15
    caption - 13
   */
  @override
  Widget build(BuildContext context) {

    Widget title = new Container(
      padding: const EdgeInsets.all(12.0),
      child: new Text(
        kural.tamil,
        overflow: TextOverflow.fade,
        softWrap: true,
        textAlign: TextAlign.left,
        style: new TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13.0,
          height: 1.5,
        ),
      ),
    );

    Widget subtitle = new Container(
      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
      child: new Text(
        _capitalize(kural.transliteration.toLowerCase()),
        overflow: TextOverflow.fade,
        softWrap: true,
        textAlign: TextAlign.left,
        style: new TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13.0,
          height: 1.5,
        ),
      ),
    );

    Widget subsection = new Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: new Center(
        child: new Text(
          "$athigaram, $paal",
          style: new TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    Widget _getCard(String title, String data) {
//      var unescape = new HtmlUnescape();
//      data = unescape.convert(data);
      return new Card(
        child: new Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                title,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Text(
                data,
              ),
            ],
          ),
        ),
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("$kKural ${index+1}"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.share),
            tooltip: "Share kural ${index+1}",
            onPressed: _share,
          ),
          new IconButton(
            icon: new Icon(_isFavorite? Icons.star : Icons.star_border),
            tooltip: "${_isFavorite? 'Remove' : 'Add'} kural ${index+1} ${_isFavorite? 'from' : 'to'} favorites",
            onPressed: _favoriteToggle,
          ),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          title,
          subtitle,
          subsection,
          _getCard(kVilakam, kural.tamilExplanation1),
          _getCard(kVilakam2, kural.tamilExplanation2),
          _getCard(kEnglishExplanation, kural.englishExplanation),
//          _getCard(englishKural, kural.english),
        ],
      ),
    );
  }
}
