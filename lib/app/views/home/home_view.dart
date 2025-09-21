import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // System UI visibility management
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.nordicBlue,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              OsmeaColors.nordicBlue,
              OsmeaColors.blue,
              OsmeaColors.nordicBlue,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(context.spacing20),
              child: OsmeaComponents.column(
                children: [
                  // Header - More compact
                  _buildModernHeader(context),

                  OsmeaComponents.sizedBox(height: context.height40),

                  // Quick Actions - More modern
                  _buildModernQuickActions(context),

                  OsmeaComponents.sizedBox(height: context.height40),

                  // Info Section
                  _buildInfoSection(context),

                  OsmeaComponents.sizedBox(height: context.height40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.sizedBox(height: context.height40),
        Image.asset('assets/images/rocket-lica.png', height: 60, width: 60),
        OsmeaComponents.sizedBox(height: context.height16),
        OsmeaComponents.text(
          'RocketLica',
          fontSize: context.fontSizeExtraLarge,
          fontWeight: context.extraBold,
          letterSpacing: context.letterSpacingWide,
          color: Colors.white,
        ),
        OsmeaComponents.sizedBox(height: context.height8),
        OsmeaComponents.text(
          'AI-Powered Document to PDF Converter',
          fontSize: context.fontSizeMedium,
          fontWeight: context.light,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ],
    );
  }

  Widget _buildModernQuickActions(BuildContext context) {
    return OsmeaComponents.row(
      children: [
        OsmeaComponents.expanded(
          child: _buildActionCard(
            context,
            'Upload',
            Icons.cloud_upload_outlined,
            () => context.go(AppRouter.documentUpload),
          ),
        ),
        OsmeaComponents.sizedBox(width: context.width16),
        OsmeaComponents.expanded(
          child: _buildActionCard(
            context,
            'PDF',
            Icons.picture_as_pdf,
            () => _showPDFComingSoon(context),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 8),
            OsmeaComponents.text(
              title,
              fontSize: context.fontSizeSmall,
              fontWeight: context.medium,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'How it works',
            fontSize: context.fontSizeLarge,
            fontWeight: context.bold,
            color: Colors.white,
          ),
          OsmeaComponents.sizedBox(height: context.height16),
          _buildInfoItem(
            context,
            '1',
            'Upload',
            'Upload your images or PDF documents',
            Icons.cloud_upload_outlined,
          ),
          OsmeaComponents.sizedBox(height: context.height12),
          _buildInfoItem(
            context,
            '2',
            'Process',
            'AI extracts text using advanced OCR',
            Icons.psychology_alt,
          ),
          OsmeaComponents.sizedBox(height: context.height12),
          _buildInfoItem(
            context,
            '3',
            'Generate',
            'Create professional PDFs with extracted text',
            Icons.picture_as_pdf,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String number,
    String title,
    String description,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: OsmeaComponents.text(
              number,
              fontSize: context.fontSizeSmall,
              fontWeight: context.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.8)),
        const SizedBox(width: 8),
        Expanded(
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.text(
                title,
                fontSize: context.fontSizeSmall,
                fontWeight: context.semiBold,
                color: Colors.white,
              ),
              OsmeaComponents.text(
                description,
                fontSize: context.fontSizeSmall,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPDFComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E3A8A).withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: OsmeaComponents.text(
            'PDF Features',
            fontSize: context.fontSizeLarge,
            fontWeight: context.bold,
            color: Colors.white,
            textAlign: context.textCenter,
          ),
          content: OsmeaComponents.text(
            'Upload documents first to generate PDFs! Use the Upload button to get started.',
            fontSize: context.fontSizeMedium,
            color: Colors.white,
            textAlign: context.textCenter,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: OsmeaComponents.text(
                'OK',
                color: Colors.white,
                fontWeight: context.semiBold,
              ),
            ),
          ],
        );
      },
    );
  }
}
