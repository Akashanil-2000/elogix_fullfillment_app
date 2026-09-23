import 'package:elogix_fullfillment_app/modules/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    final bool isTablet = width >= 600;

    // ============================================================
    // DIAGONAL GEOMETRY
    // ============================================================

    final double diagonalStartY = height * 0.41;

    final double diagonalEndX = width * 0.45;

    // ONLY the diagonal endpoint
    final double diagonalEndY = height * 0.70;

    // ============================================================
    // TRIANGLE GEOMETRY
    // ============================================================

    // Independent from diagonalEndY
    final double trianglePointY = height * 0.713;

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: Stack(
          children: [
            // ======================================================
            // BLACK BACKGROUND
            // ======================================================
            Positioned.fill(child: Container(color: const Color(0xFF050505))),

            // ======================================================
            // WAREHOUSE IMAGE
            // ======================================================
            // ======================================================
            // WAREHOUSE IMAGE
            // ======================================================
            Positioned.fill(
              child: ClipPath(
                clipper: WarehouseClipper(
                  diagonalStartY: diagonalStartY,
                  diagonalEndX: diagonalEndX,
                  diagonalEndY: diagonalEndY,
                ),
                child: Transform.translate(
                  offset: Offset(0, height * 0.25),
                  child: Image.asset(
                    'assets/images/warehouse.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),

            // ======================================================
            // ORANGE GEOMETRY
            // ======================================================
            Positioned.fill(
              child: CustomPaint(
                painter: OrangeGeometryPainter(
                  diagonalStartY: diagonalStartY,
                  diagonalEndX: diagonalEndX,
                  diagonalEndY: diagonalEndY,
                  trianglePointY: trianglePointY,
                  isTablet: isTablet,
                ),
              ),
            ),

            // ======================================================
            // CONTENT
            // ======================================================
            Positioned(
              left: width * 0.09,
              right: width * 0.08,
              top: height * 0.035,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // LOGO
                  // ==================================================
                  // ==================================================
                  // LOGO
                  // ==================================================
                  Transform.translate(
                    offset: Offset(-width * 0.02, 0),
                    child: Image.asset(
                      'assets/images/elogix.png',
                      width: isTablet ? width * 0.55 : width * 0.60,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: height * 0.045),

                  // ==================================================
                  // HEADLINE
                  // ==================================================
                  Text(
                    'Your\nE-Commerce\nGrowth Partner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? width * 0.052 : width * 0.072,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                      letterSpacing: -0.4,
                    ),
                  ),

                  SizedBox(height: height * 0.028),

                  // ==================================================
                  // SERVICES
                  // ==================================================
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _serviceText('Storage', isTablet, width),

                        _separator(),

                        _serviceText('Pick & Pack', isTablet, width),

                        _separator(),

                        _serviceText('Shipping', isTablet, width),

                        _separator(),

                        _serviceText('Returns', isTablet, width),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // SERVICE TEXT
  // ==============================================================

  static Widget _serviceText(String text, bool isTablet, double width) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: isTablet ? width * 0.018 : width * 0.027,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ==============================================================
  // SERVICE SEPARATOR
  // ==============================================================

  static Widget _separator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Text(
        '|',
        style: TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ==================================================================
// WAREHOUSE CLIPPER
// ==================================================================

class WarehouseClipper extends CustomClipper<Path> {
  final double diagonalStartY;
  final double diagonalEndX;
  final double diagonalEndY;

  WarehouseClipper({
    required this.diagonalStartY,
    required this.diagonalEndX,
    required this.diagonalEndY,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width, diagonalStartY);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.lineTo(diagonalEndX, diagonalEndY);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant WarehouseClipper oldClipper) {
    return oldClipper.diagonalStartY != diagonalStartY ||
        oldClipper.diagonalEndX != diagonalEndX ||
        oldClipper.diagonalEndY != diagonalEndY;
  }
}

// ==================================================================
// ORANGE GEOMETRY PAINTER
// ==================================================================

class OrangeGeometryPainter extends CustomPainter {
  final double diagonalStartY;
  final double diagonalEndX;
  final double diagonalEndY;

  // Independent triangle point
  final double trianglePointY;

  final bool isTablet;

  OrangeGeometryPainter({
    required this.diagonalStartY,
    required this.diagonalEndX,
    required this.diagonalEndY,
    required this.trianglePointY,
    required this.isTablet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const Color orange = Color(0xFFFF7800);
    const Color darkOrange = Color(0xFF6A2D00);

    final double lineWidth = isTablet ? 18 : 12;

    // ============================================================
    // 1. SMALL DARK ORANGE DIAMOND
    //
    // Draw this FIRST.
    //
    // This means the orange triangle and diagonal will be
    // painted over the diamond.
    // ============================================================

    final Paint diamondPaint =
        Paint()
          ..color = darkOrange
          ..style = PaintingStyle.fill;

    // ------------------------------------------------------------
    // DIAMOND POSITION
    // ------------------------------------------------------------

    // Move diamond LEFT / RIGHT
    final double diamondCenterX = size.width * 0.43;

    // Move diamond UP / DOWN
    final double diamondCenterY = size.height * 0.687;

    // ------------------------------------------------------------
    // DIAMOND SIZE
    // ------------------------------------------------------------

    final double diamondSize = isTablet ? 78 : 50;

    final Path diamond = Path();

    // Top
    diamond.moveTo(diamondCenterX, diamondCenterY - diamondSize / 2);

    // Right
    diamond.lineTo(diamondCenterX + diamondSize / 2, diamondCenterY);

    // Bottom
    diamond.lineTo(diamondCenterX, diamondCenterY + diamondSize / 2);

    // Left
    diamond.lineTo(diamondCenterX - diamondSize / 2, diamondCenterY);

    diamond.close();

    // Diamond is drawn first
    canvas.drawPath(diamond, diamondPaint);

    // ============================================================
    // 2. LARGE ORANGE TRIANGLE
    //
    // Draw after diamond so triangle sits ON TOP.
    // ============================================================

    final Paint trianglePaint =
        Paint()
          ..color = orange
          ..style = PaintingStyle.fill;

    final double trianglePointX = diagonalEndX;

    // Independent triangle upper position
    final double triangleTopY = size.height * 0.46;

    final Path triangle = Path();

    triangle.moveTo(0, triangleTopY);

    triangle.lineTo(0, size.height);

    triangle.lineTo(trianglePointX, trianglePointY);

    triangle.close();

    canvas.drawPath(triangle, trianglePaint);

    // ============================================================
    // 3. MAIN ORANGE DIAGONAL
    //
    // Draw this LAST.
    //
    // Therefore the diagonal is always ON TOP of the diamond.
    // ============================================================

    final Paint diagonalPaint =
        Paint()
          ..color = orange
          ..style = PaintingStyle.stroke
          ..strokeWidth = lineWidth
          ..strokeCap = StrokeCap.square;

    final Path diagonal = Path();

    diagonal.moveTo(size.width, diagonalStartY);

    diagonal.lineTo(diagonalEndX, diagonalEndY);

    canvas.drawPath(diagonal, diagonalPaint);
  }

  @override
  bool shouldRepaint(covariant OrangeGeometryPainter oldDelegate) {
    return oldDelegate.diagonalStartY != diagonalStartY ||
        oldDelegate.diagonalEndX != diagonalEndX ||
        oldDelegate.diagonalEndY != diagonalEndY ||
        oldDelegate.trianglePointY != trianglePointY ||
        oldDelegate.isTablet != isTablet;
  }
}
