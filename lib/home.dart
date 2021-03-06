import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _editingController = TextEditingController();
  final TextEditingController _updatingController = TextEditingController();

  Box? todoBox;

  @override
  void initState() {
    todoBox = Hive.box('todoList');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 205, 151),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text(
                "ToDo",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 12,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box('todoList').listenable(),
                    builder: (_, box, widget) {
                      return ListView.builder(
                        reverse: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: todoBox!.keys.toList().length,
                        itemBuilder: (_, index) {
                          return Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                todoBox!.getAt(index).toString(),
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    6,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextField(
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      onEditingComplete:
                                                          () async {
                                                        final navigator =
                                                            Navigator.of(
                                                                context);
                                                        final input =
                                                            _updatingController
                                                                .text;
                                                        await todoBox!.putAt(
                                                            index, input);
                                                        navigator.pop();
                                                        _updatingController
                                                            .clear();
                                                      },
                                                      controller:
                                                          _updatingController
                                                            ..text = todoBox!
                                                                .getAt(index),
                                                      decoration:
                                                          const InputDecoration(
                                                        label: Text(
                                                            'Update Your Todo'),
                                                        labelStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              "verdana_regular",
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          final navigator =
                                                              Navigator.of(
                                                                  context);
                                                          final input =
                                                              _updatingController
                                                                  .text;
                                                          await todoBox!.putAt(
                                                              index, input);
                                                          navigator.pop();
                                                          _updatingController
                                                              .clear();
                                                        },
                                                        child: const Text(
                                                            'Submit'))
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await todoBox!.deleteAt(index);
                                      },
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height / 10,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () async {
                    final input = _editingController.text;
                    await todoBox!.add(input);

                    _editingController.clear();
                  },
                  controller: _editingController,
                  decoration: const InputDecoration(
                    label: Text('Write Your Todo'),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                final input = _editingController.text;
                await todoBox!.add(input);

                _editingController.clear();
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
