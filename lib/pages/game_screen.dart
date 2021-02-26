import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:loading_overlay/loading_overlay.dart';

// import './result.dart';

class GameScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameScreenState();
  }
}

class _GameScreenState extends State<GameScreen> {
  String mainText = "Generating text!";
  String currentValue = "";
  var split = 0;
  double progress = 0;
  bool loading = true;
  bool fetchFailure = false;
  bool correct = true;
  bool started = false;
  String mili = "00";
  String secs = "00";
  String mins = "00";
  double wpm = 0.0;
  int elasp = 0;
  static const ms10 = const Duration(milliseconds: 10);
  TextEditingController textController = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  Timer _timer;
  Stopwatch sw = new Stopwatch();
  double maxScroll;

  GlobalKey _subtitleKey = GlobalKey();
  GlobalKey _titleKey = GlobalKey();

  void autoScroll() {
    RenderBox renderSubtitle = _subtitleKey.currentContext.findRenderObject();
    var positionSubtitle = renderSubtitle.localToGlobal(Offset.zero);

    RenderBox renderTitle = _titleKey.currentContext.findRenderObject();
    var titleHeight = renderTitle.size;

    maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;

    if ((positionSubtitle.dy > 126.0) && (currentScroll < maxScroll)) {
      scrollController.animateTo(titleHeight.height - 41.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
    }
  }

  void fetchText() async {
    if (await DataConnectionChecker().hasConnection) {
      final response =
          await http.get(Uri.https('hack-da-north.herokuapp.com', 'api'));
      if (response.statusCode == 200) {
        var body = response.body.split(' ');
        setState(() {
          mainText = body[0];
          int i = 1;
          while (i < body.length && mainText.length < 100) {
            mainText += ' ' + body[i];
            i += 1;
          }
          mainText += ".";
          loading = false;
        });
      } else {
        // print("Failed to fetch text!");
        setState(() {
          loading = false;
          fetchFailure = true;
        });
      }
    } else {
      setState(() {
        loading = false;
        fetchFailure = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchText();
    _timer = Timer.periodic(ms10, (Timer t) {
      if (sw.elapsedMilliseconds != 0) {
        setState(() {
          elasp = sw.elapsedMilliseconds;
          int tmp = elasp ~/ 10;
          int ms = tmp % 100;
          int se = (tmp ~/ 100) % 60;
          int mi = elasp ~/ 60000;

          int currentWordLength = currentValue.split(" ").length;
          wpm = (currentWordLength * 60000) / elasp;

          if (ms >= 10) {
            mili = ms.toString();
          } else {
            mili = "0" + ms.toString();
          }

          if (se >= 10) {
            secs = se.toString();
          } else {
            secs = "0" + se.toString();
          }

          if (mi >= 10) {
            mins = mi.toString();
          } else {
            mins = "0" + mi.toString();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: LoadingOverlay(
          color: Colors.grey[400],
          isLoading: loading,
          opacity: 0.5,
          progressIndicator: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "Please wait while the text is fetched!",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          ),
          child: fetchFailure
              ? AlertDialog(
                  title: Text(
                    "Failed to fetch text!",
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  ),
                  content: SingleChildScrollView(
                    child: Container(
                      child: Text(
                        "Oops.. There has been an error in fetching the text.. Make sure that you have Wifi/Mobile Date turned on!",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Try Again",
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ))
                  ],
                )
              : Column(children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 45),
                          child: Text("$mins:$secs:$mili",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.cyan[800])),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 15, bottom: 20, left: 15, right: 15),
                          height: 120,
                          child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        key: _titleKey,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 5),
                                        child: Text(
                                          split > 0
                                              ? mainText.substring(0, split)
                                              : "'Text to appear here!'",
                                          style: (correct && split == 0)
                                              ? TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w600)
                                              : (correct && split > 0)
                                                  ? TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.blue[800],
                                                      fontWeight:
                                                          FontWeight.w600)
                                                  : TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w600),
                                        )),
                                    Padding(
                                        key: _subtitleKey,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 10),
                                        child: Text(
                                          mainText.substring(split),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xFF4527A0),
                                              fontWeight: FontWeight.w600),
                                        )),
                                  ])),
                        ),
                        Container(
                            margin:
                                EdgeInsets.only(left: 15, right: 15, bottom: 5),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue[900],
                                  ),
                                  backgroundColor: Colors.indigo[200],
                                  minHeight: 10,
                                ))),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Progress: ${(progress * 100).toStringAsFixed(2)}%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "WPM: ${wpm.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: TextField(
                            maxLines: 3,
                            minLines: 1,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: TextStyle(fontSize: 16),
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: "Start typing the text written above!",
                              hintStyle: TextStyle(fontSize: 16),
                              focusColor: Colors.red,
                            ),
                            onChanged: (value) => {
                              setState(() {
                                int len = value.length;
                                if (value == mainText.substring(0, len)) {
                                  correct = true;
                                  split = len;
                                  progress = len / mainText.length;
                                  currentValue = value;
                                } else {
                                  correct = false;
                                }
                                if (!started) {
                                  started = true;
                                  sw.start();
                                }
                              }),
                              // print(sw.elapsedMilliseconds),
                              if (value == mainText)
                                {
                                  _timer.cancel(),
                                  sw.stop(),
                                  Navigator.pushNamed(context, '/result',
                                      arguments: wpm)
                                },
                              autoScroll()
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
        ));
  }
}
