import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_project/task.dart';

class TaskDetailsForm extends StatelessWidget {
  Task task;
  TaskDetailsForm(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Form'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Wrap(
                spacing: 2,
                children: [
                  SizedBox(
                      width: 120,
                      child: Text("Task Name:  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  Text(task.taskName),
                ],
              ),
              Wrap(
                spacing: 2,
                children: [
                  SizedBox(
                      width: 120,
                      child: Text("Task Description:  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  Flexible(
                    child: Text(
                      task.taskDescription,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 2,
                children: [
                  SizedBox(
                      width: 120,
                      child: Text("Task Status:  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  Text(task.taskStatus)
                ],
              )
            ],
          )),
    );
  }
}
