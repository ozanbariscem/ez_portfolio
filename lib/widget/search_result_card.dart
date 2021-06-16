import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../view/asset_view.dart';
import '../models/Asset.dart';
import '../models/BuildUtils.dart';

class SearchResultCard extends StatefulWidget {
  final Asset asset;

  SearchResultCard({Key key, @required this.asset}) : super(key: key);

  @override
  _SearchResultCard createState() => _SearchResultCard();
}

class _SearchResultCard extends State<SearchResultCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AssetView(asset: widget.asset)),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .07,
        width: MediaQuery.of(context).size.width * .98,
        decoration: BuildUtils.buildBoxDecoration(context),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * .01),
          child: Container(
            width: double.infinity,
            child: Row(
              children: [
                buildRank(context),
                VerticalDivider(color: Colors.grey),
                buildName(context),
                buildPrice(context)
              ],
            )
          )
        )
      ),
    );
  }

  Widget buildRank(BuildContext context) {
    return Expanded(
        flex: 6,
        child: AutoSizeText(
          '${widget.asset.marketCapRank}',
          textAlign: TextAlign.center,
          style: BuildUtils.headerTextStyle(context, 0.025, FontWeight.normal),
          minFontSize: 1,
          maxLines: 1,
        )
    );
  }

  Widget buildName(BuildContext context) {
    return Expanded(
        flex: 70,
        child: AutoSizeText(
          '${widget.asset.name}',
          textAlign: TextAlign.start,
          style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
          maxLines: 1,
        )
    );
  }

  Widget buildPrice(BuildContext context) {
    return Expanded(
        flex: 25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: Container(
                  child: AutoSizeText(
                    '\$${widget.asset.price}',
                    style: BuildUtils.headerTextStyle(context, 0.03, FontWeight.bold),
                    maxLines: 1,
                  ),
                )
            ),
            Expanded(
                child: Container(
                  child: AutoSizeText(
                    '${widget.asset.priceChangePercent != null ? Asset.valueToText(widget.asset.priceChangePercent) : '-'}%',
                    style: BuildUtils.pnlTextStyle(
                        context,
                        widget.asset.priceChangePercent != null
                            ? widget.asset.priceChangePercent > 0
                            : true, 0.02, FontWeight.normal),
                    maxLines: 1,
                  ),
                )
            )
          ],
        )
    );
  }
}