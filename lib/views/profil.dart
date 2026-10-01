import 'package:flutter/material.dart';
import 'package:kuis_mobile/models/data.dart';
import 'package:kuis_mobile/root.dart';
import 'package:kuis_mobile/views/login.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String displayName;
  final VoidCallback? onWishlistTap;

  const ProfilePage({
    super.key,
    required this.username,
    required this.displayName,
    this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "PROFIL",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            fontSize: 16,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
        
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              color: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.only(
                  top: 30, bottom: 40, left: 24, right: 24),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5), width: 2),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "@$username",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Profile Info Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "INFORMASI AKUN",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _InfoRow(
                    icon: Icons.person_outline,
                    label: "Nama",
                    value: displayName,
                  ),
                  const Divider(height: 24),
                  _InfoRow(
                    icon: Icons.alternate_email,
                    label: "Username",
                    value: username,
                  ),
                  const Divider(height: 24),
                  _InfoRow(
                    icon: Icons.verified_user_outlined,
                    label: "Status",
                    value: "Terverifikasi ✓",
                    valueColor: Colors.green,
                  ),
                ],
              ),
            ),

            // Menu Options
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  _MenuTile(
                    icon: Icons.shopping_bag_outlined,
                    label: "Pesanan Saya",
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _MenuTile(
                    icon: Icons.favorite_outline,
                    label: "Wishlist",
                    badge: wishlistProductIds.isNotEmpty
                        ? "${wishlistProductIds.length}"
                        : null,
                    onTap: () {
                      if (onWishlistTap != null) {
                        onWishlistTap!();
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Root(
                              username: username,
                              displayName: displayName,
                              initialCategory: "Wishlist",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  _MenuTile(
                    icon: Icons.notifications_outlined,
                    label: "Notifikasi",
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _MenuTile(
                    icon: Icons.settings_outlined,
                    label: "Pengaturan",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "KELUAR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1A1A1A), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFF1A1A1A), size: 22),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A1A1A),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
