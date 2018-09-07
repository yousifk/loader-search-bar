import 'package:flutter/material.dart';

class StateHolder<T extends State> {
  T value;

  T applyState(T state) {
    value = state;
    return state;
  }

  void runSafe(void block(T)) {
    if (value != null) block(value);
  }
}
