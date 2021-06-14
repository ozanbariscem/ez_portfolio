import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Asset.dart';
import '../models/BuildUtils.dart';

class AssetSummaryCard extends StatefulWidget {
  final Asset asset;

  AssetSummaryCard({Key key, @required this.asset}) : super(key: key);

  @override
  _AssetSummaryCard createState() => _AssetSummaryCard();
}

class _AssetSummaryCard extends State<AssetSummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        //height: MediaQuery.of(context).size.height * .18,
        width: MediaQuery.of(context).size.width * .98,
        decoration: BuildUtils.buildBoxDecoration(context),
        child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * .015),
            child: Container(
                width: double.infinity,
                //color: Colors.orange,
                child: Column(
                  children: [
                    buildProfile(context),
                    BuildUtils.buildEmptySpaceHeight(context),
                    buildInfo(context),
                  ],
                )
            )
        )
    );
  }

  Widget buildProfile(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                          widget.asset.image,
                          width: MediaQuery.of(context).size.height * .035
                      ),
                      BuildUtils.buildEmptySpaceWidth(context, 0.02),
                      Expanded(
                        child: AutoSizeText(
                          widget.asset.name,
                          style: BuildUtils.headerTextStyle(context, 0.03, FontWeight.bold),
                          maxLines: 1,
                        )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height * .06,
                        child: AutoSizeText(
                          'Rank #${widget.asset.marketCapRank}',
                          style: BuildUtils.headerTextStyle(context, 0.015),
                          maxLines: 1,
                        )
                      )
                    ],
                  )
                ],
              )
            )
          ),
          Expanded(
            flex: 5,
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          '\$${widget.asset.price}',
                          textAlign: TextAlign.end,
                          style: BuildUtils.headerTextStyle(
                              context, 0.035, FontWeight.bold),
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: AutoSizeText(
                          '${Asset.valueToText(widget.asset.priceChangePercent)}%',
                          textAlign: TextAlign.end,
                          style: BuildUtils.pnlTextStyle(
                            context, widget.asset.priceChangePercent > 0, 0.02),
                        )
                      )
                    ],
                  )
                ],
              )
            )
          ),
        ],
      )
    );
  }

  Widget buildInfo(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: buildContactInfo(context)),
          Expanded(child: buildMarketInfo(context)),
        ],
      )
    );
  }

  Widget buildContactInfo(BuildContext context) {
    return Container(
      //color: Colors.redAccent,
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.search,
                color: BuildUtils.barColor,
              ),
              InkWell(
                child: AutoSizeText(
                  'Website',
                  style: BuildUtils.linkTextStyle(context: context),
                  maxLines: 1,
                ),
                onTap: () => launch(widget.asset.page),
              )
            ]
          ),
          Row(
            children: <Widget>[
              Icon(
                EvaIcons.twitter,
                color: BuildUtils.barColor,
              ),
              InkWell(
                child: AutoSizeText(
                  'Twitter',
                  style: BuildUtils.linkTextStyle(context: context),
                  maxLines: 1,
                ),
                onTap: () => launch(
                    'https://www.twitter.com/${widget.asset.twitter}'),
              ),
            ],
          )
        ],
      )
    );
  }

  Widget buildMarketInfo(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AutoSizeText(
            'Market Cap',
            style: BuildUtils.headerTextStyle(context, 0.018, FontWeight.bold),
            maxLines: 1,
          ),
          AutoSizeText(
            '\$${Asset.valueToText(widget.asset.marketCap + 0.00)}',
            style: BuildUtils.headerTextStyle(context, 0.018),
            maxLines: 1,
          ),
          BuildUtils.buildEmptySpaceHeight(context, 0.01),
          AutoSizeText(
            'Circulating Supply',
            style: BuildUtils.headerTextStyle(context, 0.018, FontWeight.bold),
            maxLines: 1,
          ),
          AutoSizeText(
            '${Asset.valueToText(widget.asset.circulatingSupply)} / ${widget.asset.maxSupply == null ? '-' : Asset.valueToText(widget.asset.maxSupply)}',
            style: BuildUtils.headerTextStyle(context, 0.018),
            maxLines: 1,
          ),
        ],
      )
    );
  }
}
