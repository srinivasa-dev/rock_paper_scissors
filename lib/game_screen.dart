import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rock_paper_scissors/components/colors.dart';
import 'package:rock_paper_scissors/models/hand_model.dart';
import 'dart:math' as math;

import 'package:rock_paper_scissors/widgets/hand_option.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {

  final List<HandModel> _handList = [
    HandModel(
      id: 1,
      handName: 'Rock',
      handImage: 'assets/hands/rock.png',
    ),
    HandModel(
      id: 2,
      handName: 'Paper',
      handImage: 'assets/hands/paper.png',
    ),
    HandModel(
      id: 3,
      handName: 'Scissors',
      handImage: 'assets/hands/scissors.png',
    ),
  ];

  HandModel? _selectedHand, _computerHand, _randomHands;

  HandModel getRandomHand<HandModel>(List<HandModel> list) {
    final random = math.Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  bool _result = false;
  bool _hideOptions = true;
  bool _time = false;

  late AnimationController _animationController;
  late Animation<Offset> _offsetFloat;

  late AnimationController _animationHandController;
  late Animation<Offset> _offsetHandFloat;

  late Timer _timer;
  int _startTimer = 10;

  void startTimer() {
    const oneSec = Duration(milliseconds: 100);
    _timer = Timer.periodic(oneSec, (Timer timer) {
        if (_startTimer == 0) {
          setState(() {
            _time = false;
            _result = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _time = true;
            _startTimer--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _offsetFloat = Tween(begin: const Offset(0.0, 0.0), end: const Offset(0.0, 4)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.fastOutSlowIn,
          ),
        );

    _offsetFloat.addListener(() {
      setState(() {});
    });


    _animationHandController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _offsetHandFloat = Tween(begin: const Offset(0.0, 4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationHandController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _offsetHandFloat.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.rotate(
              angle: math.pi / 180 * 180,
              child: Image.asset(
                _time ? getRandomHand(_handList).handImage : _result ? _computerHand!.handImage : 'assets/hands/paper.png',
                scale: 1.8,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: _hideOptions,
                  child: Text(
                    'LET\'S PLAY!',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                Visibility(
                  visible: _result,
                  child: Column(
                    children: [
                      Text(
                        _result ? _selectedHand!.handName == 'Rock' && _computerHand!.handName == 'Scissors'
                            ? 'YOU WIN! 😃' : _selectedHand!.handName == 'Paper' && _computerHand!.handName == 'Rock'
                            ? 'YOU WIN! 😃' : _selectedHand!.handName == 'Scissors' && _computerHand!.handName == 'Paper'
                            ? 'YOU WIN! 😃' : _selectedHand!.handName == _computerHand!.handName
                            ? 'IT\'S A DRAW! 🥴' : 'YOU LOSE! 😭' : '',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const SizedBox(height: 10.0,),
                      SizedBox(
                        width: 200,
                        height: 50.0,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _result = false;
                              _hideOptions = true;
                              _time = false;
                              _startTimer = 10;
                              _animationHandController.reset();
                              _animationController.reset();
                            });
                          },
                          child: Text(
                            'PLAY AGAIN!',
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _hideOptions ? SlideTransition(
              position: _offsetFloat,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'PICK AN OPTION:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 25.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HandOption(
                        onTap: () {
                          setState(() {
                            _computerHand = getRandomHand(_handList);
                            _selectedHand =  HandModel(
                              id: 1,
                              handName: 'Rock',
                              handImage: 'assets/hands/rock.png',
                            );
                            _animationController.forward().then((value) {
                              _animationHandController.forward().then((value) => startTimer());
                              _hideOptions = false;
                            });
                          });
                        },
                        handImage: 'assets/hands/rock.png',
                      ),
                      HandOption(
                        onTap: () {
                          setState(() {
                            _computerHand = getRandomHand(_handList);
                            _selectedHand =  HandModel(
                              id: 2,
                              handName: 'Paper',
                              handImage: 'assets/hands/paper.png',
                            );
                            _animationController.forward().then((value) {
                              _animationHandController.forward().then((value) => startTimer());
                              _hideOptions = false;
                            });
                          });
                        },
                        handImage: 'assets/hands/paper.png',
                      ),
                      HandOption(
                        onTap: () {
                          _computerHand = getRandomHand(_handList);
                          setState(() {
                            _selectedHand =  HandModel(
                              id: 3,
                              handName: 'Scissors',
                              handImage: 'assets/hands/scissors.png',
                            );
                            _animationController.forward().then((value) {
                              _animationHandController.forward().then((value) => startTimer());
                              _hideOptions = false;
                            });
                          });
                        },
                        handImage: 'assets/hands/scissors.png',
                      ),
                    ],
                  ),
                ],
              ),
            ) : SlideTransition(
              position: _offsetHandFloat,
              child: Image.asset(
                _time ? getRandomHand(_handList).handImage : _result ? _selectedHand!.handImage : 'assets/hands/paper.png',
                scale: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
