import 'package:femu/src/emulators/gb/gb_rom_loader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:femu/gb.dart';

void main() {
  test(
    'GB test',
    () async {
      final rom = await GBRomLoader.loadFromPath('./demos/gb/test.gb');
      print(rom);
    },
    timeout: const Timeout(Duration(days: 1)),
  );
}
