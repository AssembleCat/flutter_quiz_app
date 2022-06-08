import 'package:django_quiz_app/model/api_adapter.dart';
import 'package:django_quiz_app/model/model_quiz.dart';
import 'package:django_quiz_app/screen/screen_quiz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Quiz> quizs = [];
  bool isLoading = false;

  _fetchQuizs() async{
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri(
        scheme: 'https',
        host: 'django-quiz-app-humanscape.herokuapp.com',
        path: 'quiz/3'
      )
      );
    if(response.statusCode == 200){
      setState(() {
        quizs = parseQuizs(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else{
      throw Exception('Failed to load quiz data');
    }
  }
  //더미데이터
  /*List<Quiz> quizs = [
    Quiz.fromMap({
      'title': 'test1',
      'candidates': ['a', 'b', 'c', 'd'],
      'answer': 0
    }, int: null),
    Quiz.fromMap({
      'title': 'test2',
      'candidates': ['a', 'b', 'c', 'd'],
      'answer': 0
    }, int: null),
    Quiz.fromMap({
      'title': 'test3',
      'candidates': ['a', 'b', 'c', 'd'],
      'answer': 0
    }, int: null),
  ];*/
  @override
  Widget build(BuildContext) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    //상단 노티, 하단영역을 침범하지 않는 안전지대 생성
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Django Quiz App'),
          backgroundColor: Colors.deepPurple,
          //헤더버튼 삭제
          leading: Container(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset('images/quiz.jpg', width: width * 0.8),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.024),
            ),
            Text(
              'Django Quiz App',
              style: TextStyle(
                fontSize: width * 0.065,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '퀴즈를 풀기 전 안내사항입니다.\n꼼꼼히 읽고 퀴즈 풀기를 눌러주세요.',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.048),
            ),
            _buildStep(width, '1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요.'),
            _buildStep(width, '2. 문제를 잘 읽고 정답을 고른뒤\n다음 문제 버튼을 눌러주세요.'),
            _buildStep(width, '3. 만점을 향해 도전해보세요.'),
            Padding(padding: EdgeInsets.all(width * 0.036),
            ),
            Container(
              padding: EdgeInsets.only(bottom: width * 0.036),
              child: Center(
                child: ButtonTheme(
                  minWidth: width * 0.8,
                  height: height * 0.05,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                    ),
                  child: RaisedButton(
                    child: Text(
                      '지금 퀴즈 풀기', 
                      style: TextStyle(
                        color: Colors.white),
                      ),
                      color: Colors.deepPurple,
                      onPressed: () {
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(
                          content: Row(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Padding(padding: EdgeInsets.only(left: width * 0.036)),
                              Text('로딩 중....'),
                            ],
                          ),
                        ));
                        _fetchQuizs().whenComplete(() {
                          return Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                quizs: quizs))
                          );
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(quizs: quizs,),
                         ),
                        );
                      },
                  ),
                ) 
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStep(double width, String title){
    return Container(
      padding: EdgeInsets.fromLTRB(
        width * 0.048,
        width * 0.024,
        width * 0.048,
        width * 0.024
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.check_box,
            size: width * 0.04,
            ),
          Padding(padding: EdgeInsets.only(right: width * 0.024),
          ),
          Text(title)
        ],
      ), 
    );
  }
}
