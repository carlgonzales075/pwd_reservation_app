class DomainEnvs {
  static const String _devEnvDomain = 'http://172.26.80.1:8080';
  static const String _prodEnvDomain = 'http://sample.com';
  static const bool isDev = true;

  static String getDomain() {
    if (isDev) {
      return _devEnvDomain;
    } else {
      return _prodEnvDomain;
    }
  }
}