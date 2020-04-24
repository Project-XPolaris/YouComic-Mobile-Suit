extension ListExtension on List<dynamic> {
  dynamic firstOrNull (bool test(element)){
    return this.firstWhere(test,orElse: () => null);
  }

}