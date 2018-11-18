import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../constants.dart';
import 'package:thirukural/models/kurals.dart';
import '../utils.dart';

class KuralDetail extends StatefulWidget {
  final Kural kural;
  final String athigaram;
  final String paal;
  final int index;

  KuralDetail(this.kural, this.athigaram, this.paal, this.index);

  @override
  _KuralDetailState createState() =>
      new _KuralDetailState();
}

class _KuralDetailState extends State<KuralDetail> {
  bool _isFavorite = false;
  Set<dynamic> _allFavs = [].toSet();
  BuildContext _scaffoldContext;

  _KuralDetailState();

  _share() {
    Share.share(widget.kural.getShareText());
  }

  _favoriteToggle() async {
    if (!_isFavorite) {
      _allFavs.add(widget.index);
    } else {
      _allFavs.remove(widget.index);
    }
    writeFavoriteList(_allFavs);

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    bool wasFav = _isFavorite;
    ScaffoldState scaffoldState = Scaffold.of(_scaffoldContext);
    scaffoldState.removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
    String favoriteNotification =
        "${wasFav ? 'Removed' : 'Added'} ${wasFav ? 'from' : 'to'} favorites";
    scaffoldState.showSnackBar(SnackBar(content: Text(favoriteNotification)));

    setState(() {
      _isFavorite = !wasFav;
    });
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  _findIfFavorite() async {
    _allFavs = await readFavorites();

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.

    if (!mounted) return;
    setState(() {
      _isFavorite = _allFavs.contains(widget.index);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 4.0),
      child: new Text(
        widget.kural.tamil,
        overflow: TextOverflow.fade,
        softWrap: true,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13.0,
          height: 1.5,
        ),
      ),
    );

    Widget subtitle = new Container(
      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
      child: new Text(
        _capitalize(widget.kural.transliteration.toLowerCase()),
        overflow: TextOverflow.fade,
        softWrap: true,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13.0,
          height: 1.5,
        ),
      ),
    );

    Widget subsection = new Container(
      color: Theme.of(context).primaryColor.withAlpha(50),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: new Center(
        child: new Text(
          "${widget.athigaram}, ${widget.paal}",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    Widget _getCard(String title, String data) {
      return new Card(
        child: new Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2.0,
                  vertical: 2.0,
                ),
                child: new Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2.0,
                  vertical: 2.0,
                ),
                child: new Text(
                  data,
                ),
              ),
            ],
          ),
        ),
      );
    }

    String favoriteTooltip =
        "${_isFavorite ? 'Remove' : 'Add'} ${_isFavorite ? 'from' : 'to'} favorites";
    Icon favIcon = new Icon(_isFavorite ? Icons.star : Icons.star_border);
    
    Widget buttonContainer = SafeArea(
          child: Container(
              color: Colors.deepPurple[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: _share,
                      textColor: Colors.deepPurple[500],
                      icon: Icon(Icons.share),
                      label: Text("Share")),
                  FlatButton.icon(
                      onPressed: _favoriteToggle,
                      icon: favIcon,
                      textColor: Colors.deepPurple[500],
                      label: Text(favoriteTooltip)),
                ],
              )));

    Widget body = ListView(
      children: <Widget>[
        title,
        subtitle,
        subsection,
        _getCard(kVilakam, widget.kural.tamilExplanation1),
        _getCard(kVilakam2, widget.kural.tamilExplanation2),
        _getCard(kEnglishExplanation, widget.kural.englishExplanation),
      ],
    );
      return Scaffold(
        appBar: new AppBar(
          title: new Text("$kKural ${widget.index + 1}"),
        ),
        body: Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return body;
        }),
        bottomNavigationBar: buttonContainer,
      );
  }
}
