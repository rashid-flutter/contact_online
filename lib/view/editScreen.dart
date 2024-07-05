import 'package:contacts/service/firebase_service.dart';
import 'package:flutter/material.dart';

class EditContactPage extends StatefulWidget {
  final Map<String, dynamic> contact;

 const EditContactPage({required this.contact});

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact['name']);
    _phoneController = TextEditingController(text: widget.contact['phone']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Edit Contact')),
      body: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration:const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration:const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  } else if (value.length <= 9) {
                    return 'Must be 10 charecter';
                  }
                  return null;
                },
              ),
            const  SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _firestoreService.updateContact(
                      widget.contact['id'],
                      _nameController.text,
                      _phoneController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child:const Text('Update Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
