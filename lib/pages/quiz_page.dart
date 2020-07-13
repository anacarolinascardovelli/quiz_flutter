import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quiz/components/build_question.dart';
import 'package:quiz/components/centered_circular_progress.dart';
import 'package:quiz/components/centered_message.dart';
import 'package:quiz/components/finish_dialog.dart';
import 'package:quiz/components/result_dialog.dart';
import 'package:quiz/controllers/quiz_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _controller = QuizController();
  List<Widget> _scoreKeeper = [];
  List<Widget> _scoreKeeper2 = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initialize();

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text('QUIZ STRANGER THINGS ( ${_scoreKeeper.length + _scoreKeeper2.length}/${_controller.questionNumber} )'),
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: _buildQuiz(),
        ),
      ),
    );
  }

  _buildQuiz() {
    if (_loading) return CenteredCircularProgress();

    if (_controller.questionNumber == 0)
      return CenteredMessage(
        message: 'Sem questões',
        icon: FontAwesomeIcons.exclamationTriangle
      );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        BuildQuestion(question: _controller.getQuestion(),),
        _buildAnswerButton(_controller.getAnswer1()),
        _buildAnswerButton(_controller.getAnswer2()),
        _buildScoreKeeper(),
        _buildScoreKeeper2(),
      ],
    );
  }

  _buildAnswerButton(String answer) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(4.0),
            color: Colors.blue,
            child: Center(
              child: AutoSizeText(
                answer,
                maxLines: 2,
                minFontSize: 10.0,
                maxFontSize: 32.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          onTap: () {
            bool correct = _controller.correctAnswer(answer);

            ResultDialog.show(
              context,
              question: _controller.question,
              correct: correct,
              onNext: () {
                setState(() {
                  if(_scoreKeeper.length<10){
                      _scoreKeeper.add(
                      Icon(
                        correct ? FontAwesomeIcons.thumbsUp : FontAwesomeIcons.thumbsDown,
                        color: correct ? Colors.green : Colors.red,
                      ),
                    );
                  }else{
                    _scoreKeeper2.add(
                      Icon(
                        correct ? FontAwesomeIcons.thumbsUp : FontAwesomeIcons.thumbsDown,
                        color: correct ? Colors.green : Colors.red,
                      ),
                    );
                  }
                  

                  if (_scoreKeeper.length+_scoreKeeper2.length < _controller.questionNumber) {
                    _controller.nextQuestion();
                  } else {
                    FinishDialog.show(
                      context,
                      hitNumber: _controller.hitNumber,
                      questionNumber:  _controller.questionNumber
                    );
                  }
                });
              },
            );
          },
        ),
      ),
    );
  }

  _buildScoreKeeper() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _scoreKeeper,
      ),
    );
  }
  _buildScoreKeeper2() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _scoreKeeper2,
      ),
    );
  }
}