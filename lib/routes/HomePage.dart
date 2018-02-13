import 'package:flutter/material.dart';
import '../BottomBarScreens/KuralExpansion.dart';
import '../BottomBarScreens/FavoriteKurals.dart';
import '../kurals.dart';
import '../constants.dart';
import 'Sample.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _screen = 0;
  Kurals _kurals = new Kurals();
  bool _fetching = true;

  _getKurals() async {
    String kuralJson = await DefaultAssetBundle
        .of(context)
        .loadString('assets/kuralList.json');
    final kurals = new Kurals.fromJson(kuralJson);

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _kurals = kurals;
      _fetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getKurals();
  }

  _onPress() {
    int index = 17;
    Kural kural = _kurals.kurals[17];
    Athigaram athigaram = _kurals.athigaarams[kural.athigaramIndex];
    String paal = _kurals.paals[athigaram.paalIndex];
    Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) =>
            new AnimatedListSample(),
//              new KuralDetail(kural, athigaram.name, paal, index),
        ));
  }

  _onBottomBarTap(int index) {
    setState(() {
      _screen = index;
    });
  }

  Widget _getCentreProgress() {
    return new Center(
      child: new CircularProgressIndicator(
        value: null,
      ),
    );
  }

  Widget _getBody() {
    if (_fetching) {
      return _getCentreProgress();
    }
    if (_screen == 0) {
      return new KuralExpansion(_kurals);
    } else if(_screen == 1) {
      return new FavoriteKurals(_kurals);
    } else {
      return new AnimatedListSample();
      return new FlatButton(
        onPressed: _onPress,
        child: new Text("Change"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          kHomepageTitle,
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: new BottomNavigationBar(
        items: kBottombarMenu
            .map((e) => new BottomNavigationBarItem(
                  icon: new Icon(e[0]),
                  title: new Text(e[1]),
                ))
            .toList(),
        currentIndex: _screen,
        onTap: _onBottomBarTap,
      ),
    );
  }
}
