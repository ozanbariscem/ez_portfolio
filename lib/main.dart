import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pie_chart/pie_chart.dart';

import 'models/Asset.dart';
import 'models/Portfolio.dart';
import 'models/Language.dart';
import 'models/BuildUtils.dart';

import 'view/asset_view.dart';
import 'view/search_view.dart';
import 'view/portfolio_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nana\'s Coins',
      theme: ThemeData(
        primarySwatch: BuildUtils.barColor, //red, indigo, deepPurple, blueGrey
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Nana\'s Coins'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Language language;
  Portfolio portfolio;

  bool gotPortfolio;
  bool gotData;

  @override
  void initState() {
    super.initState();
    language = Language.changeLanguage(Language.TURKISH);
    gotPortfolio = false;
    gotData = false;

    portfolio = new Portfolio();
    portfolio.getPortfolio().then((value) {
      gotPortfolio = value;
      if (gotPortfolio) {
        print('Got portfolio');
        portfolio.getAssetData().then((value) {
          print('Got data');
          gotData = value;
          if (value)
            setState(() {});
        });
      }
    });
  }

  Future<void> _refresh() async {
    await portfolio.getAssetData();
    setState(() {});
  }

  Widget splashScreen(BuildContext context, String title) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/icon.png',
                  width: MediaQuery.of(context).size.height * .07,
                  height: MediaQuery.of(context).size.height * .07),
              BuildUtils.buildEmptySpaceWidth(context, 0.02),
              Text(
                title,
                style: BuildUtils.headerTextStyle(
                    context, 0.05, FontWeight.bold),)
            ],
          ),
          BuildUtils.buildEmptySpaceHeight(context, 0.02),
          CircularProgressIndicator()
        ],
      ),
    );
  }
  Widget appBar(BuildContext context, String title) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/icon.png',
            width: MediaQuery.of(context).size.height * .05,
            height: MediaQuery.of(context).size.height * .05),
          BuildUtils.buildEmptySpaceWidth(context, 0.02),
          Text(title)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gotData ? AppBar(
        title: appBar(context, widget.title),
      ) : null,
      resizeToAvoidBottomInset: false,
      backgroundColor: BuildUtils.backgroundColor,
      body: gotData ? Center(
          child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: gotData ?
                            PortfolioView(portfolio: portfolio) :
                            [Text('Getting there')],
                        ),
                      )
      : splashScreen(context, widget.title),
      floatingActionButton: gotData ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchView()),);
        },
        tooltip: 'Search',
        child: Icon(EvaIcons.search),
      ) : null,
    );
  }
}
