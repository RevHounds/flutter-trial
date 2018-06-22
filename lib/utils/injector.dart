import '../data/repo/location_repository.dart';

enum Flavor{
  MOCK,
  PRO
}

class Injector{
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;
  static MockLocationRepository mockLocationRepository = new MockLocationRepository();

  static void configure(Flavor flavor) {
    _flavor = flavor; 
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  LocationRepository get locationRepository{
    switch(_flavor){
      case Flavor.MOCK: return mockLocationRepository;
      default: return mockLocationRepository;
    }
  }

}