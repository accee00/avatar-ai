import 'package:avatar_ai/models/message_model.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [
    Message(
      text:
          "Your neighbor just knocked. He says his power's out... but why won't he leave?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      id: '',
    ),
    Message(
      id: '',

      text: "Hey, thanks for letting me know. Is everything okay?",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    Message(
      id: '',

      text:
          "Oh yes, everything's fine! Just... the power went out suddenly. Very strange. Mind if I wait here for a bit? It's quite dark outside.",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    Message(
      id: '',

      text: "Sure, no problem. Do you need to call the power company?",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    Message(
      id: '',

      text:
          "That's very kind of you... *shifts uncomfortably* Say, have you noticed anything unusual in the neighborhood lately?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        Message(
          id: '',
          text: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add(
            Message(
              id: '',
              text:
                  "Interesting question... *glances at the window* I think there might be more to this power outage than meets the eye. Have you checked your basement recently?",
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6C63FF),
                    const Color(0xFF6C63FF).withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'NC',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Character',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Input Area
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              child: Row(
                children: [
                  // Attachment Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.grey[400], size: 20),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Text Input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: (value) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Send Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6C63FF),
                          const Color(0xFF00D9FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, size: 20),
                      onPressed: _sendMessage,
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6C63FF),
                    const Color(0xFF6C63FF).withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'NC',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? const Color(0xFF6C63FF)
                        : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 16),
                    ),
                    border: Border.all(
                      color: message.isUser
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF00D9FF),
                    const Color(0xFF00D9FF).withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'D',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6C63FF),
                  const Color(0xFF6C63FF).withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'NC',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final double offset = (value + index * 0.33) % 1.0;
        return Transform.translate(
          offset: Offset(0, -4 * (1 - (offset - 0.5).abs() * 2)),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[500],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted && _isTyping) {
          setState(() {});
        }
      },
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
