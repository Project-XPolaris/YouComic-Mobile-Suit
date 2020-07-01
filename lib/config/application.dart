class ApplicationConfig {
  var useNanoMode = false;
  static final ApplicationConfig _singleton = ApplicationConfig._internal();
  factory ApplicationConfig() {
    return _singleton;
  }
  ApplicationConfig._internal();
}