import 'package:flutter/material.dart' show Color;

class ChartColors {
  ChartColors._();

  //background color
  static const Color bgColor = Color(0xff090F24);
  static const Color kLineColor = Color(0xff33cc66);
  static const Color gridColor = Color(0x14ffffff);
  static const List<Color> kLineShadowColor = [
    Color(0x5533cc66),
    Color(0x00000000)
  ]; //k-line shadow gradient
  static const Color ma5Color = Color(0xffC9B885);
  static const Color ma10Color = Color(0xff6CB0A6);
  static const Color ma30Color = Color(0xff9979C6);
  static const Color upColor = Color(0xff33cc66);
  static const Color dnColor = Color(0xffEF4042);
  static const Color volColor = Color(0xff4729AE);

  static const Color macdColor = Color(0xff4729AE);
  static const Color difColor = Color(0xffC9B885);
  static const Color deaColor = Color(0xff6CB0A6);

  static const Color kColor = Color(0xffC9B885);
  static const Color dColor = Color(0xff6CB0A6);
  static const Color jColor = Color(0xff9979C6);
  static const Color rsiColor = Color(0xffC9B885);

  static const Color yAxisTextColor = Color(0xffffffff); //Right y-axis scale
  static const Color xAxisTextColor = Color(0xffffffff); //Time scale below

  static const Color maxMinTextColor = Color(0xffffffff); //最大最小值的颜色
  static const Color minTextColor = Color.fromRGBO(239, 64, 66, 0.5);
  static const Color maxTextColor = Color.fromRGBO(51, 204, 102, 0.5);

  //深度颜色
  static const Color depthBuyColor = Color(0xff60A893);
  static const Color depthSellColor = Color(0xffC15866);

  //Display value border color after selection
  static const Color markerBorderColor = Color(0xff6C7A86);

  //The fill color of the displayed value background after selection
  static const Color markerBgColor = Color(0xff090F24);

  //Real-time line color etc.
  static const Color realTimeBgColor = Color(0xff4192F1);
  static const Color rightRealTimeTextColor = Color(0xffffffff);
  static const Color realTimeTextBorderColor = Color(0xffffffff);
  static const Color realTimeTextColor = Color(0xffffffff);

  //Real-time line
  static const Color realTimeLineColor = Color(0xff4192F1);
  static const Color realTimeLongLineColor = Color(0xff4192F1);

  static const Color simpleLineUpColor = Color(0xff6CB0A6);
  static const Color simpleLineDnColor = Color(0xffC15466);
}

class ChartStyle {
  ChartStyle._();

  //点与点的距离
  static const double pointWidth = 8.0;

  //蜡烛宽度
  static const double candleWidth = 3.0;

  //蜡烛中间线的宽度
  static const double candleLineWidth = 1;

  //vol柱子宽度
  static const double volWidth = 3.0;

  //macd柱子宽度
  static const double macdWidth = 3.0;

  //Vertical cross line width
  static const double vCrossWidth = 1;

  //Horizontal cross line width Horizontal cross line width
  static const double hCrossWidth = 1;

  //网格
  static const int gridRows = 4, gridColumns = 5;

  static const double topPadding = 30.0,
      bottomDateHigh = 39.0,
      childPadding = 25.0;

  static const double spacerRight = 20;

  static const double defaultTextSize = 12.0;
}
