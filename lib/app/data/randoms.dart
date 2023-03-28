import 'dart:math';

extension Randoms on List<String> {
  String adsId(){
    Random random = Random();
    int index = random.nextInt(length);
    return elementAt(index);
  }
}