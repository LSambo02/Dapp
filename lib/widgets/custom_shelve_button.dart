import 'package:despensa/utils/constantes.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomCardButton extends StatelessWidget {
  int index;
  String? title;
  Function()? action;
  String? valueKey;
  String? total;
  String? disponivel;
  CustomCardButton(this.index,
      {Key? key,
      this.title,
      this.action,
      this.valueKey,
      this.total,
      this.disponivel})
      : super(key: key);

  double percent = 0;
  @override
  Widget build(BuildContext context) {
    calcPercent();
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(left: 05.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: TextButton(
            key: ValueKey(valueKey),
            onPressed: action,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(80)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.asset(
                            groceriesIcon,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 9),
                            child: Text(
                              '$disponivel/$total',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w700),
                              //
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Center(
                          child: Text(
                            title!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      LinearPercentIndicator(
                        width: 150,
                        animation: false,
                        lineHeight: 10.0,
                        // animationDuration: 3000,
                        percent: (percent / 100),
                        animateFromLastPercent: false,
                        // center: Text("$percent%"),
                        barRadius: Radius.circular(30),
                        progressColor: Colors.blue,
                        // widgetIndicator: RotatedBox(
                        //     quarterTurns: 1,
                        //     child: Icon(Icons.airplanemode_active, size: 50)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  calcPercent() {
    // setState(() {
    percent = (double.parse(disponivel!) * 100) / double.parse(total!);
    percent = percent.round().toDouble();
    // });
  }
}
