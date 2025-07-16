import 'dart:math';

String generateId() {
  final options = '0123456789abcdefghijklmnopqrstuvwxyz';
  final id = StringBuffer();
  for (var i = 0; i < 16; i++) {
    id.write(options[Random().nextInt(options.length)]);
  }
  return id.toString();
}
