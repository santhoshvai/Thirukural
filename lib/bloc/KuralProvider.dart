import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import './KuralBloc.dart';

/// This is an InheritedWidget that wraps around [KuralBloc]. Think about this
/// as Scoped Model for that specific class.
///
/// This merely solves the "passing reference down the tree" problem for us.
/// You can solve this in other ways, like through dependency injection.
///
/// Also note that this does not call [KuralBloc.dispose]. If your app
/// ever doesn't need to access the cart, you should make sure it's
/// disposed of properly.
class KuralProvider extends InheritedWidget {
  final KuralBloc kuralBloc;

  KuralProvider({
    Key key,
    @required this.kuralBloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static KuralBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(KuralProvider) as KuralProvider)
          .kuralBloc;
}