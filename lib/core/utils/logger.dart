import 'package:logger/logger.dart';

Logger logger = Logger(printer: MyPrinter(SimplePrinter()));

class MyPrinter extends LogPrinter {
  final LogPrinter _realPrinter;
  MyPrinter(this._realPrinter);

  @override
  List<String> log(LogEvent event) {
    var split = StackTrace.current.toString().split('\n');
    var stackTrace = split[3];
    /* for (var i = 4; i < split.length; i++) {
      stackTrace += '${split[i]}\n';
    } */

    var output = _realPrinter.log(event);
    return output.map((line) => '$line\n$stackTrace').toList();
  }
}
