import 'package:flutter/material.dart';

class InheritedSearchQuery extends InheritedWidget {
  InheritedSearchQuery({
    required this.query,
    required Widget child,
  }) : super(child: child);

  static String? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedSearchQuery>()!.query;

  final String? query;

  @override
  bool updateShouldNotify(InheritedSearchQuery old) =>
      query != null && old.query != query;
}
