import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

import '../models/Portfolio.dart';
import '../models/Language.dart';
import '../models/BuildUtils.dart';

import '../widget/portfolio_table_card.dart';
import '../widget/portfolio_summary_card.dart';
import '../widget/portfolio_allocation_card.dart';

class PortfolioView extends StatefulWidget {
  final Portfolio portfolio;
  PortfolioView({
    Key key,
    @required this.portfolio
  }) : super(key: key);

  @override
  _PortfolioView createState() => _PortfolioView();
}

class _PortfolioView extends State<PortfolioView> {
  Language language;

  @override
  void initState() {
    super.initState();
    language = Language.language;
  }

  Future<void> _refresh() async {
    await widget.portfolio.getAssetData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
          child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: widget.portfolio.hasValue() ?
                      portfolioIsNotEmpty() :
                      portfolioIsEmpty()
                  ),
                ),
              ]))
      );
  }

  List<Widget> portfolioIsEmpty() {
    return [
      BuildUtils.buildEmptySpaceHeight(context, 0.005),
      Text(
        '${Language.language.map["PORTFOLIO_EMPTY"]}',
        style: BuildUtils.headerTextStyle(context),
      ),
      BuildUtils.buildEmptySpaceHeight(context, 0.8),
      Text(
        '${Language.language.map["PORTFOLIO_EMPTY_HELP"]}',
        style: BuildUtils.headerTextStyle(context, 0.015),
      ),
      BuildUtils.buildEmptySpaceHeight(context, 0.05),
    ];
  }

  List<Widget> portfolioIsNotEmpty() {
    return [
      BuildUtils.buildEmptySpaceHeight(context, 0.005),

      // SUMMARY CARD
      PortfolioSummaryCard(portfolio: widget.portfolio),
      BuildUtils.buildEmptySpaceHeight(context, 0.005),

      // PORTFOLIO ALLOCATION
      PortfolioAllocationCard(portfolio: widget.portfolio),
      BuildUtils.buildEmptySpaceHeight(context, 0.005),

      // PORTFOLIO TABLE
      PortfolioTableCard(portfolio: widget.portfolio),
      BuildUtils.buildEmptySpaceHeight(context, 0.005),
    ];
  }
}