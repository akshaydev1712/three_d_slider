import 'package:flutter/material.dart';

/// Widget to render a list of cards in 3D with the card
/// at position [selectedIndex] highlighted. The [cards] parameter is a list
/// of card widgets to be displayed. This widget creates a visually
/// appealing 3D effect, allowing users to interact with the selected card,
/// while the other cards appear in the background.
class ThreeDSlider extends StatefulWidget {
  /// Creates a list of cards arranged in a 3D layout.
  const ThreeDSlider({
    super.key,
    required this.cards,
    required this.frameHeight,
    required this.frameWidth,
    this.centerFrameOpacity = 1.0,
    this.sideFrameOpacity = 0.7,
    this.sideFrameVisibility = 0.4,
    this.selectedIndex,
    this.navigationButtonGap,
    this.frameDecoration,
    this.prevButtonIcon,
    this.nextButtonIcon,
  })  : assert(
          centerFrameOpacity >= 0.0 && centerFrameOpacity <= 1.0,
          'centerFrameOpacity must be between 0.0 and 1.0 inclusive',
        ),
        assert(
          sideFrameOpacity >= 0.0 && sideFrameOpacity <= 1.0,
          'sideFrameOpacity must be between 0.0 and 1.0 inclusive',
        ),
        assert(
          sideFrameVisibility > 0.0 && sideFrameVisibility < 1.0,
          'sideFrameVisibility must be between 0.0 (exclusive) and 1.0 (exclusive)',
        ),
        assert(
          selectedIndex == null ||
              (selectedIndex >= 0 && selectedIndex < cards.length),
          'Index out of range: selectedIndex must be between 0 and ${cards.length - 1} inclusive',
        );

  /// A list of cards to be displayed in a 3D slider.
  ///
  /// This must contain elements of type `Widget`.
  final List<Widget> cards;

  /// The height used to define the size of the center frame.
  ///
  /// This value is also applied to determine the height of the side frame.
  final double frameHeight;

  /// The width that defines the size of the center frame.
  ///
  /// This value also determines the width of the side frame and the overall
  /// slider width, allowing the left and right cards to render as a stacked
  /// background.
  final double frameWidth;

  /// The fraction used to scale the opacity of the center card.
  ///
  /// A value of 1.0 makes the card fully opaque, while a value of 0.0 makes it
  /// fully transparent.
  ///
  /// Defaults to 1.0.
  final double centerFrameOpacity;

  /// The fraction used to scale the opacity of the side cards.
  ///
  /// A value of 1.0 renders the side cards fully opaque, while a value of 0.0
  /// makes them fully transparent.
  ///
  /// Defaults to 0.7
  final double sideFrameOpacity;

  /// A fractional value used to determine the visible percentage of the side
  /// cards.
  ///
  /// For example, a value of 0.1 makes 10% of each side card visible.
  ///
  /// Defaults to 0.4, displaying 40% of the side cards.
  final double sideFrameVisibility;

  /// The index value used to determine which card is rendered at the center.
  ///
  /// If not specified, the value is calculated by taking the total number of
  /// cards in the widget.cards list, subtracting one, and then dividing the
  /// result by two using integer division (ignoring any remainder).
  final int? selectedIndex;

  /// Specifies the gap between the slider and the navigation buttons.
  ///
  /// This value equally adds spacing between the slider and both the left and
  /// right navigation buttons.
  final double? navigationButtonGap;

  /// Specifies the decoration for all the cards in the 3D slider.
  final BoxDecoration? frameDecoration;

  /// Specifies the icon for the button used to navigate to the previous card
  /// in the 3D slider.
  final Widget? prevButtonIcon;

  /// Specifies the icon for the button used to navigate to the next card in the
  /// 3D slider.
  final Widget? nextButtonIcon;

  @override
  State<ThreeDSlider> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<ThreeDSlider> {
  late int _selectedIndex;
  late List<Widget> _leftCards;
  late List<Widget> _rightCards;
  late Widget _centerCard;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex ?? (widget.cards.length - 1) ~/ 2;
    _arrangeCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _navigationButton(isNext: false),
        _slider(),
        _navigationButton(isNext: true),
      ],
    );
  }

  Widget _slider() {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: widget.navigationButtonGap ?? 16.0),
      width:
          widget.frameWidth + (widget.frameWidth * widget.sideFrameVisibility),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _cardStack(isLeftStack: true),
          _cardStack(isLeftStack: false),
          _cardFrame(_centerCard, centerFrame: true),
        ],
      ),
    );
  }

  Widget _cardStack({required isLeftStack}) {
    return Positioned.fill(
      child: Align(
        alignment: isLeftStack ? Alignment.centerLeft : Alignment.centerRight,
        child: Stack(
          children: isLeftStack
              ? _leftCards.map((card) => _cardFrame(card)).toList()
              : _rightCards.map((card) => _cardFrame(card)).toList(),
        ),
      ),
    );
  }

  Widget _cardFrame(Widget card, {bool centerFrame = false}) {
    return Opacity(
      opacity:
          centerFrame ? widget.centerFrameOpacity : widget.sideFrameOpacity,
      child: Container(
        decoration: widget.frameDecoration,
        height: centerFrame ? widget.frameHeight : (widget.frameHeight - 72.0),
        width: centerFrame ? widget.frameWidth : (widget.frameWidth - 72.0),
        child: card,
      ),
    );
  }

  Widget _navigationButton({required bool isNext}) {
    return IconButton(
      onPressed: () {
        setState(() {
          if (isNext) {
            _selectedIndex = (_selectedIndex < widget.cards.length - 1)
                ? _selectedIndex + 1
                : _selectedIndex;
          } else {
            _selectedIndex =
                (_selectedIndex > 0) ? _selectedIndex - 1 : _selectedIndex;
          }
          _leftCards.clear();
          _rightCards.clear();
          _arrangeCards();
        });
      },
      icon: isNext
          ? widget.nextButtonIcon ?? const Icon(Icons.arrow_forward)
          : widget.prevButtonIcon ?? const Icon(Icons.arrow_back),
    );
  }

  void _arrangeCards() {
    _leftCards = widget.cards.sublist(0, _selectedIndex);
    _rightCards = widget.cards.sublist(_selectedIndex + 1).reversed.toList();
    _centerCard = widget.cards[_selectedIndex];
  }
}
