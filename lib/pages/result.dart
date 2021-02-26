import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ResultScreen extends StatelessWidget {
  final double wpm;
  ResultScreen(this.wpm);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SfRadialGauge(
              enableLoadingAnimation: true,
              animationDuration: 5000,
              axes: [
                RadialAxis(
                    minimum: 0,
                    maximum: 80,
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.12,
                      gradient: SweepGradient(
                          colors: [Colors.yellow, Colors.green, Colors.red]),
                      cornerStyle: CornerStyle.bothCurve,
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    pointers: [
                      NeedlePointer(
                        value: wpm,
                      )
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          positionFactor: 0.3,
                          angle: 90,
                          widget: Text(
                            "${wpm.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.subtitle1,
                          )),
                      GaugeAnnotation(
                          angle: 90,
                          positionFactor: 0.43,
                          widget: Text(
                            "Words/min",
                            style: Theme.of(context).textTheme.bodyText1,
                          ))
                    ])
              ],
            ),
            FlatButton(
                onPressed: () => {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false)
                    },
                color: Theme.of(context).backgroundColor,
                splashColor: Color(0xFF4527A0),
                padding: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF4527A0),
                  ),
                  child: Text(
                    "Start Again",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
