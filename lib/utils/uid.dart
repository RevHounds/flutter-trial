import 'package:uuid/uuid.dart';

abstract class UidContract{
	String generateUID();
}

class IDGenerator implements UidContract{
	@override
	String generateUID(){
    return new Uuid().v1();
  }
}