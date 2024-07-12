import 'dart:math';

extension RandomElementListX<T> on List<T> {
  T getRandomElement() {
    final randomIndex = Random().nextInt(length);
    return this[randomIndex];
  }
}

extension RandomElementIntX on int {
  static int getRandomInRange(int min, int max) {
    return min + Random().nextInt(max - min + 1);
  }
}

extension RandomElementDateTimeX on DateTime {
  static DateTime getRandomDate() {
    final randomYear = Random().nextInt(10) + 2010;
    final randomMonth = Random().nextInt(12) + 1;
    final randomDay = Random().nextInt(28) + 1;
    return DateTime(randomYear, randomMonth, randomDay);
  }
}

class RandomVinFactory {
  String getRandomVin() {
    const vinChars = '0123456789ABCDEFGHJKLMNPRSTUVWXYZ';
    const vinLength = 17;
    final vin = List.generate(vinLength, (index) {
      final randomIndex = Random().nextInt(vinChars.length);
      return vinChars[randomIndex];
    }).join();
    return vin;
  }
}
