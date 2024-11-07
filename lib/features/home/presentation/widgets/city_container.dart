import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';

class CityContainer extends StatefulWidget {
  const CityContainer({super.key, this.city, this.deleteCity});

  final CityModel? city;
  final VoidCallback? deleteCity;

  @override
  _CityContainerState createState() => _CityContainerState();
}

class _CityContainerState extends State<CityContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();

    // Configura o AnimationController para o tremor
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Animação de tremor, que oscila o item para os lados
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticIn,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Após a animação de tremor, aplica o efeito de blur e some o item
        setState(() {
          _isDeleting = true;
        });
        Future.delayed(const Duration(milliseconds: 400), () {
          widget.deleteCity?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startDeleteAnimation() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isDeleting ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 500),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double offset = _shakeAnimation.value * (_controller.value < 0.5 ? -1 : 1);
          return Transform.translate(
            offset: Offset(offset, 0),
            child: GestureDetector(
              onTap: _startDeleteAnimation,
              child: _isDeleting
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Opacity(
                        opacity: 0.5,
                        child: _buildContainerContent(),
                      ),
                    )
                  : _buildContainerContent(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContainerContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CityContainerInfo(
            city: widget.city,
          ),
          GestureDetector(
            onTap: _startDeleteAnimation,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CityContainerInfo extends StatelessWidget {
  const CityContainerInfo({super.key, this.city});
  final CityModel? city;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${city?.city} - ',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 8),
              Text(
                city?.temperature ?? '',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 4), // Espaço entre o título e a descrição
          Text(
            city?.description ?? '',
            style: TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis, // Corta o texto se for muito longo
            maxLines: 3, // Limita o número de linhas
          ),
        ],
      ),
    );
  }
}
