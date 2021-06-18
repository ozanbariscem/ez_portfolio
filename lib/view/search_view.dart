import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/Asset.dart';
import '../models/Language.dart';
import '../models/BuildUtils.dart';

import '../widget/search_result_card.dart';
import '../widget/search_card.dart';

class SearchView extends StatefulWidget {
  SearchView({Key key}) : super(key: key);

  @override
  _SearchView createState() => _SearchView();
}

class _SearchView extends State<SearchView> {
  Future<bool> gotData;
  List searchResults;
  bool isSearching;

  @override
  void initState() {
    super.initState();
    searchResults = [];
    isSearching = false;
    // TODO: Add pagination
    gotData = Asset.getCoinsList(2000);
  }

  Future<void> _refresh() async {
    await Asset.getCoinsList(2000);
    setState(() {});
  }

  Widget buildSearchResult() {
    var coinList = Asset.assetList;
    if (isSearching) {
      if (searchResults.length == 0)
        return Text(
          Language.language.map["SEARCH_NOT_FOUND"],
          style: BuildUtils.headerTextStyle(context),);
      else
        coinList = searchResults;
    }
    return ListView.builder(
      itemCount: coinList.length,
      itemBuilder: (context, i) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BuildUtils.buildEmptySpaceHeight(
                context, 0.002),
            SearchResultCard(asset: coinList[i]),
            BuildUtils.buildEmptySpaceHeight(
                context, 0.002)
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Language.language.map["SEARCH"])),
      resizeToAvoidBottomInset: false,
      backgroundColor: BuildUtils.backgroundColor,
      body: Center(
          child: FutureBuilder<bool>(
              future: gotData,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.waiting:
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            BuildUtils.buildEmptySpaceHeight(context, 0.02),
                            Text(
                              Language.language.map["SEARCH_WAIT"],
                              style: BuildUtils.linkTextStyle(
                                  context: context,
                                  fontSize: 0.02,
                                  fontWeight: FontWeight.bold
                              )
                            )
                          ],
                        ));
                  case ConnectionState.active:
                    return Text('');
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('${snapshot.error}',
                          style: TextStyle(color: Colors.red));
                    } else {
                      return RefreshIndicator(
                          onRefresh: _refresh,
                          child: Column(
                            children: [
                              BuildUtils.buildEmptySpaceHeight(context, 0.005),
                              SearchCard(
                                onTextChanged: (isSearching, results) {
                                  setState(() {
                                    this.isSearching = isSearching;
                                    this.searchResults = results;
                                  });
                                },
                              ),
                              BuildUtils.buildEmptySpaceHeight(context, 0.005),
                              Container(
                                height: MediaQuery.of(context).size.height * .8,
                                // Listview.builder creates items in the list as we scroll down
                                child : buildSearchResult()
                              )
                            ],
                          ));
                    }
                }
                return CircularProgressIndicator();
              })),
    );
  }
}
