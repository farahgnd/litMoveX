import 'package:flutter/material.dart';
import 'main.dart';
import 'add_patient.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  // ✅ CLÉ AJOUTÉE POUR LE POSITIONNEMENT DU MENU
  final GlobalKey _settingsIconKey = GlobalKey();

  // ✅ FONCTION DE PARAMÈTRES COPIÉE À L'IDENTIQUE
  void _showSettingsMenu(BuildContext context) {
    final RenderBox renderBox =
        _settingsIconKey.currentContext?.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx - 180,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy,
      ),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      items: [
        PopupMenuItem<String>(
          value: 'chatbot',
          child: Row(
            children: const [
              Icon(Icons.smart_toy, color: Colors.grey, size: 18),
              SizedBox(width: 10),
              const Text('Chat bot',
                  style: TextStyle(color: Color(0xFF455A64))),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout, color: Color(0xFFE74C3C), size: 18),
              SizedBox(width: 10),
              Text(
                'Déconnexion',
                style: TextStyle(
                    color: Color(0xFFE74C3C), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ).then((selectedValue) {
      if (selectedValue != null) {
        print('Option sélectionnée : $selectedValue');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'Lit MoveX',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: _settingsIconKey, // ✅ CLÉ LIÉE
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () => _showSettingsMenu(context), // ✅ FONCTION LIÉE
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.group_outlined, color: Color(0xFF4CAF50)),
                          SizedBox(width: 8),
                          Text(
                            'Patients du service',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF455A64),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        '2 patient(s)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const PatientTile(name: 'Jean Dupont', age: 72, room: 101),
                  const SizedBox(height: 12),
                  const PatientTile(name: 'Marie Martin', age: 65, room: 102),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                label: 'Ajouter',
                icon: Icons.person_add_alt_1,
                color: const Color(0xFF2ECC71),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPatientScreen()),
                  );
                },
              ),
              const SizedBox(width: 20),
              _buildActionButton(
                label: 'Supprimer',
                icon: Icons.delete_outline,
                color: const Color(0xFFE74C3C),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
    );
  }
}

class PatientTile extends StatelessWidget {
  final String name;
  final int age;
  final int room;

  const PatientTile({
    super.key,
    required this.name,
    required this.age,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(Icons.person_outline, color: Color(0xFF2ECC71)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  '$age ans • Chambre $room',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
