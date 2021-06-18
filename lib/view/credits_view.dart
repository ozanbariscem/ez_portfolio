import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Language.dart';
import '../models/BuildUtils.dart';

class CreditsView extends StatefulWidget {
  CreditsView({Key key}) : super(key: key);

  @override
  _CreditsView createState() => _CreditsView();
}

class _CreditsView extends State<CreditsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Language.language.map["CREDITS"])),
        backgroundColor: BuildUtils.backgroundColor,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/icon.png',
                              width: MediaQuery.of(context).size.height * .03,
                              height: MediaQuery.of(context).size.height * .03),
                          BuildUtils.buildEmptySpaceWidth(context, 0.02),
                          AutoSizeText(
                            'Nana\'s Coins',
                            style: BuildUtils.headerTextStyle(context, 0.03, FontWeight.bold),)
                        ],
                      ),
                      Divider(color: Colors.grey),
                      AutoSizeText('Nana\'s Coins does not collect any data.',
                        style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
                        textAlign: TextAlign.center,),
                      AutoSizeText('3rd party packages we use might though.',
                        style: BuildUtils.headerTextStyle(context),
                        textAlign: TextAlign.center,),
                      AutoSizeText('Please refer to their respective sites.',
                        style: BuildUtils.headerTextStyle(context),
                        textAlign: TextAlign.center,),
                      InkWell(
                          onTap: () { launch('https://flutter.dev/'); },
                          child: AutoSizeText('Made with Flutter',
                            style: BuildUtils.linkTextStyle(context: context),)
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Column(
                    children: [
                      AutoSizeText('PACKAGES',
                          style: BuildUtils.headerTextStyle(context)),
                      Divider(color: Colors.grey),
                      InkWell(
                          onTap: () { launch('https://pub.dev/packages/pie_chart'); },
                          child: AutoSizeText('pie_chart',
                            style: BuildUtils.linkTextStyle(context: context),)
                      ),
                      InkWell(
                          onTap: () { launch('https://pub.dev/packages/http'); },
                          child: AutoSizeText('http',
                            style: BuildUtils.linkTextStyle(context: context),)
                      ),
                      InkWell(
                          onTap: () { launch('https://pub.dev/packages/url_launcher'); },
                          child: AutoSizeText('url_launcher',
                            style: BuildUtils.linkTextStyle(context: context),)
                      ),
                      InkWell(
                          onTap: () { launch('https://pub.dev/packages/flutter_candlesticks'); },
                          child: AutoSizeText('flutter_candlesticks',
                            style: BuildUtils.linkTextStyle(context: context),)
                      ),
                      InkWell(
                          onTap: () { launch('https://pub.dev/packages/path_provider'); },
                          child: AutoSizeText('path_provider',
                            style: BuildUtils.linkTextStyle(context: context),)
                      ),
                      InkWell(
                          onTap: () { launch('https://pub.dev/packages/intl'); },
                          child: AutoSizeText('intl',
                            style: BuildUtils.linkTextStyle(context: context),)
                      ),
                      InkWell(
                          onTap: () { launch('https://pub.dev/packages/auto_size_text'); },
                          child: AutoSizeText('auto_size_text',
                            style: BuildUtils.linkTextStyle(context: context),)
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Column(
                    children: [
                      AutoSizeText(
                          'APP ICON',
                          style: BuildUtils.headerTextStyle(context)
                      ),
                      Divider(color: Colors.grey,),
                      InkWell(
                          onTap: () { launch('https://dribbble.com/laurareen'); },
                          child: AutoSizeText('Laura Reen',
                            style: BuildUtils.linkTextStyle(context: context),
                          )
                      ),
                      InkWell(
                          onTap: () { launch('https://creativecommons.org/licenses/by/4.0/'); },
                          child: AutoSizeText('Provided with CC 4.0 license.',
                            style: BuildUtils.linkTextStyle(context: context),
                            textAlign: TextAlign.center,
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Column(
                    children: [
                      AutoSizeText(
                          'Made by',
                          style: BuildUtils.headerTextStyle(context)
                      ),
                      Divider(color: Colors.grey,),
                      InkWell(
                          onTap: () { launch('https://www.github.com/ozanbariscem'); },
                          child: AutoSizeText('Ozan Barış CEM',
                            style: BuildUtils.linkTextStyle(context: context),
                          )
                      ),
                      InkWell(
                          onTap: () { launch('https://www.github.com/ozanbariscem/ez_portfolio'); },
                          child: AutoSizeText(
                            'Source code to\nthis project',
                            style: BuildUtils.linkTextStyle(context: context),
                            textAlign: TextAlign.center,
                          )
                      ),
                    ],
                  )
                )
              ],
            ),
          )
        )
    );
  }
}

// pie_chart: ^5.0.0
// http: ^0.13.0
// url_launcher: ^6.0.2
// flutter_candlesticks: ^0.1.4
// path_provider: ^2.0.1
// intl: "^0.16.1"
// auto_size_text: ^2.1.0