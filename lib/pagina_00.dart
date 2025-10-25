import 'dart:convert';
import 'package:aprendendo_git/pagina_01.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/user.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Flutter + API JSON',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      // 🧭 Aqui declaramos as rotas nomeadas
      routes: {
        '/': (context) => const UserCrudPage(),
        '/pagina_01': (context) => const Pagina01(),
      },
      initialRoute: '/',
    );
  }
}

class ApiService {
  static const String baseUrl = 'http://localhost:8080/users'; // ajuste conforme o backend

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar usuários');
    }
  }

  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar usuário');
    }
  }

  Future<void> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário');
    }
  }

  Future<void> patchUser(int id, Map<String, dynamic> partial) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(partial),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar parcialmente');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar usuário');
    }
  }
}

class UserCrudPage extends StatefulWidget {
  const UserCrudPage({super.key});

  @override
  State<UserCrudPage> createState() => _UserCrudPageState();
}

class _UserCrudPageState extends State<UserCrudPage> {
  final ApiService api = ApiService();
  List<User> users = [];
  bool loading = false;

  void showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red : Colors.green,
    ));
  }
  Future<void> loadUsers() async {
    setState(() => loading = true);
    try {
      users = await api.getUsers();
      showSnack('Usuários carregados com sucesso!');
    } catch (e) {
      showSnack('Erro ao carregar usuários: $e', error: true);
    }
    setState(() => loading = false);
  }

  void openUserDialog({User? user}) {
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final idadeController = TextEditingController(text: user?.idade.toString() ?? '');
    final profissaoController = TextEditingController(text: user?.profissao ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
      backgroundColor: Colors.lightGreen[100],
        title: Center(child: Text(user == null ? 'Novo Usuário' : 'Editar Usuário')), content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: idadeController, decoration: const InputDecoration(labelText: 'Idade'), keyboardType: TextInputType.number),
            TextField(controller: profissaoController, decoration: const InputDecoration(labelText: 'Profissão')),
          ],
        ),
        actions: [
       TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(backgroundColor: Colors.green),
          child: const Text(
        'Cancelar',
        style: TextStyle(color: Colors.white),
          ),
        ),           
          TextButton(
            onPressed: () async {
              if (nameController.text.isEmpty || emailController.text.isEmpty) {
                showSnack('Nome e Email são obrigatórios!', error: true);
                return;
              }
              final newUser = User(
                id: user?.id ?? 0,
                name: nameController.text,
                email: emailController.text,
                idade: int.tryParse(idadeController.text) ?? 0,
                profissao: profissaoController.text,
              );
              try {
                if (user == null) {
                  await api.createUser(newUser);
                  showSnack('Usuário criado com sucesso!');
                } else {
                  await api.updateUser(newUser);
                  showSnack('Usuário atualizado com sucesso!');
                }
                loadUsers();
              } catch (e) {
                showSnack('Erro: $e', error: true);
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),

        ],
      ),
    );
  }

  Future<void> deleteUser(int id) async {
    try {
      await api.deleteUser(id);
      showSnack('Usuário deletado!');
      loadUsers();
    } catch (e) {
      showSnack('Erro ao deletar: $e', error: true);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Flutter + API JSON'),
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.normal,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FloatingActionButton(
          heroTag: "refresh",
          onPressed: loadUsers,
          backgroundColor: Colors.amber,
          tooltip: context.mounted ? 'Atualizar' : null,
          foregroundColor: Colors.white,
          child: const Icon(Icons.refresh),
            ),
            const SizedBox(width: 2),
          FloatingActionButton(
          heroTag: "add",
          onPressed: () => openUserDialog(),
          backgroundColor: Colors.amber,
          tooltip: "Adicionar",
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),  
             ),
          ],
        ),
       
      backgroundColor: Colors.amber[50],
      body: Column(
          children: [
            const SizedBox(height: 5),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              ElevatedButton(
              onPressed: loadUsers, // Aqui ele carrega os usuários na primeira coluna
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 15),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Mostrar Usuários 01'),
              ),
              ElevatedButton(
              onPressed: loadUsers, // Aqui ele carrega os usuários na outra coluna
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 15),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Mostrar Usuários 02'),
              ),
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
              child: const Text('Mostrar Usuários 03'),
              ),
                ],
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              const Text('Clique Acima para carregar os usuários da API'),
                ],
                ),
                
                const SizedBox(height: 5),

            Expanded(
            child: loading
              ? const Center(child: CircularProgressIndicator())
              : Row(
            children: [
              Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, i) {
                if (i % 3 != 0) return const SizedBox.shrink();
                final u = users[i];
                return Card(
              color: Colors.lightGreen[100],
              child: ListTile(
              title: Text('${u.name}    (${u.profissao})'),
              subtitle: Text('Email: ${u.email}\nIdade: ${u.idade}\nProfissão: ${u.profissao}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () => openUserDialog(user: u),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteUser(u.id ?? 0),
                ),
                ],
              ),
              ),
                );
                },
              ),
              ),
          
              const SizedBox(width: 8),
              Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, i) {
                if (i % 3 != 1) return const SizedBox.shrink();
                final u = users[i];
                return Card(
              color: Colors.lightGreen[100],
              child: ListTile(
              title: Text('${u.name}    (${u.profissao})'),
              subtitle: Text('Email: ${u.email}\nIdade: ${u.idade}\nProfissão: ${u.profissao}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () => openUserDialog(user: u),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteUser(u.id ?? 0),
                ),
                ],
              ),
              ),
                );
                },
              ),
              ),
            
            const SizedBox(width: 8),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, i) {
                if (i % 3 != 2) return const SizedBox.shrink();
                final u = users[i];
                return Card(
              color: Colors.lightGreen[100],
              child: ListTile(
              title: Text('${u.name}    (${u.profissao})'),
              subtitle: Text('Email: ${u.email}\nIdade: ${u.idade}\nProfissão: ${u.profissao}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () => openUserDialog(user: u),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteUser(u.id ?? 0),
                ),
                ],
              ),
              ),
                );
                },
              ),
              ),
            ],
            ),
            ),
            const SizedBox(width: 8),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.green,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Usuários',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Configurações',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info),
                  label: 'Sobre',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.web),
                  label: 'Página 01',
                ),
              ],
              onTap: (index) {
                // Implementar navegação conforme necessário
                showSnack('Item $index selecionado');
              },
            ),
       
          ],
        ),
    );
  }
}
