import 'package:counter_flutter/home.dart';
import 'package:counter_flutter/structures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'home.dart';
import 'counter.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'counters',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade200),
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) =>
                  HomePage()
            ),
            GoRoute(
              path: '/counter/local/:id',
              builder: (BuildContext context, GoRouterState state) =>
                  CounterPage(id: int.parse(state.pathParameters['id']!)),
            )
          ],
        )
      );
  }
}
