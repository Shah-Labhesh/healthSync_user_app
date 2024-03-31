enum Environment { local,  dev , prod}

abstract class AppEnvironment{
    static late String androidBaseUrl;
    static late String shareUrl;
    static late String mapApiKey;
    static late double latitude;
    static late double longitude;
    static late Environment _environment;
    static Environment get environnment => _environment;
    static setupEnv(Environment env){
        _environment = env;
        switch(_environment){
            case Environment.local:
                androidBaseUrl = "http://10.0.2.2:8086/api/v1";
                shareUrl = "http://localhost:8086";
                mapApiKey = "AIzaSyBkVhR0qo33PVwEaedI6y504SzyzJf2l9U";
                latitude = 26.4831;
                longitude = 87.28337;
                break;
            case Environment.dev:
                androidBaseUrl = "https://fyp-health-sync.koyeb.app/api/v1";
                shareUrl = "https://fyp-health-sync.koyeb.app";
                mapApiKey = "AIzaSyBkVhR0qo33PVwEaedI6y504SzyzJf2l9U";
                latitude = 26.4831;
                longitude = 87.28337;
                break;
            
            case Environment.prod:
                androidBaseUrl = "";
                shareUrl = "";
                mapApiKey = "";
                latitude = 0.0;
                longitude = 0.0;
                break;
        }
    }
}