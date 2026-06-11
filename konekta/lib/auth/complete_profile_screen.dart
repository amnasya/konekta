import 'package:flutter/material.dart';
import '../core/widgets.dart';
import '../main_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String role;
  const CompleteProfileScreen({super.key, required this.role});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String selectedIndustry = '';
  final TextEditingController _othersController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _loading = false;

  // List industri sesuai gambar
  final List<String> industries = ['Fashion', 'Beauty', 'F&B', 'Tech', 'Others'];

  @override
  void dispose() {
    _othersController.dispose();
    _usernameController.dispose();
    _tiktokController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _continue() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil tinggi layar untuk memastikan background gradient penuh
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Gradient biru sesuai dengan gambar background atas
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3EA3EC),
              Color(0xFF2676D0),
            ],
            stops: [0.0, 0.4], // Menjaga agar gradient dominan di area atas
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: statusBarHeight + 40),
            // Header Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Complete your creator\nprofile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Brands match faster with a complete profile.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Main Content Card (White Container)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Profile Avatar Selection
                      Center(
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              radius: 45,
                              backgroundColor: Color(0xFF3B9EE9),
                              child: Text(
                                'A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2676D0),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            // Label ukuran file di sebelah kanan avatar
                            Positioned(
                              left: 105,
                              top: 35,
                              child: SizedBox(
                                width: 150,
                                child: const Text(
                                  'PNG or JPG, max 2MB',
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Input Fields
                      _buildInputLabel('Create username'),
                      _buildTextField(
                        controller: _usernameController,
                        hintText: 'username',
                      ),

                      const SizedBox(height: 16),
                      _buildInputLabel('Tiktok account'),
                      _buildTextField(
                        controller: _tiktokController,
                        hintText: 'Input Tiktok Account',
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInputLabel('Short description'),
                          Text(
                            '${_descriptionController.text.length}/150',
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      _buildTextField(
                        controller: _descriptionController,
                        hintText: 'Short description about your socials',
                        maxLines: 4,
                        onChanged: (_) => setState(() {}),
                        maxLength: 150,
                      ),

                      const SizedBox(height: 16),
                      _buildInputLabel('Industry'),
                      const SizedBox(height: 8),

                      // Industry Chips Layout
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: industries.map((industry) {
                          final isSelected = selectedIndustry == industry;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndustry = industry;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3EA3EC)
                                    : const Color(0xFFE8F1F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                industry,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF7CA1C1),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Kondisional jika memilih 'Others' maka muncul text field underline bawah
                      if (selectedIndustry == 'Others') ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: _othersController,
                          decoration: const InputDecoration(
                            hintText: 'Type here if you choose others',
                            hintStyle: TextStyle(
                                color: Colors.black38, fontSize: 13),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFF3EA3EC)),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),

                      // Continue Button
                      GradientButton(
                        label: 'Continue',
                        onPressed: _loading ? null : _continue,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat Label teks input
  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper widget untuk membuat Text Field abu-abu soft sesuai UI
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    int? maxLength,
    void Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBF2F8),
        borderRadius: BorderRadius.circular(maxLines > 1 ? 16 : 24),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF9CB1C9),
            fontSize: 15,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
