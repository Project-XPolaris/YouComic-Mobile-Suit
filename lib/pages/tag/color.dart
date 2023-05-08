import 'dart:math';
import 'dart:ui';

Color generateRandomBackgroundColor(){
  var random = new Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256)
  );
}