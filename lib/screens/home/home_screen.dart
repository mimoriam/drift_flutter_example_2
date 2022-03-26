import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Models:

/// Screens:

/// Widgets:

/// Services:
import '../../services/db.dart';

/// State:

/// Utils/Helpers:
import '../../utils/responsive_helper.dart';
import 'package:drift/drift.dart' as Moor;

/// Entry Point:
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<MyDB>(context);
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drift example - pls work!"),
      ),
      body: SafeArea(
        child: ResponsiveHelper(
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(hintText: "Title"),
                controller: _titleController,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(hintText: "Content"),
                controller: _contentController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Create:
                  ElevatedButton(
                    onPressed: () {
                      database.insertTodo(TodosCompanion(
                        title: Moor.Value(_titleController.text),
                        content: Moor.Value(_contentController.text),
                      ));
                    },
                    child: Text("Add"),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: database.watchAllTodoEntries(),
                  builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
                    final todos = snapshot.data;

                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data == null) {
                        return const Text("You don't have any unfinished Todos");
                      }
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: todos!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final items = todos[index];

                          return ListTile(
                            subtitle: ElevatedButton(
                              onPressed: () {
                                database.updateTodo(
                                  Todo(
                                      id: items.id,
                                      title: (_titleController.text),
                                      content: (_contentController.text),
                                      completed: items.completed),
                                );
                              },
                              child: const Text("Update"),
                            ),
                            leading: ElevatedButton(
                              onPressed: () {
                                database.deleteTodo(items.id);
                              },
                              child: const Text("Delete"),
                            ),
                            title: Text(items.title),
                            trailing: Text(items.content),
                          );
                        },
                      );
                    }
                    return const Text("Boop");
                  },
                ),
              ),
            ],
          ),
          tablet: Container(),
          desktop: Container(),
        ),
      ),
    );
  }
}
