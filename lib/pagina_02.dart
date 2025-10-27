import 'package:aprendendo_git/main.dart';
import 'package:aprendendo_git/pagina_01.dart';
import 'package:aprendendo_git/pagina_03.dart';
import 'package:aprendendo_git/pagina_04.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: const Pagina02(),
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


// No additional imports or code needed at this location
class Pagina02 extends StatelessWidget {
  const Pagina02({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página 02'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Esta é a Página 02',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pagina_01');
              },
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 15),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),

              child: const Text('Ir para Página 01'),
            ),
            const SizedBox(height: 20),
 
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pagina_03');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 15),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Ir para Página 03'),
            ),
            const SizedBox(height: 20),
   

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 15),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Voltar para página anterior'),
            ),
          ],
        ),
      ),
    );
  }
}
class Paginas {
  const Paginas();
}
