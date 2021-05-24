# ez_portfolio

A crypto portfolio tracker app I made because I needed something simple.
I add features as I need them that's why some basic functionalities are missing.
For example you can't delete a position, you can add negative amounts as a workaround but if you decide to add to the same holding again your avarage price will be miscalculated and your PNL will be wrong.

Some issues I am aware of:
 - If you are running the app for the first time, you have to open the app twice because of JSON save-file being missing.
 - We get the coins from CoinGecko but we get the graph data from Binance, if a coin is on CoinGecko but not on Binance graph component will be missing.
 - If you have a six figures portfolio some texts overflow. At least on my phone and Pixel 3.
 - Some of the coins website address gets broken in the attempt of simplification. Easy fix: Remove simplification.
 - Lack of optimization.
