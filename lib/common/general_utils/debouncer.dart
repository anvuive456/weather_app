import 'dart:async';

class Debouncer {

  ///Delay with millisecond
  ///
  /// Default with 1000ms
  final int delay;
  Timer? _timer;

  Debouncer({this.delay = 1000});

  run(void Function() action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: delay), action);
  }

  cancel() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
