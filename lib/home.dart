import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'structures.dart';

final titleControllerProvider = Provider.autoDispose<TextEditingController>(
    (ref) => TextEditingController());

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counters = ref.watch(counterListProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _newCounterDialog(context, ref);
        },
        child: Icon(Icons.add),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        padding: EdgeInsets.only(top: 80, bottom: 20, right: 20, left: 20),

        // turns the counters into a list
        children: counters
            .map((counter) => CounterItem(
                  counter: counter,
                ))
            .toList(),
      ),
    );
  }

  void _newCounterDialog(context, ref) {
    final FocusNode _titleFieldFocus = FocusNode();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final titleController = ref.watch(titleControllerProvider);
        return AlertDialog(
          title: Text('Enter title'),
          content: TextField(
            controller: titleController,
            focusNode: _titleFieldFocus,
            onEditingComplete: () {
              _newCounterFromInput(context, ref, titleController.text);
              titleController.text = '';
            },
          ),
        );
      },
    );

    _titleFieldFocus.requestFocus();
  }

  // make this work
  void _newCounterFromInput(BuildContext context, WidgetRef ref, String title) {
    CounterState counter = ref.read(counterListProvider.notifier).append(title);
    context.pop(); // hides the form for naming the counter
    context.push('/counter/local/${counter.id}');
  }
}

class CounterItem extends ConsumerWidget {
  CounterState counter;
  CounterItem({super.key, required this.counter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector( 
      onTapUp: (data) => context.push('/counter/local/${counter.id}'),
      child: Card(
        child: Stack(children: [
          Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 10),
              child: Text(
                this.counter.title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              )),
          Center(
            child: Text(
              '${this.counter.state}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  ref.read(counterListProvider.notifier).pop(this.counter.id);
                },
              )),
        ]),
      )
    );
  }
}
