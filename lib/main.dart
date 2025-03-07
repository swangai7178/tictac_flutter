import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GameEntrancePage(),
    );
  }
}

class GameEntrancePage extends StatefulWidget {
  const GameEntrancePage({super.key});

  @override
  State<GameEntrancePage> createState() => _GameEntrancePageState();
}

class _GameEntrancePageState extends State<GameEntrancePage> {
  int numberOfPlayers = 2; // Default to 2 players
  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> _playBackgroundMusic() async {
    await audioPlayer.play(AssetSource('tune.mp3')); // Replace with your asset path
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }
  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }
  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE0B2),
              Color(0xFFFFCCBC),
              Color(0xFFCE93D8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Tic Tac Toe!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              const Text(
                'Choose Number of Players:',
                style: TextStyle(fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio<int>(
                    value: 1,
                    groupValue: numberOfPlayers,
                    onChanged: (value) {
                      setState(() {
                        numberOfPlayers = value!;
                      });
                    },
                  ),
                  const Text('1 Player'),
                  Radio<int>(
                    value: 2,
                    groupValue: numberOfPlayers,
                    onChanged: (value) {
                      setState(() {
                        numberOfPlayers = value!;
                      });
                    },
                  ),
                  const Text('2 Players'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CandyCrushTicTacToe(numberOfPlayers: numberOfPlayers),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade300),
                child: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CandyCrushTicTacToe extends StatefulWidget {
  final int numberOfPlayers;

  const CandyCrushTicTacToe({super.key, required this.numberOfPlayers});

  @override
  State<CandyCrushTicTacToe> createState() => _CandyCrushTicTacToeState();
}

class _CandyCrushTicTacToeState extends State<CandyCrushTicTacToe> {
  List<String> board = List.generate(9, (index) => '');
  String currentPlayer = '🍬';
  String? winner;
  bool gameOver = false;
  int _counter = 0;

  void _handleTap(int index) {
    if (board[index] == '' && !gameOver) {
      setState(() {
        board[index] = currentPlayer;
        _counter++;
        _checkWinner();
        _togglePlayer();
        if (widget.numberOfPlayers == 1 && !gameOver) {
          _makeComputerMove();
        }
      });
    }
  }

  void _makeComputerMove() {
    if (board.contains('')) {
      int bestMove = _getBestMove();
      if(bestMove != -1){
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleTap(bestMove);
        });
      }
    }
  }

  int _getBestMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        availableMoves.add(i);
      }
    }
    if(availableMoves.isEmpty){
      return -1;
    }
    return availableMoves[Random().nextInt(availableMoves.length)];
  }

  void _togglePlayer() {
    currentPlayer = currentPlayer == '🍬' ? '🍭' : '🍬';
  }

  void _checkWinner() {
    final winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final combination in winningCombinations) {
      final a = board[combination[0]];
      final b = board[combination[1]];
      final c = board[combination[2]];
      if (a != '' && a == b && a == c) {
        setState(() {
          winner = a;
          gameOver = true;
        });
        return;
      }
    }

    if (!board.contains('')) {
      setState(() {
        winner = 'Draw';
        gameOver = true;
      });
    }
  }

  void _resetGame() {
    setState(() {
      board = List.generate(9, (index) => '');
      currentPlayer = '🍬';
      winner = null;
      gameOver = false;
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE0B2),
              Color(0xFFFFCCBC),
              Color(0xFFCE93D8),
            ],
          ),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double gridSize = min(constraints.maxWidth * 0.8, constraints.maxHeight * 0.6);
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Candy Clicks:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Text(
                      'Sweet Tic Tac Toe!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: gridSize,
                      height: gridSize,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 9,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _handleTap(index),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  board[index],
                                  style: const TextStyle(fontSize: 40),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (winner != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          winner == 'Draw' ? 'Sweet Draw!' : '$winner wins!',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (gameOver)
                      ElevatedButton(
                        onPressed: _resetGame,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade300),
                        child: const Text('Play Again!'),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}