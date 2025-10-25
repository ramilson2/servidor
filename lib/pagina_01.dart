import 'package:aprendendo_git/main.dart';
import 'package:aprendendo_git/pagina_02.dart';
import 'package:aprendendo_git/pagina_03.dart';
import 'package:aprendendo_git/pagina_04.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: const Pagina01(),
    routes: {
      '/': (context) => const UserCrudPage(),
      '/main': (context) => const MyApp(),
      '/pagina_01': (context) => const Pagina01(),
      '/pagina_02': (context) => const Pagina02(),
      '/pagina_03': (context) => const Pagina03(),
      '/pagina_04': (context) => const Pagina04(),
    },
    initialRoute: '/',
  ));
}

class Pagina01 extends StatelessWidget {
  const Pagina01({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Menu Principal'),
      ),
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pagina_01');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Página 01'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pagina_02');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Página 02'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pagina_03');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Página 03'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pagina_04');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Página 04'),
            ),
          ],
        ),
      ),
    );
  }
}
    