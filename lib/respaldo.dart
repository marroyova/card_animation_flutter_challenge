import 'package:card_animation/hover_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardAnimation extends ConsumerStatefulWidget {
  const CardAnimation({super.key});

  @override
  CardAnimationState createState() => CardAnimationState();
}

class CardAnimationState extends ConsumerState<CardAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> upContainer;
  late Animation<double> downContainer;
  late Animation<double> showData;
  late Animation<double> hideData;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    );

    upContainer = Tween<double>(begin: 45.0, end: 0.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    downContainer = Tween<double>(begin: 0.0, end: 45.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    showData = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    hideData = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(1.0, 0.5, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isHover = ref.watch(isHoverProvider);

    void toggleContainers() {
      bool bandera = false;
      ref.read(isHoverProvider.notifier).update((state) => !isHover);
      bandera = ref.read(isHoverProvider.notifier).state;
      bandera ? controller.forward() : controller.reverse();
    }

    const kMainColor = Color(0xFF064D76);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Animation'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(100.0),
            child: Center(
              child: GestureDetector(
                onTap: () => toggleContainers(),
                child: Column(
                  children: [
                    Expanded(
                      child: MouseRegion(
                        onEnter: (event) => toggleContainers(),
                        onExit: (event) => toggleContainers(),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: isHover
                                  ? downContainer.value
                                  : downContainer.value,
                              child: Container(
                                width: 200,
                                height: isHover ? 360 : 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: kMainColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: isHover
                                  ? upContainer.value
                                  : upContainer.value,
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: kMainColor,
                                      border: Border.all(
                                        color: kMainColor,
                                        width: 1.0,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow_outlined,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  const Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      'Derecho de Familia',
                                      style: TextStyle(
                                        color: kMainColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (isHover) ...[
                                    FadeTransition(
                                      opacity: isHover ? showData : hideData,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 25.0),
                                          const SizedBox(
                                            width: 200.0,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              child: Text(
                                                'Enim ex duis sit proident consectetur duis incididunt laboris officia ea do commodo. Quis in exercitation eu ea ea nostrud cupidatat consectetur. Deserunt cillum aute laborum dolor.',
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                          //const SizedBox(height: 25.0),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25.0,
                                                vertical: 25.0),
                                            child: TextButton(
                                              onPressed: null,
                                              style: TextButton.styleFrom(
                                                backgroundColor: kMainColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10.0,
                                                  ), // Ajusta el valor para cambiar la curvatura de los bordes
                                                ),
                                              ),
                                              child: const Text(
                                                'Cerrar',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
