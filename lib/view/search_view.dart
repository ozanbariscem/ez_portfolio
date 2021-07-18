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
  ScrollController scrollController;

  bool gotData = false;
  List assetList = [];
  List searchResults = [];
  bool isSearching = false;

  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController()..addListener(scrollListener);

    if (Asset.assetList == null || Asset.assetList.length <= 0) {
      Asset.getEveryCoin().then((value) {
        getAssetList();
      });
    } else {
      getAssetList();
    }
  }

  Future<void> _refresh() async {
    pageNumber = 1;
    assetList = [];
    getAssetList();
  }

  void getAssetList() {
    Asset.getCoinsPage(20, pageNumber).then((value) {
      setState(() {
          gotData = true;
          assetList.addAll(value);
        }
      );
    });
  }

  void scrollListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      // Gets till first 100
      // TODO: Change to total number of coins on coingecko
      if (assetList.length != Asset.assetList.length) {
        pageNumber++;
        getAssetList();
      }
    }
  }

  Widget buildSearchResult() {
    var coinList = assetList;
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
      controller: scrollController,
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

  Widget buildList() {
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

  Widget buildWait() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Language.language.map["SEARCH"])),
      resizeToAvoidBottomInset: false,
      backgroundColor: BuildUtils.backgroundColor,
      body: Center(
          child:
          gotData ? buildList() : buildWait()
      ),
    );
  }
}
