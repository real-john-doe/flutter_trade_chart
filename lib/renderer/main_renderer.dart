import 'package:flutter/material.dart';
import '../entity/candle_entity.dart';
import '../k_chart_widget.dart' show MainState;
import 'base_chart_renderer.dart';

class MainRenderer extends BaseChartRenderer<CandleEntity> {
  double mCandleWidth = ChartStyle.candleWidth;
  double mCandleLineWidth = ChartStyle.candleLineWidth;
  MainState? state;
  bool? isLine;

  double _contentPadding = 12.0;

  MainRenderer(Rect? mainRect, double maxValue, double minValue,
      double topPadding, this.state, this.isLine, double scaleX)
      : super(
            chartRect: mainRect,
            maxValue: maxValue,
            minValue: minValue,
            topPadding: topPadding,
            scaleX: scaleX) {
    var diff = maxValue - minValue; //Calculated difference
    var newScaleY = (chartRect!.height - _contentPadding) /
        diff; //Content area height/difference = new ratio
    var newDiff =
        chartRect!.height / newScaleY; //High/new ratio = new difference
    var value = (newDiff - diff) /
        2; //New difference-difference / 2 = the value to be expanded on the y axis
    if (newDiff > diff) {
      this.scaleY = newScaleY;
      this.maxValue += value;
      this.minValue -= value;
    }
  }

  @override
  void drawText(Canvas canvas, CandleEntity data, double x) {
    if (isLine == true) return;
    TextSpan? span;
    if (state == MainState.MA) {
      span = TextSpan(
        children: [
          if (data.MA5Price != 0)
            TextSpan(
                text: 'MA5:${format(data.MA5Price!)}    ',
                style: getTextStyle(ChartColors.ma5Color)),
          if (data.MA10Price != 0)
            TextSpan(
                text: 'MA10:${format(data.MA10Price!)}    ',
                style: getTextStyle(ChartColors.ma10Color)),
          if (data.MA30Price != 0)
            TextSpan(
                text: 'MA30:${format(data.MA30Price!)}    ',
                style: getTextStyle(ChartColors.ma30Color)),
        ],
      );
    } else if (state == MainState.BOLL) {
      span = TextSpan(
        children: [
          if (data.mb != 0)
            TextSpan(
                text: 'BOLL:${format(data.mb!)}    ',
                style: getTextStyle(ChartColors.ma5Color)),
          if (data.up != 0)
            TextSpan(
                text: 'UP:${format(data.up!)}    ',
                style: getTextStyle(ChartColors.ma10Color)),
          if (data.dn != 0)
            TextSpan(
                text: 'LB:${format(data.dn!)}    ',
                style: getTextStyle(ChartColors.ma30Color)),
        ],
      );
    }
    if (span == null) return;
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x, chartRect!.top - topPadding));
  }

  @override
  void drawChart(CandleEntity lastPoint, CandleEntity curPoint, double lastX,
      double curX, Size size, Canvas canvas) {
    if (isLine != true) drawCandle(curPoint, canvas, curX);
    if (isLine == true) {
      draLine(lastPoint.close, curPoint.close, canvas, lastX, curX);
    } else if (state == MainState.MA) {
      drawMaLine(lastPoint, curPoint, canvas, lastX, curX);
    } else if (state == MainState.BOLL) {
      drawBollLine(lastPoint, curPoint, canvas, lastX, curX);
    }
  }

  Shader? mLineFillShader;
  Path? mLinePath, mLineFillPath;
  final double mLineStrokeWidth = 1.0;
  final Paint mLinePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..color = ChartColors.kLineColor;
  final Paint mLineFillPaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  //????????????
  draLine(double lastPrice, double curPrice, Canvas canvas, double lastX,
      double curX) {
//    drawLine(lastPrice + 100, curPrice + 100, canvas, lastX, curX, ChartColors.kLineColor);
    mLinePath ??= Path();

//    if (lastX == curX) {
//      mLinePath.moveTo(lastX, getY(lastPrice));
//    } else {
////      mLinePath.lineTo(curX, getY(curPrice));
//      mLinePath.cubicTo(
//          (lastX + curX) / 2, getY(lastPrice), (lastX + curX) / 2, getY(curPrice), curX, getY(curPrice));
//    }
    double updatedLastX = lastX;
    if (lastX == curX) updatedLastX = 0;

    mLinePath!.moveTo(updatedLastX, getY(lastPrice));
    mLinePath!.cubicTo((updatedLastX + curX) / 2, getY(lastPrice),
        (updatedLastX + curX) / 2, getY(curPrice), curX, getY(curPrice));

//    //?????????
    mLineFillShader ??= LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.clamp,
      colors: ChartColors.kLineShadowColor,
    ).createShader(Rect.fromLTRB(
        chartRect!.left, chartRect!.top, chartRect!.right, chartRect!.bottom));
    mLineFillPaint..shader = mLineFillShader;

    mLineFillPath ??= Path();

    mLineFillPath!.moveTo(updatedLastX, chartRect!.height + chartRect!.top);
    mLineFillPath!.lineTo(updatedLastX, getY(lastPrice));
    mLineFillPath!.cubicTo((updatedLastX + curX) / 2, getY(lastPrice),
        (updatedLastX + curX) / 2, getY(curPrice), curX, getY(curPrice));
    mLineFillPath!.lineTo(curX, chartRect!.height + chartRect!.top);
    mLineFillPath!.close();

    canvas.drawPath(mLineFillPath!, mLineFillPaint);
    mLineFillPath!.reset();

    canvas.drawPath(mLinePath!,
        mLinePaint..strokeWidth = (mLineStrokeWidth / scaleX!).clamp(0.3, 1.0));
    mLinePath!.reset();
  }

  void drawMaLine(CandleEntity lastPoint, CandleEntity curPoint, Canvas canvas,
      double lastX, double curX) {
    if (lastPoint.MA5Price != 0) {
      drawLine(lastPoint.MA5Price!, curPoint.MA5Price!, canvas, lastX, curX,
          ChartColors.ma5Color);
    }
    if (lastPoint.MA10Price != 0) {
      drawLine(lastPoint.MA10Price!, curPoint.MA10Price!, canvas, lastX, curX,
          ChartColors.ma10Color);
    }
    if (lastPoint.MA30Price != 0) {
      drawLine(lastPoint.MA30Price!, curPoint.MA30Price!, canvas, lastX, curX,
          ChartColors.ma30Color);
    }
  }

  void drawBollLine(CandleEntity lastPoint, CandleEntity curPoint,
      Canvas canvas, double lastX, double curX) {
    if (lastPoint.up != 0) {
      drawLine(lastPoint.up!, curPoint.up!, canvas, lastX, curX,
          ChartColors.ma10Color);
    }
    if (lastPoint.mb != 0) {
      drawLine(lastPoint.mb!, curPoint.mb!, canvas, lastX, curX,
          ChartColors.ma5Color);
    }
    if (lastPoint.dn != 0) {
      drawLine(lastPoint.dn!, curPoint.dn!, canvas, lastX, curX,
          ChartColors.ma30Color);
    }
  }

  void drawCandle(CandleEntity curPoint, Canvas canvas, double curX) {
    var high = getY(curPoint.high);
    var low = getY(curPoint.low);
    var open = getY(curPoint.open);
    var close = getY(curPoint.close);
    double r = mCandleWidth / 2;
    double lineR = mCandleLineWidth / 2;

    //To prevent the line from being too thin, force the minimum 1px
    if ((open - close).abs() < 1) {
      if (open > close) {
        open += 0.5;
        close -= 0.5;
      } else {
        open -= 0.5;
        close += 0.5;
      }
    }
    if (open > close) {
      chartPaint.color = ChartColors.upColor;
      canvas.drawRect(
          Rect.fromLTRB(curX - r, close, curX + r, open), chartPaint);
      canvas.drawRect(
          Rect.fromLTRB(curX - lineR, high, curX + lineR, low), chartPaint);
    } else {
      chartPaint.color = ChartColors.dnColor;
      canvas.drawRect(
          Rect.fromLTRB(curX - r, open, curX + r, close), chartPaint);
      canvas.drawRect(
          Rect.fromLTRB(curX - lineR, high, curX + lineR, low), chartPaint);
    }
  }

  @override
  void drawRightText(canvas, textStyle, int gridRows) {
    double rowSpace = chartRect!.height / gridRows;
    for (var i = 0; i <= gridRows; ++i) {
      double position = 0;
      // if (i == 0) {
      //   position = (gridRows - i) * rowSpace - _contentPadding / 2;
      // } else if (i == gridRows) {
      //   position = (gridRows - i) * rowSpace + _contentPadding / 2;
      // } else {
      position = (gridRows - i) * rowSpace;
      // }
      var value = position / scaleY! + minValue;
      TextSpan span = TextSpan(text: '${format(value)}', style: textStyle);
      TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      double y;
      // if (i == 0 || i == gridRows) {
      y = getY(value) - tp.height / 2;
      // } else {
      // y = getY(value) - tp.height / 2;
      // }
      tp.paint(
        canvas,
        Offset(
          chartRect!.width - tp.width - ChartStyle.spacerRight,
          y,
        ),
      );
    }
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns) {
//    final int gridRows = 4, gridColumns = 4;
    double rowSpace = chartRect!.height / gridRows;
    for (int i = 0; i <= gridRows; i++) {
      canvas.drawLine(Offset(0, rowSpace * i + topPadding),
          Offset(chartRect!.width, rowSpace * i + topPadding), gridPaint);
    }
    // remove vertical line
    // double columnSpace = chartRect.width / gridColumns;
    // for (int i = 0; i <= columnSpace; i++) {
    //   canvas.drawLine(
    //       Offset(columnSpace * i, topPadding / 3), Offset(columnSpace * i, chartRect.bottom), gridPaint);
    // }
  }
}
