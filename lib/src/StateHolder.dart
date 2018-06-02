import 'package:flutter/material.dart';

class StateHolder<T extends State> {
  T value;

  T applyState(T state) {
    value = state;
    return state;
  }
}
