import 'package:logger/logger.dart';

class WDLog{
  static final Logger logger = Logger(
    printer : PrettyPrinter()
  );

  static void i(Object message){
    logger.i(message);
  }
  static void d(Object message){
    logger.d(message);
  }
  static void e(Object message){
    print('------------------------------');
    print('------------------------------');
    print(message);
    print('------------------------------');
    print('------------------------------');
    logger.e(message);
  }
}