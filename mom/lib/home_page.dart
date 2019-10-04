import 'package:flutter/material.dart';
import 'package:mom/charts/pie_chart.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'charts/line_area_chart.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  bool _isModalShown = false;

  String resultText = "";

  PersistentBottomSheetController _controller; // <------ Instance variable
  final _scaffoldKey =
      GlobalKey<ScaffoldState>(); // <---- Another instance variable

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '\$5K',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
            ),
          ),
          /*IconButton(
            icon: Icon(Icons.portrait),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            },
          )*/
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: MyLineChart(),
                ),
              ),
            ),
            Expanded(
                child: Container(
              child: MyPieChart(),
            ))
          ],
        ),
      ),
      floatingActionButton: !_isModalShown
          ? FloatingActionButton(
              child: Icon(Icons.format_quote),
              onPressed: () {
                setState(() {
                  _isModalShown = true;
                });
                startListening();
                _controller = _scaffoldKey.currentState.showBottomSheet(
                  (context) {
                    return _modalContainer();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 10,
                );
              },
            )
          : FloatingActionButton(
              child: Icon(Icons.close),
              onPressed: () {
                _controller.close();
                if (_isListening)
                  _speechRecognition.stop().then(
                        (result) => setState(() => _isListening = result),
                      );
                setState(() {
                  _isModalShown = false;
                });
              },
            ),
    );
  }

  getMessageBox(String direction, String text) {
    return direction == 'RIGHT'
        ? new Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(top: 10.0, left: 60.0),
            decoration: BoxDecoration(
                color: Color(0xFFE6F6FE),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(15.0))),
            child: getTextMessage(text))
        : new Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(top: 10.0, right: 60.0),
            decoration: BoxDecoration(
              color: Color(0xFFEDEDED),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(15.0),
              ),
            ),
            child: getTextMessage(text),
          );
  }

  getTextMessage(String text) => Text(text);

  _modalContainer() {
    return Container(
      height: 150.0,
      color: Colors.transparent,
      child: new Container(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: CircleAvatar(
                    child: Icon(
                      Icons.alternate_email,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.indigo,
                  ),
                ),
                getMessageBox('LEFT', 'What do you wanna buy?'),
              ],
            ),
          ),
//          resultText.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                getMessageBox('RIGHT', resultText),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: CircleAvatar(
                    child: Icon(
                      Icons.alternate_email,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.indigo,
                  ),
                ),
              ],
            ),
          )
//              : Container(),
        ],
      )),
    );
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() {
        _isListening = true;
        print('started listening');
      }),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) {
        _controller.setState(() {
          resultText = speech;
          print('result handler $resultText');
        });
      },
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() {
        _isListening = false;
        print('listening completed');
      }),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  void startListening() {
    setState(() {
      resultText = "";
    });
    if (_isAvailable && !_isListening)
      _speechRecognition
          .listen(locale: "en_IN")
          .then((result) => print('result after calling $result'));
  }
}
