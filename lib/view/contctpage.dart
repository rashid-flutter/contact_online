import 'package:contacts/service/firebase_service.dart';
import 'package:contacts/view/add_contact_screen.dart';
import 'package:contacts/view/editScreen.dart';
import 'package:flutter/material.dart';

class ContactListPage extends StatelessWidget {
  ContactListPage({super.key});
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final contacts = snapshot.data ?? [];
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(contact['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact['phone']),
                    const Divider(
                      thickness: 0.2,
                      color: Colors.black,
                    )
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _firestoreService.deleteContact(contact['id']);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditContactPage(contact: contact),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
