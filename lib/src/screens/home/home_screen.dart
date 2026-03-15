import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_http_architecture/src/data/repositories/user_repository.dart';
import 'package:flutter_http_architecture/src/shared/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _userRepository = context.read<UserRepository>();

  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();

    _usersFuture = _userRepository.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load users: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: users.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final user = users[index];

              return ListTile(
                leading: CircleAvatar(child: Text(user.id.toString())),
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        },
      ),
    );
  }
}
