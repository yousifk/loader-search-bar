import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'InheritedSearchWidget.dart';
import 'ListModel.dart';

typedef List<T> QuerySetCall<T>(String query);

typedef Widget QuerySetItemBuilder<T>(T item);

/// Widget that loads data set for current query string and transforms it into
/// ListView populated with loaded data.
class QuerySetLoader<T> extends StatefulWidget {
  QuerySetLoader({
    @required this.querySetCall,
    @required this.itemBuilder,
    this.loadOnEachChange = false,
    this.animateChanges = true,
  });

  /// Instance with empty function bodies used internally by [SearchBar].
  static final QuerySetLoader blank =
      QuerySetLoader(querySetCall: (_) {}, itemBuilder: (_) {});

  /// Function being called in order to load data. Takes query string as
  /// argument and returns list of corresponding items. Received function is
  /// called asynchronously within the loader.
  final QuerySetCall<T> querySetCall;

  /// Function taking single element of current data set and returning ListView
  /// item corresponding to that element.
  final QuerySetItemBuilder<T> itemBuilder;

  /// Indicating whether [querySetCall] should be triggered on each query
  /// change. If false query set is loaded once user submits query.
  final bool loadOnEachChange;

  /// Determines whether ListView's insert and remove operations should be
  /// animated.
  final bool animateChanges;

  @override
  QuerySetLoaderState createState() => QuerySetLoaderState<T>();
}

class QuerySetLoaderState<T> extends State<QuerySetLoader<T>> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  ListModel<T> _listModel;

  bool _loaded = true;

  StreamSubscription<List<T>> _querySetStream;

  @override
  void initState() {
    super.initState();
    _listModel = ListModel<T>(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: _buildAnimatedItem,
      animationDuration: widget.animateChanges
          ? ListModel.DEFAULT_ANIM_DURATION
          : ListModel.NO_ANIM_DURATION,
    );
  }

  StreamSubscription<List> _getQuerySetStream(BuildContext context) {
    return _loadQuerySet(context)
        .asStream()
        .listen(_onQuerySetData, onError: (_) => _onQuerySetData([]));
  }

  Future<List<T>> _loadQuerySet(BuildContext context) async {
    final query = InheritedSearchQuery.of(context);
    return query != null ? widget.querySetCall(query) : [];
  }

  void _onQuerySetData(List<T> data) {
    if (!_listModel.equals(data)) {
      _removeItems(data);
      _insertItems(data);
    }
    setState(() {
      _loaded = true;
      _querySetStream = null;
    });
  }

  void _removeItems(List<T> items) {
    final toRemove = _listModel.where((it) => !items.contains(it)).toList();
    toRemove.forEach((item) {
      final index = _listModel.indexOf(item);
      if (index != -1) _listModel.removeAt(index);
    });
  }

  void _insertItems(List<T> items) {
    final toInsert = items.where((it) => !_listModel.contains(it)).toList();
    toInsert.forEach((item) {
      final index = items.indexOf(item);
      if (index != -1) _listModel.insert(index, item);
    });
  }

  void _cancelQuerySetLoad() {
    if (_querySetStream != null) {
      _querySetStream.cancel();
      _querySetStream = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildAnimatedList();
    if (_loaded) {
      _loaded = false;
      return items;
    } else {
      _cancelQuerySetLoad();
      _querySetStream = _getQuerySetStream(context);
      return _coverItemsWithProgressIndicator(items);
    }
  }

  Widget _buildAnimatedList() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        color: Colors.black12,
        child: AnimatedList(
          key: _listKey,
          itemBuilder: _buildListItem,
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index, Animation animation) =>
      _buildAnimatedItem(_listModel[index], context, animation);

  Widget _buildAnimatedItem(T item, BuildContext _, Animation animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: widget.itemBuilder(item),
      ),
    );
  }

  Widget _coverItemsWithProgressIndicator(Widget items) {
    return Stack(
      children: [
        items,
        Container(
          color: Colors.black12,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
