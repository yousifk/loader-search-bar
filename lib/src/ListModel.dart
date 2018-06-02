import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef RemovedItemBuilder<T>(
    T item, BuildContext context, Animation animation);

class ListModel<T> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    this.animationDuration = DEFAULT_ANIM_DURATION,
    Iterable<T> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = new List<T>.from(initialItems ?? <T>[]);

  static const DEFAULT_ANIM_DURATION = Duration(milliseconds: 300);
  static const NO_ANIM_DURATION = Duration(milliseconds: 0);

  final GlobalKey<AnimatedListState> listKey;

  final RemovedItemBuilder<T> removedItemBuilder;

  final Duration animationDuration;

  final List<T> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, T item) {
    _items.insert(index, item);
    _animatedList.insertItem(index, duration: animationDuration);
  }

  T removeAt(int index) {
    final T removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (context, animation) =>
            removedItemBuilder(removedItem, context, animation),
        duration: animationDuration,
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  T operator [](int index) => _items[index];

  int indexOf(T item) => _items.indexOf(item);

  bool contains(T item) => _items.contains(item);

  Iterable<T> where(bool test(T item)) => _items.where(test);

  bool equals(List<T> other) => IterableEquality().equals(_items, other);
}
