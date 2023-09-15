import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:collection';

final counterListProvider =
    StateNotifierProvider<CounterStateList, List<CounterState>>((ref) {
  return CounterStateList();
});

class CounterState extends StateNotifier<int> {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  String title;
  int id;

  CounterState(this.id, this.title, [int? state = 0]) : super(state ?? 0);

  void increment() {
    this.state++;
  }

  void deincrement() {
    this.state--;
  }

  void setName(String title) {
    this.title = title;
  }
}

class CounterStateList extends StateNotifier<List<CounterState>> {
  int nextId;
  CounterStateList({List<CounterState>? initList, this.nextId = 0})
      : super(initList ?? []);

  CounterState getCounter(int id) {
    int counterIndex = this.state.indexWhere((element) => element.id == id);
    CounterState counter = this.state[counterIndex];
    return counter;
  }

  CounterState append(title, [count = 0]) {
    CounterState newCounter = CounterState(this.nextId, title, count);
    this.state = [...this.state, newCounter];
    this.nextId++;

    return newCounter;
  }

  CounterState pop(int id) {
    CounterState counter = getCounter(id);

    // rebuilds the list without the deleted one
    this.state = this.state.where((counter) => counter.id != id).toList();

    return counter;
  }

  void moveToTop(int id) {
    CounterState counter = this.pop(id);
    this.state.add(counter);
  }
}
