import 'dart:io';
import 'dart:math';

void main() async {
  var path = './lib/ascii_animation/ascii_dog.txt';

  var lines = await File(path).readAsLines();

  display(AsciiImage(
      'dog', List.generate(lines.length, (i) => lines[i].split(''))));
}

void display(AsciiImage image) {
  Console.draw(image);
  var cmd = _getCmd();
  while (cmd != 'exit') {
    var steps = _getSteps();
    switch (cmd) {
      case 'up':
        image.moveUp(steps);
        Console.draw(image);
        break;
      case 'down':
        image.moveDown(steps);
        Console.draw(image);
        break;
      case 'left':
        image.moveLeft(steps);
        Console.draw(image);
        break;
      case 'right':
        image.moveRight(steps);
        Console.draw(image);
        break;
      default:
        break;
    }
    if (!image.isValid()) {
      stdout.writeln('Aha~~~ the ${image.name} has disappeared! Game Over!');
      return;
    }
    cmd = _getCmd();
  }
}

class Console {
  static const height = 30;
  static const width = 118;

  static void draw(AsciiImage image) {
    var outImage = _needCut(image) ? image.cut(height, width) : image;
    stdout.writeln(outImage.content);
  }
}

bool _needCut(AsciiImage image) =>
    image.height > Console.height || image.width > Console.width;

bool _isValidCmd(String cmd) =>
    cmd == 'left' ||
    cmd == 'right' ||
    cmd == 'up' ||
    cmd == 'down' ||
    cmd == 'exit';

String _getCmd() {
  stdout.write(
      'Now try to move the dog! left, right, up or down. exit for quit: ');
  var cmd = stdin.readLineSync()!.toLowerCase();
  while (!_isValidCmd(cmd)) {
    stdout.write('Invalid Command! left, right, up or down. exit for quit: ');
    cmd = stdin.readLineSync()!.toLowerCase();
  }
  return cmd;
}

int _getSteps() {
  var steps = -1;
  while (steps < 0) {
    stdout.write('Please input the steps(an integer >= 0): ');
    try {
      steps = int.parse(stdin.readLineSync()!);
    } catch (e) {
      print(e);
    }
  }
  return steps;
}

class AsciiImage {
  static const placeholder = ' ';

  String name;

  final List<List<String>> asciis;

  AsciiImage(this.name, this.asciis);

  AsciiImage.generateEmptyImage(this.name, int height, int width)
      : asciis = List.generate(
            height, (_) => List.filled(width, placeholder, growable: true));

  int get height => asciis.length;

  int get width => asciis.isEmpty ? 0 : asciis[0].length;

  void moveLeft(int x) {
    for (var line in asciis) {
      line.removeRange(0, min(x, width));
    }
  }

  void moveRight(int x) {
    for (var line in asciis) {
      line.insertAll(0, List.filled(x, placeholder));
    }
  }

  void moveUp(int y) => asciis.removeRange(0, min(y, height));

  void moveDown(int y) => asciis.insertAll(0,
      List.generate(y, (_) => List.filled(width, placeholder, growable: true)));

  // 裁剪，根据给定的高和宽，当图形移动超出屏幕显示范围时，需要裁剪
  AsciiImage cut(int h, int w) => AsciiImage(
      name,
      List.generate(
          min(height, h), (i) => asciis[i].sublist(0, min(width, w))));

  // 字符画的本质是字符串，因此将其转换为字符串以便输出
  String get content {
    var buffer = StringBuffer();
    for (var line in asciis) {
      buffer.write('${line.join()}\n');
    }
    return buffer.toString();
  }

  bool isValid() => height > 0 && width > 0;
}
