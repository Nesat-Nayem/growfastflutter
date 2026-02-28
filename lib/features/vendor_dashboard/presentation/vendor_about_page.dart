import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';

// ─── Colours (matching GrowFirst design system) ─────────────────────────────
const _kGreen     = Color(0xFF6AA84F);
const _kGreenDark = Color(0xFF4D7A38);
const _kBlue      = Color(0xFF1A73E8);
const _kBlueDark  = Color(0xFF0D47A1);
const _kDarkGreen = Color(0xFF1B5E20);
const _kText      = Color(0xFF2D2D2D);
const _kMuted     = Color(0xFF6C757D);
const _kBg        = Color(0xFFF7F9FC);

class VendorAboutPage extends StatelessWidget {
  const VendorAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Become a Vendor',
          style: TextStyle(color: _kText, fontWeight: FontWeight.w700, fontSize: 17),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _kText),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── sticky step bar ──────────────────────────────
            _StepProgressBar(currentStep: 0),
            // ── scrollable content ───────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _HeroSection(),
                    _WhyJoinSection(),
                    _PricingSection(),
                    _HowItWorksSection(),
                    _ComparisonSection(),
                    _TestimonialsSection(),
                    _RegistrationHookSection(),
                    _FaqSection(),
                    _FinalCtaSection(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // ── sticky Next button ───────────────────────────
            _NextButtonBar(),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP PROGRESS BAR
// ════════════════════════════════════════════════════════════════════════════
class _StepProgressBar extends StatelessWidget {
  final int currentStep;
  const _StepProgressBar({required this.currentStep});

  static const _steps = [
    'About Us',
    'Basic Details',
    'KYC Details',
    'Choose Plan',
    'Confirmation',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE9ECEF))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              return Container(
                width: 24, height: 2,
                color: const Color(0xFFE9ECEF),
                margin: const EdgeInsets.symmetric(horizontal: 2),
              );
            }
            final idx = i ~/ 2;
            final isActive = idx == currentStep;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? _kGreen : const Color(0xFFE9ECEF),
                    boxShadow: isActive
                        ? [BoxShadow(color: _kGreen.withOpacity(.3), blurRadius: 6, spreadRadius: 2)]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${idx + 1}',
                      style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: isActive ? Colors.white : const Color(0xFFADB5BD),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  _steps[idx],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? _kGreen : const Color(0xFFADB5BD),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION 1 — HERO
// ════════════════════════════════════════════════════════════════════════════
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kBlue, _kBlueDark, _kDarkGreen],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          // badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white.withOpacity(.25)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, color: Colors.white, size: 14),
                SizedBox(width: 5),
                Text(
                  "India's Zero-Commission Vendor Platform",
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '🚀 Become a Grow First Vendor',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // price line with gradient text effect
          const Text(
            'Get Direct Customer Leads @ Just ₹699/Year',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFC8E6C9),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Zero Commission  |  No Middlemen  |  100% Earnings  |  12 Months Access',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 28),
          // CTA
          _GreenButton(
            label: '  Start Registration Now',
            icon: Icons.rocket_launch_rounded,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          // meta info
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20, runSpacing: 8,
            children: const [
              _HeroMeta(icon: Icons.phone, text: 'Need Help? Call: 8828381880'),
              _HeroMeta(icon: Icons.lock_outline, text: 'Secure & Trusted Platform'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _HeroMeta({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Colors.white70, size: 14),
      const SizedBox(width: 5),
      Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    ],
  );
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION 3 — WHY JOIN
// ════════════════════════════════════════════════════════════════════════════
class _WhyJoinSection extends StatelessWidget {
  const _WhyJoinSection();

  static const _benefits = [
    _Benefit('📲', 'Direct Customer Enquiries', 'Customers contact you directly — no intermediaries, no delays.'),
    _Benefit('💸', 'Zero Commission Forever', 'Keep 100% of every rupee you earn. Always.'),
    _Benefit('✅', 'No Fake Leads', 'Only genuine local enquiries from customers actively searching for your service.'),
    _Benefit('📅', 'One Year Visibility', 'Full 12-month business exposure from the day of activation.'),
    _Benefit('📈', 'Strong ROI', '₹699 investment = unlimited growth potential for your business.'),
    _Benefit('🛡️', 'Verified Vendor Badge', 'Stand out with an official Grow First Verified badge on your profile.'),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      bgColor: Colors.white,
      child: Column(
        children: [
          _SectionHeader(badge: 'Why Grow First?', title: '💼 Grow Your Business\nWithout Commission'),
          const SizedBox(height: 24),
          ...(_benefits.map((b) => _BenefitCard(benefit: b))),
        ],
      ),
    );
  }
}

class _Benefit {
  final String emoji, title, desc;
  const _Benefit(this.emoji, this.title, this.desc);
}

class _BenefitCard extends StatelessWidget {
  final _Benefit benefit;
  const _BenefitCard({required this.benefit});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: _kGreen, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(benefit.emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(benefit.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _kText)),
                const SizedBox(height: 4),
                Text(benefit.desc, style: const TextStyle(fontSize: 13, color: _kMuted, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION 4 — PRICING
// ════════════════════════════════════════════════════════════════════════════
class _PricingSection extends StatelessWidget {
  const _PricingSection();

  static const _features = [
    '12 Months Vendor Access',
    'Direct Leads from Customers',
    'Vendor Dashboard Access',
    'Ratings & Review System',
    'Verified Vendor Badge',
    'No Commission on Any Job',
    'No Hidden Charges',
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      bgColor: _kBg,
      child: Column(
        children: [
          _SectionHeader(badge: 'Simple Pricing', title: '💰 One Plan. Zero Confusion.'),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: const Color(0xFF1B5E20).withOpacity(.4), blurRadius: 24, offset: const Offset(0, 10))],
            ),
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white.withOpacity(.3)),
                  ),
                  child: const Text('VENDOR PLAN', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .8)),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(text: '₹', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                      TextSpan(text: '699', style: TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w900, height: 1)),
                      TextSpan(text: ' /Year', style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text('12 Months Full Access — No Renewals Pressure', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 20),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),
                ...(_features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF69F0AE), size: 18),
                      const SizedBox(width: 10),
                      Text(f, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ))),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 12)],
                  ),
                  child: const Center(
                    child: Text('🟢 Register Now @ ₹699', style: TextStyle(color: _kGreenDark, fontSize: 16, fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, color: Colors.white54, size: 13),
                    SizedBox(width: 5),
                    Text('Secure Online Payment  ·  Transparent Pricing', style: TextStyle(color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION 5 — HOW IT WORKS
// ════════════════════════════════════════════════════════════════════════════
class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  static const _steps = [
    _HowStep('1', 'Register & Complete KYC', 'Fill basic details and upload KYC docs. Takes less than 5 minutes.'),
    _HowStep('2', 'Pay ₹699 & Activate', 'One simple payment. Your vendor account gets activated instantly.'),
    _HowStep('3', 'Receive Direct Enquiries', 'Customers in your area find you and contact you directly via the app.'),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      bgColor: Colors.white,
      child: Column(
        children: [
          _SectionHeader(badge: 'How It Works', title: '🔄 3 Simple Steps to\nStart Receiving Leads'),
          const SizedBox(height: 24),
          ...List.generate(_steps.length, (i) => _HowStepCard(step: _steps[i], isLast: i == _steps.length - 1)),
        ],
      ),
    );
  }
}

class _HowStep {
  final String num, title, desc;
  const _HowStep(this.num, this.title, this.desc);
}

class _HowStepCard extends StatelessWidget {
  final _HowStep step;
  final bool isLast;
  const _HowStepCard({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [_kGreen, _kGreenDark]),
                boxShadow: [BoxShadow(color: _kGreen.withOpacity(.35), blurRadius: 10)],
              ),
              child: Center(
                child: Text(step.num, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: const Color(0xFFDCEDC8)),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(step.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _kText)),
                const SizedBox(height: 4),
                Text(step.desc, style: const TextStyle(fontSize: 13, color: _kMuted, height: 1.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION 6 — COMPARISON TABLE
// ════════════════════════════════════════════════════════════════════════════
class _ComparisonSection extends StatelessWidget {
  const _ComparisonSection();

  static const _rows = [
    ['20–30% Commission on Every Job', 'ZERO Commission — Always'],
    ['Middlemen & Brokers', 'Direct Customer Contact'],
    ['Fake & Junk Leads', 'Genuine Local Enquiries Only'],
    ['High Monthly Ad Costs', 'Affordable ₹699 / Year Plan'],
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      bgColor: _kBg,
      child: Column(
        children: [
          _SectionHeader(badge: 'Why Us?', title: 'Why Grow First is Different'),
          const SizedBox(height: 20),
          // Header row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3F3),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                  ),
                  child: const Text('❌ Other Platforms', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
                  ),
                  child: const Text('✅ Grow First', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          ...List.generate(_rows.length, (i) {
            final isLast = i == _rows.length - 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: isLast ? const BorderRadius.only(bottomLeft: Radius.circular(12)) : null,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.cancel, color: Color(0xFFE53935), size: 15),
                          const SizedBox(width: 6),
                          Expanded(child: Text(_rows[i][0], style: const TextStyle(fontSize: 12, color: Color(0xFFE53935)))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: isLast ? const BorderRadius.only(bottomRight: Radius.circular(12)) : null,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, color: _kGreen, size: 15),
                          const SizedBox(width: 6),
                          Expanded(child: Text(_rows[i][1], style: const TextStyle(fontSize: 12, color: _kGreen, fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION 7 — TESTIMONIALS
// ════════════════════════════════════════════════════════════════════════════
class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      bgColor: Colors.white,
      child: Column(
        children: [
          _SectionHeader(badge: 'Testimonials', title: '⭐ What Vendors Say'),
          const SizedBox(height: 20),
          const _TestiCard(
            initial: 'V',
            name: 'Viraj AC Services',
            role: 'AC Technician — Navi Mumbai',
            quote: '"Within 1 week I started getting genuine enquiries. The platform is very easy to use and the support team is responsive."',
          ),
          const SizedBox(height: 14),
          const _TestiCard(
            initial: 'S',
            name: 'Sharau Builders',
            role: 'Contractor — Andheri',
            quote: '"No commission means more profit for my business. I recovered my ₹699 in the very first week of getting leads!"',
          ),
        ],
      ),
    );
  }
}

class _TestiCard extends StatelessWidget {
  final String initial, name, role, quote;
  const _TestiCard({required this.initial, required this.name, required this.role, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: const Border(top: BorderSide(color: _kGreen, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.07), blurRadius: 14, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars
          const Row(
            children: [
              Icon(Icons.star, color: Color(0xFFF9A825), size: 16),
              Icon(Icons.star, color: Color(0xFFF9A825), size: 16),
              Icon(Icons.star, color: Color(0xFFF9A825), size: 16),
              Icon(Icons.star, color: Color(0xFFF9A825), size: 16),
              Icon(Icons.star, color: Color(0xFFF9A825), size: 16),
            ],
          ),
          const SizedBox(height: 10),
          Text(quote, style: const TextStyle(fontSize: 14, color: Color(0xFF444444), fontStyle: FontStyle.italic, height: 1.6)),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [_kGreen, _kBlue]),
                ),
                child: Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(role, style: const TextStyle(color: _kMuted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION 8 — REGISTRATION HOOK
// ════════════════════════════════════════════════════════════════════════════
class _RegistrationHookSection extends StatelessWidget {
  const _RegistrationHookSection();

  static const _miniSteps = [
    ('2', '👤 Basic Details'),
    ('3', '📄 KYC Verification'),
    ('4', '💳 Payment ₹699'),
    ('5', '✅ Confirmation'),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      bgColor: _kBg,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF0F4FF)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 12)],
        ),
        child: Column(
          children: [
            const Text('📝 Vendor Registration Form', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kText)),
            const SizedBox(height: 8),
            const Text(
              'Complete the 4-step form below to register as a verified Grow First Vendor',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: _kMuted, height: 1.5),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10, runSpacing: 10,
              children: _miniSteps.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.07), blurRadius: 8)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22, height: 22,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: _kGreen),
                      child: Center(child: Text(s.$1, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                    ),
                    const SizedBox(width: 7),
                    Text(s.$2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kText)),
                  ],
                ),
              )).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.shield_outlined, color: _kGreen, size: 14),
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'Your details are 100% secure and never shared.',
                    style: TextStyle(fontSize: 12, color: _kMuted),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION 9 — FAQ
// ════════════════════════════════════════════════════════════════════════════
class _FaqSection extends StatelessWidget {
  const _FaqSection();

  static const _faqs = [
    ('How will I receive customer leads?', 'Customers search for services on the Grow First app and directly contact you via phone or message. You receive their enquiry immediately.'),
    ('Is there any commission charged?', 'No. Grow First charges absolutely zero commission on any job or booking. You keep 100% of what you earn.'),
    ('How long is the plan valid?', 'Your vendor plan is valid for 12 months from the date of activation. A renewal option will be available before it expires.'),
    ('Are there any hidden charges?', 'None whatsoever. ₹699 per year is the only fee. No setup fees, no monthly charges, no transaction fees.'),
    ('Can I renew next year?', 'Yes, a renewal option will be available from your vendor dashboard before your plan expires.'),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      bgColor: Colors.white,
      child: Column(
        children: [
          _SectionHeader(badge: 'FAQ', title: '❓ Frequently Asked Questions'),
          const SizedBox(height: 20),
          ...(_faqs.map((f) => _FaqItem(q: f.$1, a: f.$2))),
        ],
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String q, a;
  const _FaqItem({required this.q, required this.a});
  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(child: Text(widget.q, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _open ? _kGreen : _kText))),
                  Icon(_open ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: _open ? _kGreen : _kMuted),
                ],
              ),
            ),
          ),
          if (_open)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(widget.a, style: const TextStyle(fontSize: 13, color: _kMuted, height: 1.6)),
            ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION 10 — FINAL CTA
// ════════════════════════════════════════════════════════════════════════════
class _FinalCtaSection extends StatelessWidget {
  const _FinalCtaSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kBlue, _kBlueDark, _kDarkGreen],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          const Text('🚀 Ready to Grow Your Business?', textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const Text(
            'Join thousands of vendors already growing with Grow First.\nRegister today and start receiving direct customer enquiries.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 28),
          _GreenButton(label: '🟢 Become a Vendor @ ₹699', onTap: () {}),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24, runSpacing: 8,
            children: const [
              _HeroMeta(icon: Icons.phone, text: 'Customer Support: 8828381880'),
              _HeroMeta(icon: Icons.language, text: 'www.growfirst.org'),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STICKY NEXT BUTTON
// ════════════════════════════════════════════════════════════════════════════
class _NextButtonBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: ElevatedButton.icon(
          onPressed: () => context.pushNamed(AppRouterNames.vendorDashboard),
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: const Text('Next — Start Registration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          style: ElevatedButton.styleFrom(
            backgroundColor: _kGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SHARED HELPERS
// ════════════════════════════════════════════════════════════════════════════
class _SectionWrapper extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  const _SectionWrapper({required this.child, required this.bgColor});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: bgColor,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
    child: child,
  );
}

class _SectionHeader extends StatelessWidget {
  final String badge, title;
  const _SectionHeader({required this.badge, required this.title});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(badge.toUpperCase(), style: const TextStyle(color: _kGreen, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .6)),
      ),
      const SizedBox(height: 10),
      Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _kText, height: 1.3)),
    ],
  );
}

class _GreenButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  const _GreenButton({required this.label, required this.onTap, this.icon});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: _kGreen,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [BoxShadow(color: _kGreen.withOpacity(.45), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, color: Colors.white, size: 18), const SizedBox(width: 8)],
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
        ],
      ),
    ),
  );
}
