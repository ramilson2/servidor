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
      '/pagina_02': (context) => const Pagina02(),
      '/pagina_03': (context) => const Pagina03(),
      '/pagina_04': (context) => const Pagina04(),
    },
    initialRoute: '/',
  ));
}


// =================== +++++++++++++++++++++++++++++++++++++++ =========================
// Classe para mudança de tema claro e escuro
class MyAppTheme extends StatelessWidget {
  final Widget child;
  final bool isDarkTheme;

  const MyAppTheme({super.key, required this.child, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: child,
    );
  }
}

// ==================== +++++++++++++++++++++++++++++++++++++++ =========================
// Criação de um Switch para alternar entre temas claro e escuro
class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({super.key});
  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text(
            'Ativar Caixa de Texto',
            style: TextStyle(color: Colors.black),
          ),
          value: _isDarkTheme,
          onChanged: (value) {
            setState(() {
              _isDarkTheme = value;
            });
          },
            activeThumbColor: Colors.green[100], // Cor do thumb quando ativo 
            activeTrackColor: Colors.white, // Cor do track quando ativo
            // Adiciona uma borda ao thumb do switch quando ativo
            thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.green[200]!;
            }
            return Colors.grey;
            }),
            trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.grey;
            }
            return Colors.grey;
            }),
          inactiveThumbColor: Colors.green[700],
          inactiveTrackColor: Colors.white        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            enabled: _isDarkTheme,
            decoration: InputDecoration(
              labelText: 'Digite seu texto',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: _isDarkTheme ? Colors.white : Colors.grey[300],
            ),
          ),
        ),
      ],
    );
  }
  }



// ==================== +++++++++++++++++++++++++++++++++++++++ =========================
// Slide para ajustar o brilho da tela (simulado)
class BrightnessSlider extends StatefulWidget {
  const BrightnessSlider({super.key});

  @override
  State<BrightnessSlider> createState() => _BrightnessSliderState();
}

class _BrightnessSliderState extends State<BrightnessSlider> {
  double _brightness = 0.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: 10,
            // ignore: deprecated_member_use
            color: Colors.green.withOpacity(_brightness),
          ),  
          const Text(
            'Ajustar Brilho',
            style: TextStyle(color: Colors.black),
          ),
          Slider(
            value: _brightness,
            onChanged: (value) {
              setState(() {
                _brightness = value;
              });
            },
            activeColor: Colors.green[800],
           inactiveColor: Colors.green[50],
          ),
        ],
      ),
    );
  }
}


// ==================== +++++++++++++++++++++++++++++++++++++++ =========================
// Criação da opção de mudança de datas e horas na página principal
  class DateTimePicker extends StatefulWidget {
    const DateTimePicker({super.key});

    @override
    State<DateTimePicker> createState() => _DateTimePickerState();
  }

  class _DateTimePickerState extends State<DateTimePicker> {
    DateTime _selectedDateTime = DateTime.now();

// esta abaixo é a Future que seletor de data 
    Future<void> _pickDate() async {
      final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green[300]!, // header background
          onPrimary: Colors.blue[500]!, // header text
          onSurface: Colors.black, // body text
          ), dialogTheme: DialogThemeData(backgroundColor: Colors.green[100]), // background
        ),
        child: child!,
        );
      },
      );
      if (pickedDate != null) {
      setState(() {
        _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        _selectedDateTime.hour,
        _selectedDateTime.minute,
        );
      });
      }
    }
// esta abaixo é a Future que seletor de hora
    Future<void> _pickTime() async {
      final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) {
        return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green[300]!, // header background -> Aqui que ver a cor do ponteiro da hora
          onPrimary: Colors.blue[500]!, // header text
          onSurface: Colors.black, // cor do texto do corpo
          ), dialogTheme: DialogThemeData(backgroundColor: Colors.green[100]),
        ),
        child: child!,
        );
      },
      );
      if (pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
        );
      });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          const Text('Selecionar Data e Hora'),
          Text(
            '${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year} '
            '${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
          ),
       Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
          onPressed: _pickDate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[100],
            foregroundColor: Colors.black,
          ),
          child: const Text('Escolher Data'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
          onPressed: _pickTime,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[100],
            foregroundColor: Colors.black,
          ),
          child: const Text('Escolher Hora'),
              ),
            ],
          ),
        ],
      );
    }
  }



// ===================== +++++++++++++++++++++++++++++++++++++++ =========================
class Pagina01 extends StatelessWidget {
  const Pagina01({super.key});

  
  
  // ==================== +++++++++++++++++++++++++++++++++++++++ =========================
  // Aqui começa o código da página principal com o menu drawer 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: const Text('Menu Principal'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green[100],
              ),
              child: const Text('Configurações'),
            ),
            const ThemeSwitch(),
            const BrightnessSlider(),
            const DateTimePicker(),
            const Divider(),
            const Text('Outras Configurações'),
            ListTile(
              title: const Text('Opção 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Opção 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DateTimePicker(), // Inserida a class DateTimePicker na página principal
            // MyAppTheme(child: child, isDarkTheme: isDarkTheme), // Removed due to undefined variables
            const SizedBox(height: 40),
            ElevatedButton(

              onPressed: () {
                Navigator.pushNamed(context, '/pagina_01');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 12),
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
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 12),
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
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 12),
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
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 12),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Página 04'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 12),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Voltar ao Início'),
            ),    
          ],
        ),
      ),
    );
  }
}
    