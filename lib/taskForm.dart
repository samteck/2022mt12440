import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:test_project/task.dart';

class TaskForm extends StatefulWidget {
  final bool? isUpdate;
  final Task? task;
  const TaskForm({Key? key, this.isUpdate, this.task}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  var _buttonText = "Submit";
  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.isUpdate == true) {
        this._taskNameController.text = widget.task!.taskName;
        this._taskDescriptionController.text = widget.task!.taskDescription;
        this._buttonText = "Update";
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _taskNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter task name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _taskDescriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter task description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Submit form
                    var taskObject = ParseObject("Task")
                      ..set("taskName", _taskNameController.text)
                      ..set("taskDescription", _taskDescriptionController.text)
                      ..set("taskStatus", "open");

                    if (widget.isUpdate == true) {
                      taskObject..objectId = widget.task!.taskId;
                      taskObject
                          .update()
                          .then((value) => Navigator.of(context).pop());
                    } else {
                      taskObject
                          .save()
                          .then((value) => Navigator.of(context).pop());
                    }
                  }
                },
                child: Text(this._buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
