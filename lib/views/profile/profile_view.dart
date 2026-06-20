import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../orders/orders_history_view.dart';
import '../profile/wishlist_view.dart';
import '../profile/manage_products_view.dart';
import 'add_product_view.dart';
import '../../utils/auth_utils.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  String getUsernameFromEmail(String email) {
    return email.split('@').first;
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    // ❌ NO NAVIGATION
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 30),

          CircleAvatar(radius: 40, child: const Icon(Icons.person, size: 40)),
          const SizedBox(height: 10),

          Text(
            user != null ? getUsernameFromEmail(user.email!) : "Guest",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          Text(user?.email ?? "", style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 30),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _item(context, Icons.shopping_bag, "My Orders",
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrdersHistoryView(),
                          ),
                        )),
                _item(context, Icons.favorite, "Favorites",
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => WishlistView()),
                        )),
                if (isAdmin())
                  _item(context, Icons.add, "Add Product",
                      () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddProductView(),
                            ),
                          )),
                if (isAdmin())
                  _item(context, Icons.edit, "Manage Products",
                      () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ManageProductsView(),
                            ),
                          )),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text("Log out",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
