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
      title: ' -- Skymed  --',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
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
  bool isDarkMode = false;

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
        title: const Text(' Skymed - Gestão de Médicos '),
        backgroundColor: Colors.green[100],
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.normal,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.lerp(EdgeInsets.zero, EdgeInsets.all(16), 0.5),// esquerda, cima, direita, baixo
          children: [ // Mudar essa parte acima
            DrawerHeader(
              decoration: BoxDecoration(
              color: Colors.green[200],
              ),
              child: const Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),ExpansionTile(
              leading: const Icon(Icons.people),  
              //backgroundColor: Colors.green[100],
              title: const Text('Usuários'),
              children: [
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Listar Usuários'),
                  onTap: () {
                    Navigator.pop(context);
                    loadUsers();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Adicionar Usuário'),
                  onTap: () {
                    Navigator.pop(context);
                    openUserDialog();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Buscar Usuário'),
                  onTap: () {
                    Navigator.pop(context);
                    showSnack('Funcionalidade de busca ainda não implementada');
                  },
                ),
                ListTile( // Mudar
                  leading: const Icon(Icons.delete), 
                  title: const Text('Deletar Usuário'),
                  onTap: () {
                    Navigator.pop(context);
                    deleteUser(0); // Exemplo: deletar usuário com ID 0
                  },
                ),
               
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              children: [
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Segurança'),
                  onTap: () {
                    Navigator.pop(context);
                    showSnack('Configurações de segurança');
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                title: const Center(child: Text('Sobre')),
                content: const Text('Contactar o suporte para mais informações:\nsupporte@skymed.com'),
                actions: [
                  TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'),
                  ),
                ],
                ),
              );
              },
            ),
            ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Idioma'),
                onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                  title: const Center(child: Text('Escolha o idioma')),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    ListTile(
                      title: const Text('Português'),
                      onTap: () {
                      Navigator.pop(context);
                      showSnack('Idioma alterado para Português');
                      },
                    ),
                    ListTile(
                      title: const Text('English'),
                      onTap: () {
                      Navigator.pop(context);
                      showSnack('Language changed to English');
                      },
                    ),
                    ListTile(
                      title: const Text('Español'),
                      onTap: () {
                      Navigator.pop(context);
                      showSnack('Idioma cambiado a Español');
                      },
                    ),
                    ],
                  ),
                  actions: [
                    TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                    ),
                  ],
                  ),
                );
                },
              ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre'),
              onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                title: const Center(child: Text('Sobre')),
                content: const Text('Desenvolvido por Ramilson\nVersão 2.9'),
                actions: [
                  TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'),
                  ),
                ],
                ),
              );
              },
            ),ListTile(
              leading: const Icon(Icons.web),
              title: const Text('Página 01'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pagina_01');
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "refresh",
            onPressed: loadUsers,
            backgroundColor: Colors.green[50],
            tooltip: context.mounted ? 'Atualizar' : null,
            foregroundColor: Colors.green,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 2),
          FloatingActionButton(
            heroTag: "add",
            onPressed: () => openUserDialog(),
            backgroundColor: Colors.green[50],
            tooltip: "Adicionar",
            foregroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
        ],
      ),



      backgroundColor: const Color(0xFFF9F5FF), // Cor de fundo suave do Scaffold
      body: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                ElevatedButton.icon(
                icon: const Icon(Icons.people, color: Colors.black),
                onPressed: loadUsers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 15),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
                label: const Text(' Usuários'),
                )
                
                ,ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/pagina_01');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 15),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                 ),
                child: const Text('Pagina 01'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Clique Acima para carregar os usuários da API'),
            ],
          ),

                        SizedBox(
                        width: 350,
                        child: SegmentedButton<bool>(
                          segments: const [
                          ButtonSegment(value: false, label: Text("Claro")),
                          ButtonSegment(value: true, label: Text("Escuro")),
                          ],
                          selected: {isDarkMode},
                          onSelectionChanged: (Set<bool> newSelection) {
                          setState(() {
                            isDarkMode = newSelection.first;
                          });
                          },
                        ),
                        ),

            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(775.0, 10.0, 40.0, 0.0), // esquerda, cima, direita, baixo
            child: TextField(
              decoration: const InputDecoration(
              labelText: 'Buscar por Nome, Profissão ou ID',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              ),
              onChanged: (query) {
              setState(() {
                // Filtra usuários por nome, profissão ou id
                if (query.isEmpty) {
                // Se vazio, recarrega todos
                loadUsers();
                } else {
                users = users.where((u) {
                  final idStr = u.id?.toString() ?? '';
                  return u.name.toLowerCase().contains(query.toLowerCase()) ||
                    u.profissao.toLowerCase().contains(query.toLowerCase()) ||
                    idStr.contains(query);
                }).toList();
                }
              });
              },
            ),
            ),
            const SizedBox(height: 5),
            Expanded(
            child: loading
              ? const Center(child: CircularProgressIndicator())
              : Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 1150, // ajuste a largura conforme necessário
                child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, i) {
                final u = users[i];
                return Card(
                color: Colors.green[50],
                child: ListTile(
                  title: Text('${u.name}    (${u.profissao})'),
                  subtitle: Text('Email: ${u.email}\nIdade: ${u.idade}\nID: ${u.id}'),
                  trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () => openUserDialog(user: u),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                      title: const Text('Confirmação'),
                      content: const Text('Você deseja realmente excluir o usuário?'),
                      actions: [
                        TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                        ),
                        TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                      ),
                    );
                    if (confirm == true) {
                      deleteUser(u.id ?? 0);
                    }
                    },

                  ),
                  ],
                  ),
                ),
                );
                },
                ),
              ),
              ),
            ),
          const SizedBox(width: 8),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.green[200],
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.black,
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
        // Adicione este item normalmente, mas para mostrar o popup, altere o onTap do BottomNavigationBar:
              BottomNavigationBarItem(
                icon: Icon(Icons.web),
                label: 'Página 01',
              ),
            ],
            onTap: (index) {
              switch (index) {
              case 0:
                showDialog(
                context: context,
                builder: (_) => AlertDialog(
                    title: const Center(child: Text('Home')),
                  content: const Text('Bem-vindo à Home!'),
                  actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  ),
                  ],
                ),
                );
                break;
              case 1:
                onPressed: () => Navigator.pop(context);
                loadUsers();
                break;
              case 2:
                showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Center(child: Text('Configurações')),
                  content: const Text('Configurações do sistema.'),
                  actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  ),
                  ],
                ),
                );
                break;
              case 3:
                showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Center(child: Text('Sobre')),
                  content: const Text('Desenvolvido por Ramilson\nVersão 2.9'),
                  actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  ),
                  ],
                ),
                );
                break;
              case 4:
                showDialog(
                context: context,
                builder: 
                  (_) => AlertDialog(
                  title: const Center(child: Text('Página 01')),
                  content: const Text('Você será redirecionado para Página 01.'),
                  actions: [
                  TextButton(
                    onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/pagina_01');
                    },
                    child: const Text('Ir'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ],
                ),
                );
                break;
              }
            },
          ),
        ],
      ),
    );
  }
}
