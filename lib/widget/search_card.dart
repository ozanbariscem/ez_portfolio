import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Asset.dart';
import '../models/Language.dart';
import '../models/BuildUtils.dart';

class SearchCard extends StatefulWidget {
  Function(bool, List) onTextChanged;

  SearchCard({Key key, @required this.onTextChanged}) : super(key: key);

  @override
  _SearchCard createState() => _SearchCard();
}

class _SearchCard extends State<SearchCard> {
  bool isSearching;

  @override
  void initState() {
    super.initState();
    isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .06,
      width: MediaQuery.of(context).size.width * .98,
      decoration: BuildUtils.buildBoxDecoration(context),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * .01),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildInput(context),
            buildIcon(context)
          ],
        )
      )
    );
  }

  Widget buildInput(BuildContext context) {
    return Expanded(
        flex: 9,
        child: Container(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: Language.language.map["SEARCH_TIP"],
              ),
              onChanged: (text) {
                isSearching = text != "";
                if (!isSearching) {
                  widget.onTextChanged?.call(isSearching, []);
                }
                else {
                  searchFor(text).then((result) {
                    widget.onTextChanged?.call(isSearching, result);
                  }
                  );
                }
              },
            )
        )
    );
  }

  Widget buildIcon(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
            child: Icon(
              CupertinoIcons.search,
              color: BuildUtils.barColor,
            )
        )
    );
  }

  Future<List> searchFor(String coinName) async {
    return Asset.assetList
        .where((element) {
          return element.name.toLowerCase().contains(coinName.toLowerCase()) ||
              element.symbol.toLowerCase().contains(coinName.toLowerCase());
        })
        .take(5)
        .toList();
  }
}
