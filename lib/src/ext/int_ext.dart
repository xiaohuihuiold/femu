/// int扩展
extension IntExt on int {
  String toHexString([int length = 4]) {
    return toRadixString(16).padLeft(4 * 2, '0');
  }
}
