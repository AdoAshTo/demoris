import 'package:flutter/material.dart';

const double width = 10;
const double height = 20;
const double block = 28;
const int minoSize = 4;
const fieldColumns = 10;
const fieldRows = 20;

enum Mino {
  I,
  O,
  S,
  Z,
  J,
  L,
  T,
}

 const List<Color> minoColors = [
  Colors.lightBlue,
  Colors.yellow,
  Colors.green,
  Colors.red,
  Colors.indigo,
  Colors.orange,
  Colors.purple,
];

const List<Mino> minoSet = [Mino.I,Mino.O,Mino.S,Mino.Z,Mino.J,Mino.L,Mino.T];

List<List<int>> minoCreate(Mino mino) {
  switch (mino) {
    case Mino.I:
      return [
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
      ];
    case Mino.O:
      return [
        [0, 0, 0, 0],
        [0, 1, 1, 0],
        [0, 1, 1, 0],
        [0, 0, 0, 0]
      ];
    case Mino.S:
      return [
        [0, 0, 0, 0],
        [0, 1, 1, 0],
        [1, 1, 0, 0],
        [0, 0, 0, 0]
      ];
    case Mino.Z:
      return [
        [0, 0, 0, 0],
        [1, 1, 0, 0],
        [0, 1, 1, 0],
        [0, 0, 0, 0]
      ];
    case Mino.J:
      return [
        [0, 0, 0, 0],
        [1, 0, 0, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0]
      ];
    case Mino.L:
      return [
        [0, 0, 0, 0],
        [0, 0, 1, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0]
      ];
    case Mino.T:
      return [
        [0, 0, 0, 0],
        [0, 1, 0, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0]
      ];
    default:
      return [];
  }
}

