import 'dart:io';

import 'package:avatar_ai/core/utils/utils.dart';
import 'package:avatar_ai/features/myavatar/viewmodel/avatar_viewmodel.dart';
import 'package:avatar_ai/features/myavatar/model/character_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateCharacterForm extends ConsumerStatefulWidget {
  const CreateCharacterForm({super.key, this.character});
  final Character? character;
  @override
  ConsumerState<CreateCharacterForm> createState() =>
      _CreateCharacterFormState();
}

class _CreateCharacterFormState extends ConsumerState<CreateCharacterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _taglineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
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
  bool get isEdit => widget.character != null;

  @override
  void initState() {
    if (isEdit) {
      _nameController.text = widget.character!.name;
      _taglineController.text = widget.character!.tagline;
      _descriptionController.text = widget.character!.description ?? '';
      _tagsController.text = widget.character!.tags.join(', ');
      _selectedTone = widget.character!.tone;
      _aiGreeting = widget.character!.aiGreetingEnabled;
      _greetingControllers.clear();
      for (var greeting in widget.character!.greetings) {
        _greetingControllers.add(TextEditingController(text: greeting));
      }
    }
    super.initState();
  }

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

  void _updateCharacter() {
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter a character name');
      return;
    }
    final Character updatedCharacter = widget.character!.copyWith(
      name: _nameController.text.trim(),
      tagline: _taglineController.text.trim(),
      description: _descriptionController.text.trim(),
      tone: _selectedTone,
      tags: _tagsController.text.trim().isNotEmpty
          ? _tagsController.text.trim().split(',').map((e) => e.trim()).toList()
          : [],
      greetings: _greetingControllers
          .map((controller) => controller.text.trim())
          .where((greeting) => greeting.isNotEmpty)
          .toList(),
      aiGreetingEnabled: _aiGreeting,
    );
    ref
        .read(avatarViewmodelProvider.notifier)
        .updateCharacter(character: updatedCharacter, avatarFile: _pickedImage);
  }

  void _createCharacter() {
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter a character name');
      return;
    }

    final Character characterData = Character(
      id: '', // handling on repo layer
      createdBy: '', // handling on repo layer
      name: _nameController.text.trim(),
      tagline: _taglineController.text.trim(),
      description: _descriptionController.text.trim(),
      avatar: '', // handling on repo layer
      avatarColor: ColorGenerator.generateRandomColor(),
      chats: 0,
      createdAt: DateTime.now(),
      tone: _selectedTone,
      tags: _tagsController.text.trim().isNotEmpty
          ? _tagsController.text.trim().split(',').map((e) => e.trim()).toList()
          : [],
      greetings: _greetingControllers
          .map((controller) => controller.text.trim())
          .where((greeting) => greeting.isNotEmpty)
          .toList(),
      aiGreetingEnabled: _aiGreeting,
    );

    ref
        .read(avatarViewmodelProvider.notifier)
        .createAvatar(character: characterData, avatarFile: _pickedImage);
  }

  void _showErrorSnackbar(String message) {
    showSnackBar(
      message: message,
      context: context,
      type: SnackBarType.failure,
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarStateAsync = ref.watch(avatarViewmodelProvider);

    return avatarStateAsync.when(
      data: (avatarState) {
        final bool isCreating = avatarState.isLoading;
        final bool isCreated = avatarState.isCharacterCreated;
        final String? errorMessage = avatarState.errorMessage;

        if (isCreated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(
              message: isEdit
                  ? 'Character updated successfully'
                  : 'Character created successfully',
              context: context,
              type: SnackBarType.success,
            );
            context.pop();
          });
        }

        // Handle error state
        if (errorMessage != null && errorMessage.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorSnackbar(errorMessage);
          });
        }

        return _buildForm(isCreating);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildForm(bool isCreating) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            isCreating ? null : Navigator.of(context).pop();
          },
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
                  onTap: isCreating
                      ? null
                      : () async {
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
                                : (isEdit &&
                                      widget.character!.avatar.isNotEmpty)
                                ? Image.network(
                                    widget.character!.avatar,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.white70,
                                            ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white70,
                                  ),
                          ),
                        ),
                        if (!isCreating)
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
                  enabled: !isCreating,
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
                  enabled: !isCreating,
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
                  enabled: !isCreating,
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
                      enabled: !isCreating,
                    ),
                  );
                }),

                if (_greetingControllers.length < 5 && !isCreating)
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
                    onChanged: isCreating
                        ? null
                        : (value) {
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

                // Tone
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
                      onChanged: isCreating
                          ? null
                          : (value) {
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
                  enabled: !isCreating,
                ),
                const SizedBox(height: 40),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isCreating
                        ? null
                        : isEdit
                        ? _updateCharacter
                        : _createCharacter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCreating
                          ? Colors.grey
                          : const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isCreating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            isEdit ? 'Update Character' : 'Create Character',
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
}

Widget _buildInputField({
  required TextEditingController controller,
  required String hint,
  int? maxLength,
  int maxLines = 1,
  bool enabled = true,
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
      enabled: enabled,
      style: TextStyle(
        color: enabled ? Colors.white : Colors.grey,
        fontSize: 14,
      ),
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
