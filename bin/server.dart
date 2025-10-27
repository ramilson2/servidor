import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:path/path.dart' as p;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

final String jsonPath = p.join(Directory.current.path, 'apis', 'users_01.json');
final String jsonPath2 = p.join(Directory.current.path, 'apis', 'login.json');

Future<List<Map<String, dynamic>>> _readUsers() async { //Abre o arquivo de usuários.
  final file = File(jsonPath);
  if (!await file.exists()) return []; // Retorna uma lista vazia se o arquivo não existir.
  final data = await file.readAsString(); // Lê o conteúdo do arquivo e converte de JSON para uma lista de mapas (cada mapa representa um usuário).
  return List<Map<String, dynamic>>.from(json.decode(data));
}

Future<void> _writeUsers(List<Map<String, dynamic>> users) async { // Salva a lista de usuários no arquivo JSON.
  final file = File(jsonPath); // Abre o arquivo de usuários.
  await file.writeAsString(json.encode(users), flush: true); // Escreve a lista de usuários no arquivo. Usa flush: true para garantir que os dados sejam gravados imediatamente.
}

void main() async { // Ponto de entrada do servidor.
  final router = Router(); // Cria um roteador para definir as rotas da API.

  // GET /users
  router.get('/users', (Request req) async { //
    final users = await _readUsers(); // Lê a lista de usuários do arquivo JSON.
    return Response.ok(json.encode(users), headers: {'Content-Type': 'application/json'}); // Retorna a lista de usuários como resposta JSON.
  });

  // POST /users
  router.post('/users', (Request req) async {
    final body = await req.readAsString();
    final newUser = json.decode(body);
    final users = await _readUsers();
    final newId = users.isEmpty ? 1 : (users.last['id'] as int) + 1;
    newUser['id'] = newId;
    users.add(Map<String, dynamic>.from(newUser));
    await _writeUsers(users);
    return Response.ok(json.encode(newUser), headers: {'Content-Type': 'application/json'});
  });

  // PUT /users/<id>
  router.put('/users/<id|[0-9]+>', (Request req, String id) async {
    final body = await req.readAsString();
    final updatedUser = json.decode(body);
    final users = await _readUsers();
    final index = users.indexWhere((u) => u['id'] == int.parse(id));
    if (index == -1) return Response.notFound('Usuário não encontrado');
    users[index] = {...users[index], ...updatedUser};
    await _writeUsers(users);
    return Response.ok(json.encode(users[index]), headers: {'Content-Type': 'application/json'});
  });

  // DELETE /users/<id>
  router.delete('/users/<id|[0-9]+>', (Request req, String id) async {
    final users = await _readUsers();
    users.removeWhere((u) => u['id'] == int.parse(id));
    await _writeUsers(users);
    return Response.ok(json.encode({'message': 'Usuário deletado'}), headers: {'Content-Type': 'application/json'});
  });

  // Middleware de CORS
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router.call);

  final server = await io.serve(handler, 'localhost', 8080);
  print('✅ Servidor \'login_server\' rodando em http://localhost:${server.port}');
}
