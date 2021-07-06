import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/widgets.dart';

class StateHolder<W extends StatefulWidget, S extends State<W>> {
  final _states = Set<S>();

  S? get lastOrNull => _states.isNotEmpty ? _states.last : null;

  S? operator [](W widget) =>
      _states.firstWhereOrNull((it) => it.widget == widget);

  void add(S state) => _states.add(state);
  void remove(S state) => _states.remove(state);
}
