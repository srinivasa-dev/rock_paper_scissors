import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rock_paper_scissors/components/colors.dart';
import 'package:rock_paper_scissors/models/hand_model.dart';
import 'dart:math' as math;

import 'package:rock_paper_scissors/widgets/hand_option.dart';
import 'package:url_launcher/url_launcher.dart';


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
  bool _vibrate = true;

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
            if(_vibrate) HapticFeedback.lightImpact();
            timer.cancel();
          });
        } else {
          setState(() {
            if(_vibrate) HapticFeedback.selectionClick();
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

  final Uri _gitUrl = Uri.parse('https://github.com/srinivasa-dev/rock_paper_scissors');
  final Uri _androidUrl = Uri.parse('https://drive.google.com/uc?export=download&id=1NTHMP30Cg7PM8l1y6tYWjS_CWr6u-9i7');
  final Uri _webUrl = Uri.parse('https://rps.divcodes.in');
  final Uri _windowsUrl = Uri.parse('https://drive.google.com/uc?export=download&id=1yDhL6RR33Oq8TfyiPC9VGB5u3rAAdZsH');

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 56.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          splashRadius: 10.0,
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textBlack,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              settingsDialog();
            },
            splashRadius: 10.0,
            icon: Icon(
              Icons.settings_rounded,
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 30.0),
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

  settingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          // contentPadding: EdgeInsets.only(top: 10.0),
          content: StatefulBuilder(
              builder: (context, onRefresh) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: defaultTargetPlatform == TargetPlatform.windows ? false : kIsWeb ? false : true,
                      child: InkWell(
                        onTap: () {
                          onRefresh(() {
                            setState(() {
                              _vibrate = !_vibrate;
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.vibration,
                                color: AppColors.textBlack,
                              ),
                              Switch(
                                value: _vibrate,
                                onChanged: (value) {
                                  onRefresh(() {
                                    setState(() {
                                      _vibrate = value;
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    RichText(
                      text: TextSpan(
                        text: 'This app is built on ',
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          TextSpan(
                            text: 'Flutter ',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xFF757575),  fontWeight: FontWeight.w500,),
                          ),
                          TextSpan(
                            text: 'also available for ',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          kIsWeb ? linkText(text: 'Android ', url: _androidUrl) : defaultTargetPlatform != TargetPlatform.android
                              ? linkText(text: 'Android ', url: _androidUrl) : const TextSpan(),
                          TextSpan(
                            text: defaultTargetPlatform == TargetPlatform.windows ? ' and ' : '',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          !kIsWeb ? linkText(text: 'Web ', url: _webUrl) : const TextSpan(),
                          TextSpan(
                            text: defaultTargetPlatform != TargetPlatform.windows ? ' and ' : '',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          kIsWeb ? linkText(text: 'Windows ', url: _windowsUrl) : defaultTargetPlatform != TargetPlatform.windows
                              ? linkText(text: 'Windows ', url: _windowsUrl) : const TextSpan(),
                          TextSpan(
                            text: '.\n\nSource code available on ',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          linkText(text: 'GitHub ', url: _gitUrl),
                        ],
                      ),
                    ),
                  ],
                );
              }
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              ),
              child: Text(
                'CLOSE',
                style: Theme.of(context).textTheme.button!.copyWith(color: AppColors.primary, fontSize: 15.0,),
              ),
            ),
          ],
        );
      },
    );
  }


  TextSpan linkText({
    required String text,
    required Uri url,
  }) {
    return TextSpan(
      text: text,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.primary),
      recognizer: TapGestureRecognizer()..onTap = () {
        _launchUrl(url);
      },
      children: [
        WidgetSpan(
          child: Icon(
            Icons.open_in_new,
            color: AppColors.primary,
            size: 18.0,
          ),
        ),
      ],
    );
  }

}
