import 'package:contact_list/repositories/contact_repository.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ContactRepository _contactRepository = ContactRepository();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
