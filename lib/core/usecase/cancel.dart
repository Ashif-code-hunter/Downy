class CancellationToken {
  bool _isCancelled = false;

  bool get isCancellationRequested => _isCancelled;

  void cancel() {
    _isCancelled = true;
  }
}