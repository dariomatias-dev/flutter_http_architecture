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
  late Future<List<UserModel>> _usersFuture;

  void _handleLoadUsers() {
    setState(() {
      _usersFuture = context.read<UserRepository>().getUsers();
    });
  }

  Future<void> _handleRefresh() async {
    _handleLoadUsers();

    await _usersFuture;
  }

  void _handleLogout() {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void initState() {
    super.initState();

    _handleLoadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.0,
        scrolledUnderElevation: 2.0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Membros',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 26.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                ),
              ),
              Text(
                'Diretório da organização',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          AppBarActionWidget(
            icon: Icons.refresh_rounded,
            onPressed: _handleLoadUsers,
          ),
          const SizedBox(width: 8.0),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: AppBarActionWidget(
              icon: Icons.logout_rounded,
              onPressed: _handleLogout,
              color: const Color(0xFFEF4444),
              backgroundColor: const Color(0xFFFEF2F2),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF111827),
        displacement: 20.0,
        onRefresh: _handleRefresh,
        child: FutureBuilder<List<UserModel>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF111827),
                  strokeWidth: 2.5,
                ),
              );
            }

            if (snapshot.hasError) {
              return ErrorStateWidget(onRetry: _handleLoadUsers);
            }

            final users = snapshot.data ?? <UserModel>[];

            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 24.0,
              ),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: users.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                return UserListTileWidget(user: users[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class UserListTileWidget extends StatelessWidget {
  const UserListTileWidget({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF111827).withAlpha(10),
            blurRadius: 20.0,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: NetworkImage(user.image),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 4.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              '${user.firstName} ${user.lastName}',
                              style: const TextStyle(
                                color: Color(0xFF111827),
                                fontWeight: FontWeight.w800,
                                fontSize: 16.0,
                                letterSpacing: -0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          StatusBadgeWidget(role: user.role),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '${user.company.title} • ${user.company.department}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.alternate_email_rounded,
                            size: 14.0,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 4.0),
                          Flexible(
                            child: Text(
                              user.email.toLowerCase(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFFE5E7EB),
                  size: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatusBadgeWidget extends StatelessWidget {
  const StatusBadgeWidget({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    final isAdmin = role.toLowerCase() == 'admin';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isAdmin ? const Color(0xFFEEF2FF) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: isAdmin ? const Color(0xFFC7D2FE) : const Color(0xFFE5E7EB),
          width: 1.0,
        ),
      ),
      child: Text(
        role.toLowerCase(),
        style: TextStyle(
          color: isAdmin ? const Color(0xFF4338CA) : const Color(0xFF6B7280),
          fontSize: 10.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AppBarActionWidget extends StatelessWidget {
  const AppBarActionWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = const Color(0xFF111827),
    this.backgroundColor = const Color(0xFFF3F4F6),
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      width: 44.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20.0),
        splashRadius: 24.0,
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 48.0,
              color: Color(0xFFD1D5DB),
            ),
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Ops! Algo deu errado',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Não foi possível conectar ao servidor.',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 15.0),
          ),
          const SizedBox(height: 32.0),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 20.0),
            label: const Text('Tentar novamente'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111827),
              foregroundColor: Colors.white,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 14.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
