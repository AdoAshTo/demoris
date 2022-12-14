import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris/utils/utils.dart';

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
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int offsetX = 0;
  int offsetY = 0;
  int minoCount = 0;
  late Mino minoType;
  Timer? timer;
  List<Mino> minoCandidate = [];
  List<Mino> minoCandidateNext = [];
  List<List<int>> mino = [];
  List<List<int>> field = List<List<int>>.generate(
    fieldRows,
    (index) => (List<int>.generate(
      fieldColumns,
      ((index) => 7),
    )),
  );
  bool isGameover = false;

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  void initState() {
    super.initState();
    offsetX = (fieldColumns ~/ 2) - (minoSize ~/ 2);
    minoCandidate = [...minoSet];
    minoCandidate.shuffle();
    minoCandidateNext = [...minoSet];
    minoCandidateNext.shuffle();
    minoType = minoCandidate.removeAt(0);
    mino = minoCreate(minoType);
    timer = _onTimer();
  }

  Timer _onTimer() {
    return Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {
      _downMove();
    });
  }

  void _downMove() {
    //await Future.delayed(Duration(seconds: 5));
    if (checkMove(0, 1, mino)) {
      offsetY++;
      setState(() {});
    } else {
      if (!checkMove(0, 0, mino)) {
        timer!.cancel();
        print('Game Over!!!');
        isGameover = true;
      }
      _stackField();
      _deleteLine();
      minoType = minoCandidate.removeAt(0);
      mino = minoCreate(minoType);
      minoCandidate.add(minoCandidateNext.removeAt(0));
      minoCount++;

      if (minoCount == 7) {
        minoCandidateNext = [...minoSet];
        minoCandidateNext.shuffle();
        minoCount = 0;
      }
      offsetX = (fieldColumns ~/ 2) - (minoSize ~/ 2);
      offsetY = 0;
      setState(() {});
    }
  }

  void _leftMove() {
    //await Future.delayed(Duration(seconds: 5));
    if (checkMove(-1, 0, mino)) {
      offsetX--;
      setState(() {});
    }
  }

  void _rightMove() {
    //await Future.delayed(Duration(seconds: 5));
    if (checkMove(1, 0, mino)) {
      offsetX++;
      setState(() {});
    }
  }

  bool checkMove(int dx, int dy, List<List<int>> targetMino) {
    for (var y = 0; y < minoSize; y++) {
      for (var x = 0; x < minoSize; x++) {
        if (targetMino[y][x] == 1) {
          int nextX = offsetX + dx + x;
          int nextY = offsetY + dy + y;
          if (nextX < 0 ||
              nextY < 0 ||
              nextX >= width ||
              nextY >= height ||
              field[nextY][nextX] != 7) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void _minoRotate(bool isClockwise) {
    List<List<int>> minoRotate = List<List<int>>.generate(
        minoSize, (index) => (List<int>.generate(minoSize, ((index) => 0))));
    if (isClockwise) {
      for (var y = 0; y < minoSize; y++) {
        for (var x = 0; x < minoSize; x++) {
          minoRotate[y][x] = mino[minoSize - (x + 1)][y];
        }
      }
    } else {
      for (var y = 0; y < minoSize; y++) {
        for (var x = 0; x < minoSize; x++) {
          minoRotate[y][x] = mino[x][minoSize - (y + 1)];
        }
      }
    }

    if (checkMove(0, 0, minoRotate)) {
      mino = minoRotate;
      setState(() {});
    }
  }

  void _stackField() {
    for (var y = 0; y < minoSize; y++) {
      for (var x = 0; x < minoSize; x++) {
        if (mino[y][x] == 1) {
          field[offsetY + y][offsetX + x] = minoType.index;
        }
      }
    }
  }

  void _deleteLine() {
    int deleteCount;
    for (var y = 0; y < fieldRows; y++) {
      deleteCount = 0;
      for (var x = 0; x < fieldColumns; x++) {
        if (field[y][x] != 7) {
          deleteCount++;
          if (deleteCount == fieldColumns) {
            for (var y2 = y; y2 > 0; y2--) {
              for (var x2 = 0; x2 < fieldColumns; x2++) {
                field[y2][x2] = field[y2-1][x2];
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('tetris demo'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 50,
            ),
          ),
          Container(
            child: isGameover ? SimpleDialog(title: Text('Game Over!'),) : Center(
              child: Container(
                width: width * block,
                height: height * block,
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 5, strokeAlign: StrokeAlign.outside),
                ),
                child: Stack(
                  children: [
                    // CustomPaint(
                    //   painter: RectPainter(offsetX, offsetY, mino, minoType),
                    // ),
                    for (int y = 0; y < minoSize; y++) ...{
                      for (int x = 0; x < minoSize; x++) ...{
                        if (mino[y][x] == 1)
                          CustomPaint(
                            painter: BlockPainter(
                                offsetX + x, offsetY + y, minoType.index),
                          )
                      }
                    },
                    for (int y = 0; y < 20; y++) ...{
                      for (int x = 0; x < 10; x++) ...{
                        if (field[y][x] != 7)
                          CustomPaint(
                            painter: BlockPainter(x, y, field[y][x]),
                          )
                      }
                    },
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(
                top: 60,
                left: 30,
              )),
              ElevatedButton(onPressed: _leftMove, child: const Text('left')),
              ElevatedButton(onPressed: _rightMove, child: const Text('right')),
              ElevatedButton(
                onPressed: () => _minoRotate(true),
                child: const Icon(Icons.rotate_90_degrees_cw),
              ),
              ElevatedButton(
                onPressed: () => _minoRotate(false),
                child: const Icon(Icons.rotate_90_degrees_ccw),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(
                left: 30,
              )),
              ElevatedButton(
                onPressed: () {
                  timer = _onTimer();
                },
                child: const Icon(Icons.play_arrow),
              ),
              ElevatedButton(
                onPressed: () => timer!.cancel(),
                child: const Icon(Icons.stop),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downMove,
        child: const Text('Down'),
      ),
    );
  }
}

class BlockPainter extends CustomPainter {
  int positionX;
  int positionY;
  int minoColor;

  BlockPainter(this.positionX, this.positionY, this.minoColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paintRect = Paint()..color = minoColors[minoColor];
    final paintPath = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
        Rect.fromLTWH(
          block * (positionX),
          block * (positionY),
          block,
          block,
        ),
        paintRect);

    canvas.drawPath(
        Path()
          ..moveTo(
            block * (positionX),
            block * (positionY),
          )
          ..lineTo(
            block * (positionX + 1),
            block * (positionY),
          )
          ..lineTo(
            block * (positionX + 1),
            block * (positionY + 1),
          )
          ..lineTo(
            block * (positionX),
            block * (positionY + 1),
          )
          ..lineTo(
            block * (positionX),
            block * (positionY),
          ),
        paintPath);
  }

  @override
  bool shouldRepaint(BlockPainter oldDelegate) => true;
}
