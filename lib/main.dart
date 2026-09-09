import 'package:flutter/material.dart';
import 'dart:html' as html;

// -----------------------------------------------------------------------
// DESIGN TOKENS
// A blue-toned professional palette — deep navy for text, steel blue for
// secondary text, a corporate blue accent, and a cool off-white background.
// Borders are used instead of drop shadows throughout for a flatter,
// editorial feel rather than a default Material look.
// -----------------------------------------------------------------------
class AppColors {
  static const ink = Color(0xFF10233F);
  static const slate = Color(0xFF4C637A);
  static const accent = Color(0xFF1D5FAE);
  static const background = Color(0xFFF4F7FB);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFD9E1EA);
}

/// Opens the given URL in a new browser tab.
/// Uses dart:html, part of the Flutter web SDK — no extra package needed.
/// Works when running on Chrome (flutter run -d chrome) or any web build.
void _openLink(String url) {
  html.window.open(url, '_blank');
}

void main() {
  runApp(const PortfolioApp());
}

/// A CircleAvatar that loads a profile photo from the network, but falls
/// back to a plain person icon if the image fails to load (e.g. no internet
/// access during a demo). Keeps the CircleAvatar + NetworkImage requirement
/// while guaranteeing the UI never looks broken.
class ProfileAvatar extends StatefulWidget {
  final double radius;
  final String imageUrl;

  const ProfileAvatar({
    super.key,
    required this.radius,
    required this.imageUrl,
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  bool _imageFailed = false;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: AppColors.border,
      backgroundImage:
      _imageFailed ? null : NetworkImage(widget.imageUrl) as ImageProvider,
      onBackgroundImageError: _imageFailed
          ? null
          : (exception, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _imageFailed = true);
        });
      },
      child: _imageFailed
          ? Icon(Icons.person, size: widget.radius, color: AppColors.slate)
          : null,
    );
  }
}

/// Root widget of the application.
/// Sets up MaterialApp with named routes for navigation between pages.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siddanti Chiruhas — Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          background: AppColors.background,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.ink,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: AppColors.ink,
            fontSize: 19,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.ink, height: 1.5),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/about': (context) => const AboutPage(),
        '/projects': (context) => const ProjectsPage(),
      },
    );
  }
}

/// A shared app bar with a thin bottom border for visual structure.
/// AppBarTheme has no 'bottom' property, so this is a small wrapper
/// that adds the border consistently across every page.
class PortfolioAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const PortfolioAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

/// A short horizontal rule used under section headings — a structural
/// marker for where a section starts, not a decorative flourish.
class _SectionRule extends StatelessWidget {
  const _SectionRule();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 3,
      color: AppColors.accent,
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        const _SectionRule(),
      ],
    );
  }
}

/// A minimal text-style link used for LinkedIn / Email — no button chrome,
/// styled like a contact line on a resume.
class _ProfileLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _ProfileLink({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openLink(url),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.border,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------
// HOME PAGE
// -----------------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarRadius = screenWidth < 500 ? 56.0 : 84.0;

    final outlinedStyle = OutlinedButton.styleFrom(
      foregroundColor: AppColors.ink,
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );

    final filledStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.surface,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );

    return Scaffold(
      appBar: const PortfolioAppBar(title: 'Portfolio'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewport) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: viewport.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ProfileAvatar(
                            radius: avatarRadius,
                            imageUrl: 'https://i.pravatar.cc/300?img=32',
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Siddanti Chiruhas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'CR RAO AIMSCS',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.slate,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'B.Tech Computer Science Engineering, 2024 – 2028',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.slate,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'I build responsive, well-structured applications '
                                  'and enjoy turning ideas into clean, working '
                                  'software.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.ink,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isNarrow = constraints.maxWidth < 400;
                              final about = OutlinedButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/about'),
                                style: outlinedStyle,
                                child: const Text('About Me'),
                              );
                              final projects = ElevatedButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/projects'),
                                style: filledStyle,
                                child: const Text('Projects'),
                              );

                              if (isNarrow) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: projects,
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: about,
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  about,
                                  const SizedBox(width: 16),
                                  projects,
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// ABOUT PAGE
// -----------------------------------------------------------------------
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PortfolioAppBar(title: 'About'),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeading('Background'),
                    const SizedBox(height: 16),
                    const Text(
                      'I am a Computer Science Engineering student at CR RAO '
                          'AIMSCS (2024 – 2028). I care about clean structure, '
                          'readable code, and building things that hold up '
                          'outside a demo.',
                      style: TextStyle(
                        fontSize: 15.5,
                        color: AppColors.ink,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.school_outlined,
                            size: 20, color: AppColors.accent),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'CR RAO AIMSCS — B.Tech, Computer Science '
                                'Engineering (2024 – 2028)',
                            style: TextStyle(
                              fontSize: 14.5,
                              color: AppColors.slate,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    const _SectionHeading('Technical Skills'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _SkillTag(label: 'Flutter & Dart'),
                        _SkillTag(label: 'HTML / CSS / JavaScript'),
                        _SkillTag(label: 'Python'),
                        _SkillTag(label: 'REST APIs'),
                        _SkillTag(label: 'Git & GitHub'),
                        _SkillTag(label: 'UI/UX Design'),
                      ],
                    ),
                    const SizedBox(height: 36),

                    const _SectionHeading('Connect'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children: const [
                        _ProfileLink(
                          icon: Icons.business_center_outlined,
                          label: 'LinkedIn',
                          url:
                          'https://www.linkedin.com/in/chiruhas-siddanti-a609a1394/',
                        ),
                        _ProfileLink(
                          icon: Icons.email_outlined,
                          label: 'Siddantichiruhas@gmail.com',
                          url: 'mailto:Siddantichiruhas@gmail.com',
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.ink,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('Back to Home'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A flat, bordered tag used for skills — square-ish corners and a hairline
/// border rather than a filled pill, to match the page's flatter language.
class _SkillTag extends StatelessWidget {
  final String label;
  const _SkillTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13.5,
          color: AppColors.ink,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// PROJECTS PAGE
// -----------------------------------------------------------------------
class Project {
  final String title;
  final String description;
  final String techStack;
  final IconData icon;

  const Project({
    required this.title,
    required this.description,
    required this.techStack,
    required this.icon,
  });
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  static const List<Project> _projects = [
    Project(
      title: 'Weather Forecast App',
      description:
      'A clean weather application that fetches live conditions and a '
          '5-day forecast from a public API, with a simple, readable '
          'interface.',
      techStack: 'Flutter · REST API',
      icon: Icons.wb_sunny_outlined,
    ),
    Project(
      title: 'E-commerce UI',
      description:
      'A responsive e-commerce interface featuring product listings, a '
          'shopping cart, and smooth navigation across product and '
          'checkout screens.',
      techStack: 'Flutter · State Management',
      icon: Icons.shopping_bag_outlined,
    ),
    Project(
      title: 'Task Manager',
      description:
      'A to-do and task-tracking app with categories, due dates, and '
          'local persistence, designed around a minimal, distraction-free '
          'interface.',
      techStack: 'Flutter · Local Storage',
      icon: Icons.checklist_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PortfolioAppBar(title: 'Projects'),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 620;
                        if (!isWide) {
                          return Column(
                            children: _projects
                                .map((p) => Padding(
                              padding:
                              const EdgeInsets.only(bottom: 16),
                              child: _ProjectCard(project: p),
                            ))
                                .toList(),
                          );
                        }
                        final cardWidth = (constraints.maxWidth - 16) / 2;
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: _projects
                              .map((p) => SizedBox(
                            width: cardWidth,
                            child: _ProjectCard(project: p),
                          ))
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 8),
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.ink,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A flat, bordered project card — a hairline border stands in for the
/// default drop-shadow-and-rounded-corner treatment.
class _ProjectCard extends StatelessWidget {
  final Project project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(project.icon, size: 20, color: AppColors.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            project.description,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.slate,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project.techStack,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.ink,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}