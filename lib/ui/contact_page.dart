import 'dart:io';

import 'package:flutter/material.dart';

import '../repositories/contact_repository.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key, this.contact}) : super(key: key);

  final Contact? contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _userUpdated = false;
  late Contact _updatedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _updatedContact = Contact();
    } else {
      _updatedContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _updatedContact.name;
      _emailController.text = _updatedContact.email;
      _phoneController.text = _updatedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _updatedContact.name.isNotEmpty
              ? _updatedContact.name
              : 'Novo Contato',
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _updatedContact.image.isEmpty
                        ? FileImage(File(_updatedContact.image))
                        : const AssetImage('assets/images/user.png')
                            as ImageProvider,
                    // https://www.flaticon.com/free-icons/person // person icons // Person icons created by Ilham Fitrotul Hayat - Flaticon
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
              onChanged: (name) {
                _userUpdated = true;
                setState(() {
                  _updatedContact.name = name;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (email) {
                _userUpdated = true;
                _updatedContact.email = email;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
              ),
              onChanged: (phone) {
                _userUpdated = true;
                _updatedContact.phone = phone;
              },
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}
