import 'dart:io';

void main() {
  // stdin.pipe(stdout); // It have the same effect as follows:
  stdout.addStream(stdin);
}
