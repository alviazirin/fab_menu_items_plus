library fab_menu_items_plus;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class Fabmenuitems extends StatefulWidget {
  final double height, weith;
  final Color fabcolor, containercolor;
  final AnimatedIconData animatedIcons;
  List<Widget> childrens = const <Widget>[];

  Fabmenuitems({
    this.height = 310,
    this.weith = 150.0,
    required this.childrens,
    required this.fabcolor,
    this.animatedIcons = AnimatedIcons.menu_close,
    this.containercolor = Colors.white,
  });

  @override
  _FabmenuitemsState createState() => _FabmenuitemsState(
      height: height,
      childrens: childrens,
      weith: weith,
      fabcolor: fabcolor,
      animatedIcons: animatedIcons,
      containercolor: containercolor);
  // _FabmenuitemsState createState() => _FabmenuitemsState();
}

class _FabmenuitemsState extends State<Fabmenuitems>
    with SingleTickerProviderStateMixin {
  final double height, weith;
  List<Widget> childrens = const <Widget>[];
  final Color fabcolor, containercolor;
  final AnimatedIconData animatedIcons;

  _FabmenuitemsState({
    this.height = 310,
    this.weith = 150.0,
    required this.childrens,
    required this.fabcolor,
    this.animatedIcons = AnimatedIcons.menu_close,
    this.containercolor = Colors.white,
  });

  late AnimationController controller;
  late SequenceAnimation sequenceAnimation;

  bool fabclose = false;
  late Animation<double> _animateIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    controller = new AnimationController(vsync: this);

    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    sequenceAnimation = new SequenceAnimationBuilder()
        .addAnimatable(
            animatable: new Tween<double>(begin: 0.0, end: 1.0),
            from: Duration.zero,
            to: const Duration(milliseconds: 200),
            curve: Curves.ease,
            tag: "opacity")
        .addAnimatable(
            animatable: new Tween<double>(begin: 0.0, end: 1.0),
            from: const Duration(milliseconds: 300),
            to: const Duration(milliseconds: 500),
            curve: Curves.ease,
            tag: "opacityitem")
        .addAnimatable(
            animatable: new Tween<double>(begin: 50.0, end: weith),
            from: const Duration(milliseconds: 250),
            to: const Duration(milliseconds: 500),
            curve: Curves.ease,
            tag: "width")
        .addAnimatable(
            animatable: new Tween<double>(begin: 0.0, end: height),
            from: const Duration(milliseconds: 250),
            to: const Duration(milliseconds: 500),
            curve: Curves.ease,
            tag: "ht")
        .animate(controller);
  }

  Future<Null> _playAnimation() async {
    try {
      if (fabclose == true) {
        await controller.reverse().orCancel;
        setState(() {
          fabclose = false;
        });
      } else {
        await controller.forward().orCancel;
        setState(() {
          fabclose = true;
        });
      }
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(right: 27),
      child: Opacity(
        opacity: sequenceAnimation["opacity"].value,
        child: Container(
          width: sequenceAnimation["width"].value,
          height: sequenceAnimation["ht"].value,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5.0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: containercolor),
              height: MediaQuery.of(context).size.height - 500,
              width: MediaQuery.of(context).size.width - 200,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Opacity(
                  opacity: sequenceAnimation["opacityitem"].value,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: childrens,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        right: 10,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              AnimatedBuilder(animation: controller, builder: _buildAnimation),
              const SizedBox(
                height: 5,
              ),
              FloatingActionButton(
                backgroundColor: fabcolor,
                heroTag: 'Asif',
                onPressed: () {
                  _playAnimation();
                },
                child: AnimatedIcon(
                  icon: animatedIcons,
                  progress: _animateIcon,
                ),
              ),
            ],
          ),
        ));
  }
}
