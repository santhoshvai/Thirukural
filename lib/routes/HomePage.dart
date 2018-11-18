import 'package:flutter/material.dart';
import '../BottomBarScreens/KuralExpansion.dart';
import '../BottomBarScreens/FavoriteKurals.dart';
import '../models/kurals.dart';
import '../constants.dart';
import '../bloc/KuralProvider.dart';
import '../bloc/KuralBloc.dart';

class BottomBarBodyView {
  final Widget body;
  final AnimationController controller;
  CurvedAnimation _animation;

  BottomBarBodyView({Widget body, TickerProvider vsync}):
        assert(body != null),
        assert(vsync != null),
        body = body,
        controller = new AnimationController(
          duration: const Duration(milliseconds: 500),
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  FadeTransition transition(BuildContext context) {
    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: body,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _screen = 0;
  bool _fetching = true;
  List<BottomBarBodyView> _botBarBodyViews =  <BottomBarBodyView>[];

  _getKurals() async {
    String kuralJson = await DefaultAssetBundle
        .of(context)
        .loadString('assets/kuralList.json');
    final kurals = new Kurals.fromJson(kuralJson);

    final list = <BottomBarBodyView>[
      new BottomBarBodyView(
        body: new KuralExpansion(kurals),
        vsync: this,
      ),
      new BottomBarBodyView(
        body: new FavoriteKurals(kurals),
        vsync: this,
      ),
      // TODO settings view
//      new BottomBarBodyView(
//        body: new AnimatedListSample(),
//        vsync: this,
//      )
    ];

    // initialise the animation controllers
    for (BottomBarBodyView view in _botBarBodyViews) {
      view.controller.addListener(_rebuild);
    }
    list[_screen].controller.value = 1.0;

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _fetching = false;
      _botBarBodyViews = list;
    });
  }

  @override
  void dispose() {
    for (BottomBarBodyView view in _botBarBodyViews)
      view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getKurals();
  }

  _onBottomBarTap(int index) {
    _botBarBodyViews[_screen].controller.reset();
    _botBarBodyViews[index].controller.forward();
    setState(() {
      _screen = index;
    });
  }

  Widget _getCentreProgress() {
    return Center(
      child: new CircularProgressIndicator(
        value: null,
      ),
    );
  }

  Widget _buildTransitionWidget(KuralBloc kuralBloc) {
    return StreamBuilder<bool>(
      stream: kuralBloc.fetchingKurals,
      initialData: true,
      builder: (context, snapshot) => _getBody(context, snapshot)
    );
  }

//    (context, snapshot) => {
//    if (snapshot.data) {
//    return _getCentreProgress();
//    }
//    return _botBarBodyViews[_screen].transition(context);
//    })
//  }

  Widget _getBody(BuildContext context, AsyncSnapshot<bool> snapshot) {
    if (snapshot.data) return _getCentreProgress();
    return _botBarBodyViews[_screen].transition(context);
  }



  @override
  Widget build(BuildContext context) {
    final kuralBloc = KuralProvider.of(context);
    kuralBloc.fetchingKurals.listen(onData)

    final botNavBar = new BottomNavigationBar(
      items: kBottombarMenu
          .map((e) => new BottomNavigationBarItem(icon: new Icon(e[0]), title: new Text(e[1])))
          .toList(),
      currentIndex: _screen,
      onTap: _onBottomBarTap,
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          kAppBarTitles[_screen],
        ),
      ),
      body: _buildTransitionWidget(),
      bottomNavigationBar: botNavBar
    );
  }
}
