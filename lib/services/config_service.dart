class AppConfig {
  static const String appEnv = "production"; // or "development" or "local"

  static const Map<String, Map<String, String>> urlConfig = {
    "local": {
      "LOGIN": "http://10.0.2.2:4000/api/v1/auth/login/employee",
      "PROFILE": "http://10.0.2.2:4000/api/v1/employees/profile",
      "SESSIONS": "http://10.0.2.2:3010/api/v1/sessions/app",
      "DAILY_STATS": "http://10.0.2.2:3010/api/v1/stats/daily",
      "WEEKLY_STATS": "http://10.0.2.2:3010/api/v1/stats/weekly",
    },
    "development": {
      "LOGIN": "https://remotintegrity-auth.vercel.app/api/v1/auth/login/employee",
      "PROFILE": "https://crm-amber-six.vercel.app/api/v1/employee",
      "SESSIONS": "https://tracker-beta-kohl.vercel.app/api/v1/sessions/app",
      "DAILY_STATS": "https://tracker-beta-kohl.vercel.app/api/v1/stats/daily",
      "WEEKLY_STATS":
          "https://tracker-beta-kohl.vercel.app/api/v1/stats/weekly",
    },
    "production": {
      "LOGIN": "https://auth.remoteintegrity.com/api/v1/auth/login/employee",
      "PROFILE": "https://auth.remoteintegrity.com/api/v1/employees/profile",
      "SESSIONS": "https://tracker.remoteintegrity.com/api/v1/sessions/app",
      "DAILY_STATS": "https://tracker.remoteintegrity.com/api/v1/stats/daily",
      "WEEKLY_STATS": "https://tracker.remoteintegrity.com/api/v1/stats/weekly",
    }
  };

  static Map<String, String> get urls => urlConfig[appEnv]!;
  static bool get debug => appEnv != "production";
}
