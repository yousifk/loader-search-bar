import 'Person.dart';
import 'package:flutter/material.dart';
import 'package:loader_search_bar/loader_search_bar.dart';

void main() {
  runApp(MaterialApp(
    home: LoaderSearchBarPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class LoaderSearchBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(
        iconified: true,
        defaultAppBar: _appBar,
        searchHint: 'Search persons...',
        loader: QuerySetLoader<Person>(
          querySetCall: Person.filterPersonsByQuery,
          itemBuilder: Person.buildPersonRow,
          loadOnEachChange: true,
          animateChanges: true,
        ),
      ),
      body: _body,
      drawer: _drawer,
    );
  }

  AppBar get _appBar => AppBar(
        leading: SearchBarButton(
          icon: Icons.menu,
          color: Colors.black,
          onPressed: () {},
        ),
        title: Text('Loader example'),
      );

  Widget get _body => Container(
        color: Colors.black12,
        child: Center(
          child: Text(
            'Iconified bar page',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );

  Drawer get _drawer => Drawer();
}
