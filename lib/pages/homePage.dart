import 'package:flutter/material.dart';

import '../models/todo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
  }

  List<ToDo> todos = [
    ToDo(
      id: 1,
      title: 'Grocery Shopping',
      description: 'Buy milk, eggs, bread, and cheese from the supermarket.',
      price: 55.0,
      isDone: false,
      index: 0,
      groupId: 1,
    ),
    ToDo(
      id: 2,
      title: 'Pay Bills',
      description: 'Pay electricity and internet bills.',
      price: 120.0,
      isDone: true,
      index: 1,
      groupId: 2,
    ),
    ToDo(
      id: 3,
      title: 'Book Appointment',
      description: 'Book a doctor appointment for next week.',
      price: 50.0,
      isDone: false,
      index: 2,
      groupId: 3,
    ),
    ToDo(
      id: 4,
      title:'Pick up Laundry',
      description: 'Pick up the laundry from the dry cleaners.',
      price: 15.0,
      isDone: true,
      index: 3,
      groupId: 1,
    ),
    ToDo(
      id: 5,
      title: 'Call Mom',
      description: 'Call mom and wish her a happy birthday.',
      price: 0.0,
      isDone: false,
      index: 4,
      groupId: 4,
    ),
    ToDo(
      id: 6,
      title: 'Finish Project',
      description: 'Complete the project report and submit it by tomorrow.',
      price: 0.0,
      isDone: false,
      index: 5,
      groupId: 2,
    ),
  ];


  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(title: Text('Item'),trailing: Text('Price'),),
            ...todos.map((e)=>ListTile(leading: Text(e.id.toString()), title: Text(e.title),subtitle: Text(e.description),trailing: Text(e.price.toStringAsFixed(2)+" \$"),) )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}