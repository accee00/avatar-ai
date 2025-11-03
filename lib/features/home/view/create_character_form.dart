import 'dart:io';

import 'package:avatar_ai/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateCharacterForm extends StatefulWidget {
  const CreateCharacterForm({super.key});

  @override
  State<CreateCharacterForm> createState() => _CreateCharacterFormState();
}

class _CreateCharacterFormState extends State<CreateCharacterForm> {
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final List<String> _tones = [
    'Friendly',
    'Serious',
    'Funny',
    'Excited',
    'Calm',
  ];
  bool _aiGreeting = false;
  final List<TextEditingController> _greetingControllers = [
    TextEditingController(),
  ];
  String? _selectedTone;
  File? _pickedImage;
  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    for (var controller in _greetingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('Create Character'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Section
                GestureDetector(
                  onTap: () async {
                    File? file = await AppImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file != null) {
                      setState(() {
                        _pickedImage = file;
                      });
                    }
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFD2691E),
                                const Color(0xFF8B4513),
                              ],
                            ),
                          ),
                          child: ClipOval(
                            child: _pickedImage != null
                                ? Image.file(_pickedImage!, fit: BoxFit.cover)
                                : null, // or placeholder
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Character Name
                const Text(
                  'Character name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _nameController,
                  hint: 'e.g. Albert Einstein',
                  maxLength: 20,
                ),
                const SizedBox(height: 24),

                // Tagline
                const Text(
                  'Tagline',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _taglineController,
                  hint: 'Add a short tagline of your Character',
                  maxLength: 50,
                ),
                const SizedBox(height: 24),

                // Description
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _descriptionController,
                  hint: 'How would your Character describe themselves?',
                  maxLength: 500,
                  maxLines: 5,
                ),
                const SizedBox(height: 24),

                // Greeting
                const Text(
                  'Greeting',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                ..._greetingControllers.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildInputField(
                      controller: entry.value,
                      hint: index == 0
                          ? 'Your neighbor just knocked. He says his power\'s out... but why won\'t he leave?'
                          : 'Add another greeting...',
                      maxLength: 4096,
                      maxLines: 4,
                    ),
                  );
                }),

                if (_greetingControllers.length < 5)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _greetingControllers.add(TextEditingController());
                      });
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add additional greeting'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[400],
                      padding: EdgeInsets.zero,
                    ),
                  ),

                const SizedBox(height: 8),
                Text(
                  'You can add up to 5 custom greetings. They\'ll appear in the order you set and people swipe to pick one before chatting. Once your list ends, we\'ll suggest ai-generated greetings based on your character.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 16),

                // AI Greeting Checkbox
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: CheckboxListTile(
                    value: _aiGreeting,
                    onChanged: (value) {
                      setState(() {
                        _aiGreeting = value ?? false;
                      });
                    },
                    title: const Text(
                      'AI Greeting for New Chats',
                      style: TextStyle(fontSize: 14),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF6C63FF),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tone',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedTone,
                      hint: Text(
                        'Select a tone',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      dropdownColor: const Color(0xFF1A1A1A),
                      items: _tones.map((tone) {
                        return DropdownMenuItem<String>(
                          value: tone,
                          child: Text(
                            tone,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTone = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tags
                const Text(
                  'Tags',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _tagsController,
                  hint: 'Add tags to help people discover your Character',
                ),
                const SizedBox(height: 40),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Create Character',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    int? maxLength,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          counterStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ),
    );
  }
}
