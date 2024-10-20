import 'package:flutter/material.dart';

class CustomExTDemo extends StatefulWidget {
  const CustomExTDemo({super.key});

  @override
  State<CustomExTDemo> createState() => _CustomExTDemoState();
}

class _CustomExTDemoState extends State<CustomExTDemo> {
  bool _isExpanded = false; // 控制展开状态

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
              color: Colors.blue[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '点击展开/收起',
                  style: TextStyle(fontSize: 18),
                ),
                Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300), // 动画持续时间
          curve: Curves.easeInOut, // 动画曲线
          height: _isExpanded ? 60 * 4 : 0, // 根据状态改变高度
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Opacity(
                    opacity: _isExpanded ? 1 : 0, // 根据状态改变透明度
                    child: Text(
                      '这里是展开的内容！',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Opacity(
                    opacity: _isExpanded ? 1 : 0, // 根据状态改变透明度
                    child: Text(
                      '这里是展开的内容！',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Opacity(
                    opacity: _isExpanded ? 1 : 0, // 根据状态改变透明度
                    child: Text(
                      '这里是展开的内容！',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Opacity(
                    opacity: _isExpanded ? 1 : 0, // 根据状态改变透明度
                    child: Text(
                      '这里是展开的内容！',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomExTDemo2 extends StatefulWidget {
  const CustomExTDemo2({super.key});

  @override
  State<CustomExTDemo2> createState() => _CustomExTDemo2State();
}

class _CustomExTDemo2State extends State<CustomExTDemo2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleExpansion,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
              color: Colors.blue[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '点击展开/收起',
                  style: TextStyle(fontSize: 18),
                ),
                Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Opacity(
                  opacity: _isExpanded ? 1 : 0,
                  child: Text(
                    '这里是展开的内容！',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Opacity(
                  opacity: _isExpanded ? 1 : 0,
                  child: Text(
                    '更多内容...',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Opacity(
                  opacity: _isExpanded ? 1 : 0,
                  child: Text(
                    '这里是展开的内容！',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Opacity(
                  opacity: _isExpanded ? 1 : 0,
                  child: Text(
                    '更多内容...',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
