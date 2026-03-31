import 'package:flutter/material.dart';
import 'main.dart';
import 'add_patient.dart';
import 'patient_positions.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final GlobalKey _settingsIconKey = GlobalKey();

  // ✅ CONTRÔLEURS POUR LA SAISIE RÉELLE
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  // Fonction pour afficher le menu des paramètres (Chat bot / Déconnexion)
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
              Text('Chat bot', style: TextStyle(color: Color(0xFF455A64))),
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
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            // ✅ REMPLACEMENT DE L'ICÔNE PAR TON LOGO IMAGE
            Image.asset(
              'assets/logo.png',
              width: 35,
              height: 35,
              errorBuilder: (context, error, stackTrace) {
                // Si l'image n'est pas trouvée, affiche une icône par défaut
                return const Icon(Icons.local_hospital,
                    color: Color(0xFF2E5B9A));
              },
            ),
            const SizedBox(width: 10),
            const Text(
              'Lit MoveX',
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: _settingsIconKey,
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () => _showSettingsMenu(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Stepper (Indicateur d'étape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepIndicator(1, 'Infos', active: true),
                Container(width: 30, height: 1, color: Colors.grey[300]),
                _buildStepIndicator(2, 'Positions', active: false),
              ],
            ),
            const SizedBox(height: 30),
            // Formulaire dans une carte blanche
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 500),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person_add_outlined,
                            color: Color(0xFF2ECC71)),
                        SizedBox(width: 10),
                        Text(
                          'Informations du patient',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF455A64),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Champs de texte interactifs
                    _buildInputField(
                        icon: Icons.badge_outlined,
                        label: 'Nom complet *',
                        controller: _nameController),
                    const SizedBox(height: 15),
                    _buildInputField(
                        icon: Icons.cake_outlined,
                        label: 'Âge *',
                        controller: _ageController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 15),
                    _buildInputField(
                        icon: Icons.hotel_outlined,
                        label: 'Chambre *',
                        controller: _roomController,
                        keyboardType: TextInputType.number),

                    const SizedBox(height: 30),
                    // Bouton Suivant
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_nameController.text.isEmpty ||
                                _ageController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Veuillez remplir les champs obligatoires")),
                              );
                            } else {
                              // ✅ NAVIGATION VERS L'INTERFACE DES POSITIONS
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientPositionsScreen(
                                    patientName: _nameController.text,
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Text('Suivant',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          label: const Icon(Icons.arrow_forward,
                              color: Colors.white, size: 20),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2ECC71),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Widget pour le Stepper (1 et 2)
  Widget _buildStepIndicator(int number, String label, {required bool active}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? const Color(0xFF2ECC71) : Colors.grey[300],
          ),
          child: Text(
            '$number',
            style: TextStyle(
              color: active ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF2ECC71) : Colors.grey[600],
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // Widget générique pour les champs de saisie (TextField)
  Widget _buildInputField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey, size: 16),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Color(0xFF2C3E50), fontSize: 16),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF2ECC71), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
