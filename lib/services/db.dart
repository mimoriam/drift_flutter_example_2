import 'package:drift/drift.dart';
import 'package:drift_flutter_example_2/models/todo.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'db.g.dart';

// Actual CRUD operation is here:
@DriftDatabase(tables: [Todos])
class MyDB extends _$MyDB {
  MyDB() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Todo>> getAllTodoEntries() => select(todos).get();
  Stream<List<Todo>> watchAllTodoEntries() => select(todos).watch();

  Future insertTodo(TodosCompanion todo) => into(todos).insert(todo);

  // Future updateTodo(TodosCompanion todo) => (update(todos)..where((t) => t.id.equals(todo.id)))
  //     .write(TodosCompanion(title: todo.title, content: todo.content));

  Future updateTodo(Todo entry) => update(todos).replace(entry);

  // Future createOrUpdateTodo(Todo todo) => into(todos).insertOnConflictUpdate(todo);
  Future deleteTodo(int id) => (delete(todos)..where((t) => t.id.equals(id))).go();

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          // we added the dueDate property in the change from version 1
          // Insert changes below:
          // await m.addColumn(todos, todos.dueDate);
        }
      });
}

// Opens the connection to SQLite DB:
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
