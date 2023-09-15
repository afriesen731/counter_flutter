import 'package:counter_flutter/structures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';





class CounterPage extends ConsumerWidget {
  int id;
  late CounterState counter;
  var counterProvider;
  CounterPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final counterList = ref.watch(counterListProvider.notifier);
    this.counter = counterList.getCounter(this.id);

    this.counterProvider = StateNotifierProvider<CounterState, int>((ref) => this.counter);

    return Scaffold(
        appBar: AppBar(
          title: Text(this.counter.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        
        body: Stack(children: [
          // this positions the counter
          Column(
            children: [
              Flexible(
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 0.4,
                ),
              ),
              Text(
                '${ref.watch(this.counterProvider)}',
                style: Theme.of(context).textTheme.displayLarge,
              )
            ],
          ),

          // this positions the add button
          Column(
            children: [
              Flexible(
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 0.6,
                ),
              ),
              AddButton(
                counter: this.counter,
              ),
            ],
          ),

          // subtract button
          Positioned(
            left: 10,
            bottom: 10,
            child: IconButton(
              onPressed: () => this.counter.deincrement(), 
              icon: Icon(
                Icons.remove,
              ),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(50, 50)),
                iconSize: MaterialStateProperty.all<double>(30),
                backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColorLight),
              )
            )
          ),

          Positioned(
            right: 10,
            bottom: 10,
            child: IconButton(
              onPressed: () {
                ref.read(counterListProvider.notifier).pop(this.counter.id);
                context.pop();
              }, 
              icon: Icon(
                Icons.delete,
              ),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(50, 50)),
                iconSize: MaterialStateProperty.all<double>(30),
                backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColorLight),
              )
            )
          )
          
        
        

        
        ]));
  }
}

class AddButton extends ConsumerWidget {
  CounterState counter;
  AddButton({super.key, required this.counter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(100, 100)),
          iconSize: MaterialStateProperty.all<double>(50),
          backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).primaryColorLight),
        ),
        onPressed: () => this.counter.increment(),
        icon: Icon(Icons.add));
  }
}
