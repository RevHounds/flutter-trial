import '../data/repo/location_repository.dart';
import '../data/repo/app_repository.dart';
enum Flavor{
  MOCK,
  PRO
}

class Injector{
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;
  static ProLocationRepository proLocationRepository = new ProLocationRepository();
  static MockApplicationRepository mockApplicationRepository = new MockApplicationRepository();

  static void configure(Flavor flavor) {
    _flavor = flavor; 
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  ApplicationRepository get applicationRepository{
    return mockApplicationRepository;
  }

  LocationRepository get locationRepository{
    return proLocationRepository;
  }

}