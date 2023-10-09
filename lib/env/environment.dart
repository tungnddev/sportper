enum EnvironmentType { DEV, PROD }

class Environment {
  static Map<String, dynamic> _config = _Config.debugConstants;
  static EnvironmentType env = EnvironmentType.DEV;

  static void setEnvironment(EnvironmentType env) {
    Environment.env = env;
    switch (env) {
      case EnvironmentType.DEV:
        _config = _Config.debugConstants;
        break;
      case EnvironmentType.PROD:
        _config = _Config.prodConstants;
        break;
    }
  }

  static bool isDebugMode() {
    return env == EnvironmentType.DEV;
  }

  static get baseUrl {
    return _config[_Config.BASE_URL];
  }

}

class _Config {
  static const BASE_URL = "BASE_URL";

  static Map<String, dynamic> debugConstants = {
    BASE_URL: "https://apitest.com",
  };

  static Map<String, dynamic> prodConstants = {
    BASE_URL: "https://api.com",
  };
}
