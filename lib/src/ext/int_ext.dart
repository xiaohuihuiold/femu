/// int扩展
extension IntExt on int {
  String toHexString([int length = 4]) {
    return toRadixString(16).toUpperCase().padLeft(length * 2, '0');
  }
}
