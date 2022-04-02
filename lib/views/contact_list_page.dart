import 'package:flutter/material.dart';
import '../models/contact.dart';

import '../services/database_service.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {

  List<Contact> _contacts = [];
  DatabaseService _dbService = new DatabaseService();

  _loadContacts () async {
    _contacts = await _dbService.fetchContacts();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste contacts"),
      ),
      body: _contacts.length > 0 ? ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: _contacts.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(_contacts[index].fullName),
                    subtitle: Text(_contacts[index].phoneNumber),
                  )
                ],
              ),
            );
          }
      ) : Center(
        child: Text("Aucun contact dispobible", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
      ),
    );
  }
}
