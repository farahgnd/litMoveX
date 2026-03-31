import 'package:flutter/material.dart';
import 'main.dart';
import 'add_patient.dart';

class PatientPositionsScreen extends StatefulWidget {
  final String patientName;

  const PatientPositionsScreen({super.key, required this.patientName});

  @override
  State<PatientPositionsScreen> createState() => _PatientPositionsScreenState();
}

class _PatientPositionsScreenState extends State<PatientPositionsScreen> {
  final GlobalKey _settingsIconKey = GlobalKey();
  final List<String> _selectedPositions = [];

  final List<Map<String, dynamic>> _positions = [
    {'id': 'allonge', 'label': 'Allongé', 'icon': Icons.arrow_downward},
    {'id': 'releve_dos', 'label': 'Relevé dos', 'icon': Icons.arrow_upward},
    {
      'id': 'trendelenburg',
      'label': 'Trendelenburg',
      'icon': Icons.vertical_align_bottom
    },
    {'id': 'laterale_gauche', 'label': 'Latérale gauche', 'icon': Icons.replay},
    {
      'id': 'laterale_droite',
      'label': 'Latérale droite',
      'icon': Icons.refresh
    },
    {
      'id': 'releve_jambes',
      'label': 'Relevé jambes',
      'icon': Icons.accessibility_new
    },
  ];

  // ✅ BLOC PARAMÈTRES COPIÉ À L'IDENTIQUE
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
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 35,
              height: 35,
              errorBuilder: (c, e, s) =>
                  const Icon(Icons.local_hospital, color: Color(0xFF2E5B9A)),
            ),
            const SizedBox(width: 10),
            const Text(
              'Lit MoveX',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // ✅ BOUTON PARAMÈTRES COPIÉ À L'IDENTIQUE
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepIndicator(1, 'Infos', active: false, completed: true),
                Container(width: 30, height: 1, color: const Color(0xFF2ECC71)),
                _buildStepIndicator(2, 'Positions',
                    active: true, completed: false),
              ],
            ),
            const SizedBox(height: 30),
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
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.accessibility_new, color: Color(0xFF2ECC71)),
                        SizedBox(width: 10),
                        Text('Positions adaptées au patient',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF455A64))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                        'Sélectionnez les positions appropriées à l\'état de ${widget.patientName}.',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 25),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: _positions.length,
                      itemBuilder: (context, index) {
                        final pos = _positions[index];
                        final bool isSelected =
                            _selectedPositions.contains(pos['id']);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? _selectedPositions.remove(pos['id'])
                                  : _selectedPositions.add(pos['id']);
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFFF1F4F8),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF2ECC71)
                                      : Colors.transparent,
                                  width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(pos['icon'],
                                    color: isSelected
                                        ? const Color(0xFF2ECC71)
                                        : const Color(0xFF455A64)),
                                const SizedBox(height: 8),
                                Text(pos['label'],
                                    style: TextStyle(
                                        color: isSelected
                                            ? const Color(0xFF2ECC71)
                                            : const Color(0xFF455A64),
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                                if (isSelected)
                                  const Icon(Icons.check_circle,
                                      size: 14, color: Color(0xFF2ECC71)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, size: 18),
                            label: const Text('Retour'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                _selectedPositions.isEmpty ? null : () {},
                            icon: const Text('Suivant',
                                style: TextStyle(color: Colors.white)),
                            label: const Icon(Icons.arrow_forward,
                                color: Colors.white, size: 18),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2ECC71),
                              disabledBackgroundColor:
                                  const Color(0xFF2ECC71).withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int number, String label,
      {required bool active, required bool completed}) {
    Color color =
        active || completed ? const Color(0xFF2ECC71) : Colors.grey[300]!;
    return Row(children: [
      CircleAvatar(
          radius: 12,
          backgroundColor: color,
          child: Text('$number',
              style: const TextStyle(fontSize: 12, color: Colors.white))),
      const SizedBox(width: 8),
      Text(label,
          style: TextStyle(
              color: color,
              fontWeight: active ? FontWeight.bold : FontWeight.normal)),
    ]);
  }
}
