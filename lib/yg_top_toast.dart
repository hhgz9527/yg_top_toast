library yg_top_toast;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YGTopToast {
  final String? title;
  final String? subtitle;

  YGTopToast({this.title, this.subtitle});

  show(context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return YGTopToastView(title: title, subtitle: subtitle);
        },
        opaque: false,
      ),
    );
  }
}

class YGTopToastView extends StatefulWidget {
  final String? title;
  final String? subtitle;

  const YGTopToastView({Key? key, this.title, this.subtitle}) : super(key: key);

  @override
  State<YGTopToastView> createState() => _YGTopToastViewState();
}

class _YGTopToastViewState extends State<YGTopToastView> with SingleTickerProviderStateMixin {
  double _animationHeight = -100;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3), () {
      setState(() {
        _animationHeight = 0;
      });
    });
    Future.delayed(const Duration(milliseconds: 2300), () {
      _dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedPositioned(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(milliseconds: 500),
            top: _animationHeight,
            left: 0,
            right: 0,
            child: _buildContentView(context),
          ),
        ],
      ),
    );
  }

  _buildContentView(BuildContext context) {
    final container = Container(
      height: MediaQuery.of(context).size.height >= 812 ? 100 : 80,
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.bottomLeft,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFFFFBA59),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), offset: const Offset(0.0, 1.0), blurRadius: 4),
        ],
      ),
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        children: [
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded, size: 20, color: Colors.black),
              Container(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null)
                    Text(
                      widget.title ?? '',
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle ?? '',
                      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300),
                    )
                ],
              ),
            ],
          ),
          Container(height: 15),
        ],
      ),
    );
    return InkWell(
      onTap: () {
        _dismiss();
      },
      child: container,
    );
  }

  _dismiss() {
    if (mounted) {
      setState(() {
        _animationHeight = -(MediaQuery.of(context).size.height >= 812 ? 100 : 80).toDouble();
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context);
      });
    }
  }
}
