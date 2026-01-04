import 'package:flutter/material.dart';
import '../models/destination.dart';

class AddDestinationForm extends StatefulWidget {
  final Destination? destination;
  final Function(Destination) onSave;

  const AddDestinationForm({
    super.key,
    this.destination,
    required this.onSave,
  });

  @override
  State<AddDestinationForm> createState() => _AddDestinationFormState();
}

class _AddDestinationFormState extends State<AddDestinationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _imageController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.destination?.title ?? '');
    _imageController = TextEditingController(text: widget.destination?.image ?? '');
    _descriptionController = TextEditingController(text: widget.destination?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _imageController,
            decoration: const InputDecoration(labelText: 'Image URL'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an image URL';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final destination = Destination(
                  id: widget.destination?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  image: _imageController.text,
                  description: _descriptionController.text,
                );
                widget.onSave(destination);
                Navigator.of(context).pop();
              }
            },
            child: Text(widget.destination == null ? 'Add Destination' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
