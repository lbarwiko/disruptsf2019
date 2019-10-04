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
  SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';

  //String _currentLocale = 'en_US';
  String selectedLang = 'en_US';

  @override
  void initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          )),
          MaterialButton(
            child: Icon(Icons.play_arrow),
            onPressed: () {
              _speech.listen();
            },
          ),
          MaterialButton(
            child: Icon(Icons.stop),
            onPressed: () {
              _speech.stop();
            },
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.format_quote),
        onPressed: () {
          start();
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              context: context,
              builder: (builder) {
                return new Container(
                  height: 150.0,
                  color: Colors.transparent,
                  child: new Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            getMessageBox('RIGHT', 'What do you wanna buy?')
                          ],
                        ),
                      )
                    ],
                  )),
                );
              });
        },
      ),
    );
  }

  getMessageBox(String direction, String text) {
    return direction == 'LEFT'
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

  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.activate().then((res) {
      print('activated $res');
      setState(() {
        _speechRecognitionAvailable = res;
      });
    });
  }

  void start() => _speech
      .listen(locale: selectedLang)
      .then((result) => print('_MyAppState.start => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
        setState(() => _isListening = result);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(() => selectedLang = locale);
  }

  void onRecognitionStarted() => setState(() {
        _isListening = true;
        print('started listening');
      });

  void onRecognitionResult(String text) => setState(() {
        transcription = text;
        print('recognised text $text');
      });

  void onRecognitionComplete() => setState(() => _isListening = false);

  void errorHandler() => activateSpeechRecognizer();
}
