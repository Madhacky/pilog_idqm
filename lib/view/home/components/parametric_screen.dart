import 'package:flutter/material.dart';

class ParametrciScreen extends StatefulWidget {
  const ParametrciScreen({super.key});
  @override
  State<ParametrciScreen> createState() => _ParametrciScreenState();
}

class _ParametrciScreenState extends State<ParametrciScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParametrciScreen'),
      ),
      // working on it 
      body: getBody(),
    );
  }
  
 Widget getBody() {
  return const Column(
    children: [
      Text("Loading...")
    ],
  );
 }
}