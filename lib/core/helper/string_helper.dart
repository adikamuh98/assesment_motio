import 'dart:math';

class StringHelper {
  static String generateRandomString(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      length,
      (index) => characters[random.nextInt(characters.length)],
    ).join();
  }
}
