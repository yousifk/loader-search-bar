import 'package:flutter/material.dart';
import 'package:loader_search_bar/loader_search_bar.dart';

void main() {
  runApp(MaterialApp(
    home: CallbackSearchBarPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class CallbackSearchBarPage extends StatefulWidget {
  @override
  MergedBarPageState createState() => MergedBarPageState();
}

class MergedBarPageState extends State<CallbackSearchBarPage> {
  String _queryText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(
        iconified: false,
        defaultAppBar: _appBar,
        onQueryChanged: (query) => _onQueryChanged(context, query),
        onQuerySubmitted: (query) => _onQuerySubmitted(context, query),
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
        title: Text('Search bar example'),
      );

  Container get _body {
    return Container(
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Callback example', style: TextStyle(fontSize: 18.0)),
          Container(margin: EdgeInsets.only(top: 8.0)),
          Text(_queryText, style: TextStyle(fontSize: 18.0)),
        ],
      ),
    );
  }

  Drawer get _drawer => Drawer();

  _onQueryChanged(BuildContext context, String query) {
    setState(() => _queryText = 'Query changed: $query');
  }

  _onQuerySubmitted(BuildContext context, String query) {
    setState(() => _queryText = 'Query submitted!');
  }
}
