import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class EmojiPickerModal extends StatelessWidget {
  final String? selectedEmoji;
  final Function(String) onEmojiSelected;

  const EmojiPickerModal({
    super.key,
    this.selectedEmoji,
    required this.onEmojiSelected,
  });

  static Future<String?> show(
    BuildContext context, {
    String? selectedEmoji,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => EmojiPickerModal(
        selectedEmoji: selectedEmoji,
        onEmojiSelected: (emoji) => Navigator.of(context).pop(emoji),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.box,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.spaceM16),
          topRight: Radius.circular(AppSizes.spaceM16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceS12),
            decoration: BoxDecoration(
              color: AppColors.def.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingM.w),
            child: Text(
              'Choose an emoji',
              style: TextStyle(
                fontSize: AppSizes.textSize20,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: AppSizes.spaceM16.h),
          Flexible(
            child: _EmojiGrid(
              selectedEmoji: selectedEmoji,
              onEmojiSelected: onEmojiSelected,
            ),
          ),
          SizedBox(height: AppSizes.spaceM16.h),
        ],
      ),
    );
  }
}

class _EmojiGrid extends StatelessWidget {
  final String? selectedEmoji;
  final Function(String) onEmojiSelected;

  const _EmojiGrid({
    required this.selectedEmoji,
    required this.onEmojiSelected,
  });

  // PNG emoji file paths organized by category
  static const List<String> _emojiPaths = [
    // Money & Finance
    'assets/emoji/Money Bag.png',
    'assets/emoji/Money With Wings.png',
    'assets/emoji/Dollar Banknote.png',
    'assets/emoji/Euro Banknote.png',
    'assets/emoji/Yen Banknote.png',
    'assets/emoji/Pound Banknote.png',
    'assets/emoji/Credit Card.png',
    'assets/emoji/Coin.png',
    'assets/emoji/Bank.png',
    'assets/emoji/Bar Chart.png',
    'assets/emoji/Chart Increasing.png',
    'assets/emoji/Chart Decreasing.png',
    'assets/emoji/Receipt.png',
    'assets/emoji/Ledger.png',
    'assets/emoji/Clipboard.png',

    // Food & Dining
    'assets/emoji/Fish Cake With Swirl.png',
    'assets/emoji/Teapot.png',

    // Transportation
    'assets/emoji/Automobile.png',
    'assets/emoji/Taxi.png',
    'assets/emoji/Sport Utility Vehicle.png',
    'assets/emoji/Bus.png',
    'assets/emoji/Trolleybus.png',
    'assets/emoji/Racing Car.png',
    'assets/emoji/Police Car.png',
    'assets/emoji/Ambulance.png',
    'assets/emoji/Fire Engine.png',
    'assets/emoji/Delivery Truck.png',
    'assets/emoji/Articulated Lorry.png',
    'assets/emoji/Tractor.png',
    'assets/emoji/Motorcycle.png',
    'assets/emoji/Motor Scooter.png',
    'assets/emoji/Bicycle.png',
    'assets/emoji/Airplane.png',
    'assets/emoji/Small Airplane.png',
    'assets/emoji/Helicopter.png',
    'assets/emoji/Suspension Railway.png',
    'assets/emoji/Mountain Cableway.png',
    'assets/emoji/Aerial Tramway.png',
    'assets/emoji/Satellite.png',
    'assets/emoji/Rocket.png',
    'assets/emoji/Flying Saucer.png',
    'assets/emoji/Bellhop Bell.png',
    'assets/emoji/Luggage.png',
    'assets/emoji/Hourglass Done.png',
    'assets/emoji/Hourglass Not Done.png',
    'assets/emoji/Watch.png',
    'assets/emoji/Alarm Clock.png',
    'assets/emoji/Stopwatch.png',
    'assets/emoji/Timer Clock.png',
    'assets/emoji/Mantelpiece Clock.png',

    // Shopping & Retail
    'assets/emoji/Shopping Bags.png',
    'assets/emoji/Shopping Cart.png',
    'assets/emoji/Convenience Store.png',
    'assets/emoji/Department Store.png',
    'assets/emoji/Post Office.png',
    'assets/emoji/Hospital.png',
    'assets/emoji/Hotel.png',
    'assets/emoji/School.png',
    'assets/emoji/Office Building.png',
    'assets/emoji/Japanese Post Office.png',
    'assets/emoji/Factory.png',
    'assets/emoji/Castle.png',
    'assets/emoji/Japanese Castle.png',
    'assets/emoji/Classical Building.png',
    'assets/emoji/Church.png',
    'assets/emoji/Mosque.png',
    'assets/emoji/Hindu Temple.png',
    'assets/emoji/Synagogue.png',
    'assets/emoji/Shinto Shrine.png',
    'assets/emoji/Kaaba.png',

    // Home & Utilities
    'assets/emoji/House.png',
    'assets/emoji/House With Garden.png',
    'assets/emoji/Houses.png',
    'assets/emoji/Tent.png',
    'assets/emoji/Building Construction.png',
    'assets/emoji/Brick.png',
    'assets/emoji/Wood.png',
    'assets/emoji/Hut.png',
    'assets/emoji/Fountain.png',
    'assets/emoji/Foggy.png',
    'assets/emoji/Night With Stars.png',
    'assets/emoji/Cityscape.png',
    'assets/emoji/Cityscape At Dusk.png',
    'assets/emoji/Sunrise Over Mountains.png',
    'assets/emoji/Sunrise.png',
    'assets/emoji/Sunset.png',
    'assets/emoji/Bridge At Night.png',
    'assets/emoji/Carousel Horse.png',
    'assets/emoji/Roller Coaster.png',
    'assets/emoji/Light Bulb.png',
    'assets/emoji/Electric Plug.png',
    'assets/emoji/Battery.png',
    'assets/emoji/Fire Extinguisher.png',
    'assets/emoji/Wrench.png',
    'assets/emoji/Hammer.png',
    'assets/emoji/Nut And Bolt.png',
    'assets/emoji/Gear.png',
    'assets/emoji/Clamp.png',
    'assets/emoji/Scissors.png',
    'assets/emoji/Key.png',
    'assets/emoji/Old Key.png',
    'assets/emoji/Locked.png',
    'assets/emoji/Unlocked.png',
    'assets/emoji/Locked With Key.png',
    'assets/emoji/Locked With Pen.png',

    // Health & Fitness
    'assets/emoji/Pill.png',
    'assets/emoji/Adhesive Bandage.png',
    'assets/emoji/Stethoscope.png',
    'assets/emoji/Syringe.png',
    'assets/emoji/Drop Of Blood.png',
    'assets/emoji/Test Tube.png',
    'assets/emoji/Petri Dish.png',
    'assets/emoji/Dna.png',
    'assets/emoji/Microscope.png',
    'assets/emoji/Thermometer.png',
    'assets/emoji/Toothbrush.png',
    'assets/emoji/Soap.png',
    'assets/emoji/Sponge.png',
    'assets/emoji/Bucket.png',
    'assets/emoji/Kite.png',
    'assets/emoji/Joystick.png',
    'assets/emoji/Teddy Bear.png',
    'assets/emoji/Pinata.png',
    'assets/emoji/Nesting Dolls.png',

    // Entertainment & Media
    'assets/emoji/Movie Camera.png',
    'assets/emoji/Film Frames.png',
    'assets/emoji/Film Projector.png',
    'assets/emoji/Television.png',
    'assets/emoji/Camera.png',
    'assets/emoji/Camera With Flash.png',
    'assets/emoji/Video Camera.png',
    'assets/emoji/Videocassette.png',
    'assets/emoji/Magnifying Glass Tilted Left.png',
    'assets/emoji/Magnifying Glass Tilted Right.png',
    'assets/emoji/Candle.png',
    'assets/emoji/Red Paper Lantern.png',
    'assets/emoji/Diya Lamp.png',
    'assets/emoji/Notebook With Decorative Cover.png',
    'assets/emoji/Closed Book.png',
    'assets/emoji/Open Book.png',
    'assets/emoji/Green Book.png',
    'assets/emoji/Blue Book.png',
    'assets/emoji/Orange Book.png',
    'assets/emoji/Books.png',
    'assets/emoji/Notebook.png',
    'assets/emoji/Page With Curl.png',
    'assets/emoji/Scroll.png',
    'assets/emoji/Page Facing Up.png',
    'assets/emoji/Newspaper.png',
    'assets/emoji/Rolled Up Newspaper.png',
    'assets/emoji/Bookmark Tabs.png',
    'assets/emoji/Bookmark.png',
    'assets/emoji/Label.png',
    'assets/emoji/Radio.png',
    'assets/emoji/Banjo.png',

    // Education & Work
    'assets/emoji/Graduation Cap.png',
    'assets/emoji/Abacus.png',
    'assets/emoji/Compass.png',
    'assets/emoji/Straight Ruler.png',
    'assets/emoji/Triangular Ruler.png',
    'assets/emoji/Pencil.png',
    'assets/emoji/Black Nib.png',
    'assets/emoji/Fountain Pen.png',
    'assets/emoji/Pen.png',
    'assets/emoji/Paintbrush.png',
    'assets/emoji/Crayon.png',
    'assets/emoji/Memo.png',
    'assets/emoji/File Folder.png',
    'assets/emoji/Open File Folder.png',
    'assets/emoji/Card Index.png',
    'assets/emoji/Card Index Dividers.png',
    'assets/emoji/Card File Box.png',
    'assets/emoji/File Cabinet.png',
    'assets/emoji/Wastebasket.png',
    'assets/emoji/Paperclip.png',
    'assets/emoji/Linked Paperclips.png',
    'assets/emoji/Pushpin.png',
    'assets/emoji/Round Pushpin.png',
    'assets/emoji/Desktop Computer.png',
    'assets/emoji/Laptop.png',
    'assets/emoji/Printer.png',
    'assets/emoji/Keyboard.png',
    'assets/emoji/Computer Mouse.png',
    'assets/emoji/Trackball.png',
    'assets/emoji/Computer Disk.png',
    'assets/emoji/Floppy Disk.png',
    'assets/emoji/Optical Disk.png',
    'assets/emoji/Dvd.png',

    // Sports & Activities
    'assets/emoji/Running Shoe.png',
    'assets/emoji/Hiking Boot.png',
    'assets/emoji/Flat Shoe.png',
    'assets/emoji/High Heeled Shoe.png',
    'assets/emoji/Ballet Shoes.png',
    'assets/emoji/Thong Sandal.png',
    'assets/emoji/Mans Shoe.png',
    'assets/emoji/Womans Boot.png',
    'assets/emoji/Womans Sandal.png',
    'assets/emoji/Crown.png',
    'assets/emoji/Womans Hat.png',
    'assets/emoji/Top Hat.png',
    'assets/emoji/Billed Cap.png',
    'assets/emoji/Military Helmet.png',
    'assets/emoji/Rescue Workers Helmet.png',

    // General & Miscellaneous
    'assets/emoji/Sparkles.png',
    'assets/emoji/Sparkler.png',
    'assets/emoji/Fireworks.png',
    'assets/emoji/Firecracker.png',
    'assets/emoji/Confetti Ball.png',
    'assets/emoji/Party Popper.png',
    'assets/emoji/Balloon.png',
    'assets/emoji/Wrapped Gift.png',
    'assets/emoji/Calendar.png',
    'assets/emoji/Tear Off Calendar.png',
    'assets/emoji/Spiral Calendar.png',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM.w,
        vertical: AppSizes.spaceS12.h,
      ),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _emojiPaths.length,
      itemBuilder: (context, index) {
        final item = _emojiPaths[index];
        final isSelected = item == selectedEmoji;

        return GestureDetector(
          onTap: () => onEmojiSelected(item),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withValues(alpha: 0.2)
                  : AppColors.def.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.borderSM16),
              border: Border.all(
                color: isSelected ? AppColors.accent : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: _buildEmojiWidget(item),
            ),
          ),
        );
      },
    );
  }

  /// Builds the emoji widget using PNG images
  Widget _buildEmojiWidget(String assetPath) {
    return Image.asset(
      assetPath,
      width: 32,
      height: 32,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.def.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 20,
            color: AppColors.def.withValues(alpha: 0.5),
          ),
        );
      },
    );
  }
}
