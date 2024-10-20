import 'package:flutter/material.dart';

class TestClass {
  String id;
  bool checked;
  String label;
  List<TestClass>? items;

  TestClass({
    required this.id,
    this.checked = false,
    required this.label,
    this.items,
  });
}

List<TestClass> classList = [
  TestClass(id: '1', label: '文科', items: [
    TestClass(
      id: '1-1',
      label: '文科1',
      items: [
        TestClass(
          id: '1-1-1',
          label: '文科1-1',
        ),
        TestClass(
          id: '1-1-2',
          label: '文科1-2',
        ),
      ],
    ),
    TestClass(
      id: '1-2',
      label: '文科2',
    ),
    TestClass(
      id: '1-3',
      label: '文科3',
    ),
  ]),
  TestClass(
    id: '1-1-1',
    label: '文科1-1',
  ),
  TestClass(
    id: '1-1-2',
    label: '文科1-2',
  ),
];

class SimpleTreeTest extends StatefulWidget {
  const SimpleTreeTest({super.key});

  @override
  State<StatefulWidget> createState() => SimpleTreeTestState();
}

class SimpleTreeTestState extends State<SimpleTreeTest> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          children: classList
              .map(
                (e) => SimpleTree(
                  label: e.label,
                  checked: e.checked,
                  items: e.items
                      ?.map(
                          (e) => SimpleTree(label: e.label, checked: e.checked))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      //   找到当前id更改checked
                      if (e.items != null) {
                        for (var item in e.items!) {
                          item.checked = v ?? false;
                        }
                      }
                    });
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class SimpleTree extends StatefulWidget {
  const SimpleTree({
    super.key,
    required this.label,
    this.items,
    required this.checked,
    this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool?>? onChanged;
  final List<Widget>? items;

  @override
  State<SimpleTree> createState() => _SimpleTreeState();
}

class _SimpleTreeState extends State<SimpleTree> {
  bool isExpanded = false;

  void toggleExpanded(bool value) async {
    setState(() {
      isExpanded = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items == null) {
      return TreeItem(
        checked: widget.checked,
        label: widget.label,
        isExpanded: isExpanded,
        onChanged: widget.onChanged,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TreeItem(
          checked: widget.checked,
          label: widget.label,
          isExpanded: isExpanded,
          onChanged: widget.onChanged,
          hasItems: true,
          onPressed: toggleExpanded,
        ),
        // AnimatedCrossFade(
        //   firstChild: const SizedBox(width: double.maxFinite),
        //   secondChild: Padding(
        //     padding: const EdgeInsets.only(left: 24),
        //     child: Column(children: widget.items!),
        //   ),
        //   crossFadeState: CrossFadeState.showSecond,
        //   duration: const Duration(milliseconds: 200),
        // ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300), // 动画持续时间
          curve: Curves.easeInOut, // 动画曲线
          height: isExpanded ? widget.items!.length * 32 : 0, // 根据状态改变高度
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Opacity(
              opacity: isExpanded ? 1 : 0, // 根据状态改变透明度
              child: Column(children: widget.items!),
            ),
          ),
        ),
        // Offstage(
        //   offstage: !isExpanded,
        //   child: AnimatedOpacity(
        //     opacity: isExpanded ? 1 : 0,
        //     duration: const Duration(milliseconds: 500),
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 24),
        //       child: Column(children: widget.items!),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class TreeItem extends StatelessWidget {
  const TreeItem({
    super.key,
    required this.label,
    this.checked = false,
    required this.onChanged,
    this.hasItems = false,
    required this.isExpanded,
    this.onPressed,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool?>? onChanged;
  final bool isExpanded;
  final bool hasItems;
  final void Function(bool)? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Checkbox(value: true, onChanged: onChanged),
          Text(label),
          const Spacer(),
          if (hasItems)
            ExpandIcon(
              size: 20,
              isExpanded: isExpanded,
              onPressed: onPressed,
            ),
        ],
      ),
    );
  }
}
