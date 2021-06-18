import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Portfolio.dart';
import '../models/Language.dart';
import '../models/Asset.dart';
import '../models/BuildUtils.dart';

class PortfolioSummaryCard extends StatefulWidget {
  final Portfolio portfolio;
  PortfolioSummaryCard({
    Key key,
    @required this.portfolio
  }) : super(key: key);

  @override
  _PortfolioSummaryCard createState() => _PortfolioSummaryCard();
}

class _PortfolioSummaryCard extends State<PortfolioSummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .10,
      width: MediaQuery.of(context).size.width * .98,
      decoration: BuildUtils.buildBoxDecoration(context),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * .01),
        child: Row(
          children: [
            buildTotals(context),
            VerticalDivider(color: Colors.grey),
            buildPNL(context)
          ],
        )
      )
    );
  }

  Widget buildTotals(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildTotalValue(context)
              ],
            )
        )
    );
  }

  Widget buildTotalValue(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      child: AutoSizeText(
                        '${Language.language.map["NETWORTH"]}',
                        style: BuildUtils.headerTextStyle(context, 0.03, FontWeight.bold),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      )
                    )
                ),
                Divider(color: Colors.grey),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: AutoSizeText(
                        '\$${Asset.valueToText(widget.portfolio.networth)}',
                        style: BuildUtils.headerTextStyle(context, 0.03),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      )
                    )
                ),
              ],
            )
        )
    );
  }

  Widget buildPNL(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
            child: Row(
                children: [
                    buildDailyPNL(context),
                    BuildUtils.buildEmptySpaceWidth(context, 0.025),
                    buildTotalPNL(context),
                ],
            )
        )
    );
  }

  Widget buildDailyPNL(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
            child: Column(
              children: [
                BuildUtils.buildEmptySpaceHeight(context, 0.01),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: AutoSizeText(
                          '${Language.language.map["DAILYPNL"]}',
                          style: BuildUtils.headerTextStyle(context, 0.025, FontWeight.bold),
                          maxLines: 1,
                        )
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: AutoSizeText(
                            '\$${Asset.valueToText(widget.portfolio.dailyPnl)}',
                            style: BuildUtils.pnlTextStyle(
                                context, widget.portfolio.dailyPnl > 0, 0.25, FontWeight.normal),
                            maxLines: 1,
                        )
                    )
                )
              ],
            )
        )
    );
  }

  Widget buildTotalPNL(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
            child: Column(
              children: [
                BuildUtils.buildEmptySpaceHeight(context, 0.01),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: AutoSizeText(
                            '${Language.language.map["TOTALPNL"]}',
                            style: BuildUtils.headerTextStyle(context, 0.025, FontWeight.bold),
                            maxLines: 1,
                        )
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: AutoSizeText(
                            '\$${Asset.valueToText(widget.portfolio.pnl)}',
                            style: BuildUtils.pnlTextStyle(
                                context, widget.portfolio.pnl > 0, 0.25, FontWeight.normal),
                            maxLines: 1,
                        )
                    )
                )
              ],
            )
        )
    );
  }
}