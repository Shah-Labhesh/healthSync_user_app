enum Environment { local, dev , prod}

abstract class AppEnvironment{
    static late String androidBaseUrl;
    static late String shareUrl;
    static late String mapApiKey;
    static late Environment _environment;
    static Environment get environnment => _environment;
    static setupEnv(Environment env){
        _environment = env;
        switch(_environment){
            case Environment.local:
                androidBaseUrl = "http://10.0.2.2:8086/api/v1";
                shareUrl = "http://localhost:8086";
                mapApiKey = "AIzaSyBkVhR0qo33PVwEaedI6y504SzyzJf2l9U";
                break;
            case Environment.dev:
                androidBaseUrl = "";
                shareUrl = "";
                mapApiKey = "";
                break;
            case Environment.prod:
                androidBaseUrl = "";
                shareUrl = "";
                mapApiKey = "";
                break;
        }
    }
}