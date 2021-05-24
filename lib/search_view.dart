import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'models/Asset.dart';
import 'models/BuildUtils.dart';

import 'asset_view.dart';

class SearchView extends StatefulWidget {
  SearchView({Key key}) : super(key: key);

  @override
  _SearchView createState() => _SearchView();
}

class _SearchView extends State<SearchView> {
  Future<bool> gotData;

  @override
  void initState() {
    super.initState();
    gotData = Asset.getCoinsList(250);
  }

  Future<void> _refresh() async {
    await Asset.getCoinsList(250);
    setState(() {});
  }

  Widget buildAssetCard(Asset asset) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AssetView(asset: asset)),
        );
      },
      child: Container(
          height: MediaQuery.of(context).size.height * .06,
          width: MediaQuery.of(context).size.width * .98,
          decoration: BuildUtils.buildBoxDecoration(context),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('${asset.marketCapRank}',
                            style: BuildUtils.headerTextStyle(
                                context, 0.025, FontWeight.bold)),
                        Text('${asset.name}',
                            style: BuildUtils.headerTextStyle(context)),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text('\$${Asset.valueToText(asset.price)}',
                            style: BuildUtils.headerTextStyle(context, 0.03, FontWeight.bold),),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                              '${asset.priceChangePercent != null ? Asset.valueToText(asset.priceChangePercent) : '-'}%',
                              style: BuildUtils.pnlTextStyle(
                                  context,
                                  asset.priceChangePercent != null
                                      ? asset.priceChangePercent > 0
                                      : true, 0.02)),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
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
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    return Text('');
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('${snapshot.error}',
                          style: TextStyle(color: Colors.red));
                    } else {
                      return RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            itemCount: Asset.assetList.length,
                            itemBuilder: (context, i) {
                              return Column(
                                children: [
                                  BuildUtils.buildEmptySpaceHeight(
                                      context, 0.002),
                                  buildAssetCard(Asset.assetList[i]),
                                  BuildUtils.buildEmptySpaceHeight(
                                      context, 0.002)
                                ],
                              );
                            },
                          ));
                    }
                }
                return CircularProgressIndicator();
              })),
    );
  }
}
