import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserCrudPage extends StatefulWidget {
  const UserCrudPage({super.key});

  @override
  State<UserCrudPage> createState() => _UserCrudPageState();
}

class _UserCrudPageState extends State<UserCrudPage> {
  final String apiUrl = 'http://localhost:8080/users';
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final res = await http.get(Uri.parse(apiUrl));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      setState(() {
        users = data.map((u) => User.fromJson(u)).toList();
      });
    }
  }

  Future<void> addUser(String name, String email) async {
    final res = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email}),
    );
    if (res.statusCode == 200) fetchUsers();
  }

  Future<void> editUser(int id, String name, String email) async {
    final res = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email}),
    );
    if (res.statusCode == 200) fetchUsers();
  }

  Future<void> deleteUser(int id) async {
    final res = await http.delete(Uri.parse('$apiUrl/$id'));
    if (res.statusCode == 200) fetchUsers();
  }

  void showUserDialog({User? user}) {
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final isEditing = user != null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
      backgroundColor: Colors.lightGreen[100],
      title: Center(
        child: Text(
          isEditing ? 'Editar Usuário' : 'Novo Usuário',
          //style: const TextStyle(color: Colors.black),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
          labelText: 'Nome',
         
          ),
         
        ),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            //labelStyle: TextStyle(color: Colors.red),
          ),
        ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(backgroundColor: Colors.red),
          child: const Text(
        'Cancelar',
        style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
        onPressed: () async {
          final name = nameController.text.trim();
          final email = emailController.text.trim();
          if (name.isEmpty || email.isEmpty) return;

          if (isEditing && user.id != null) {
          await editUser(user.id!, name, email);
          } else if (!isEditing) {
          await addUser(name, email);
          }

          if (context.mounted) Navigator.pop(context);
        },
        style: TextButton.styleFrom(backgroundColor: Colors.green),
        child: const Text(
          'Salvar',
          style: TextStyle(color: Colors.white),
        ),
        ),
      ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Usuários (API Local)'),
        backgroundColor: Colors.greenAccent,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
        heroTag: "refresh",
        onPressed: () => fetchUsers(),
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
        onPressed: () => showUserDialog(),
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add),
          ),
        ],
      ),
      backgroundColor: Colors.green[100],
      body: users.isEmpty
          ? const Center(child: Text('Nenhum usuário encontrado'))
          : ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
                return Card(
                  color: Colors.white70,
                  margin: const EdgeInsets.fromLTRB(16, 5, 500, 8),
                  child: ListTile(
                    title: Text('Nome: ${user.name}'),
                    subtitle: Text('Email: ${user.email}\nID: ${user.id}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showUserDialog(user: user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            if (user.id != null) {
                              deleteUser(user.id!);
                            }
                          },
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),  
                  ),
                );
                
              },
            ),
           
    );
  
  }
}
