import 'package:contatos_de_pessoas/helpars/contatos_helpars.dart';
import 'package:flutter/material.dart';

class contactPage extends StatefulWidget {

  final Contact contact;

  contactPage({this.contact});

  @override
  _contactPageState createState() => _contactPageState();
}

class _contactPageState extends State<contactPage> {

  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.save),
        backgroundColor: Colors.green,
      ),
    );
  }
}
