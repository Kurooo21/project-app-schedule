import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_style.dart';
import 'day_action_screen.dart';
import 'schedule_models.dart';
import 'schedule_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Map<String, List<ScheduleEntry>> _entriesByDay =
      buildInitialSchedules();

  Future<void> _openDayFlow(DayInfo day) async {
    final updatedEntries = await Navigator.push<List<ScheduleEntry>>(
      context,
      MaterialPageRoute(
        builder: (context) => DayActionScreen(
          day: day,
          initialEntries: List<ScheduleEntry>.from(
            _entriesByDay[day.name] ?? const <ScheduleEntry>[],
          ),
        ),
      ),
    );

    if (updatedEntries == null) {
      return;
    }

    setState(() {
      _entriesByDay[day.name] = sortedEntries(updatedEntries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: ScreenSurface(
            child: Column(
              children: [
                Text(
                  'YOUR SCHEDULE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppPalette.primaryDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pilih hari untuk membuka menu jadwal.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppPalette.subtleText,
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: buildPanelDecoration(
                      color: AppPalette.primarySoft,
                      borderColor: const Color(0xFFC6DCE8),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 14),
                        HeaderPanel(title: 'HARI'),
                        const SizedBox(height: 14),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                            itemCount: weekDays.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final day = weekDays[index];
                              final entries = sortedEntries(
                                _entriesByDay[day.name] ??
                                    const <ScheduleEntry>[],
                              );

                              return MenuButton(
                                title: day.name,
                                subtitle: _buildSubtitle(entries),
                                leading: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: AppPalette.primarySoft,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    day.icon,
                                    size: 18,
                                    color: AppPalette.primaryDark,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppPalette.primarySoft,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Text(
                                    '${entries.length}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppPalette.primaryDark,
                                    ),
                                  ),
                                ),
                                onTap: () => _openDayFlow(day),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Semua hari tetap ada, tapi tampilannya dibuat lebih bersih dan mudah dipahami.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    height: 1.6,
                    color: AppPalette.subtleText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildSubtitle(List<ScheduleEntry> entries) {
    if (entries.isEmpty) {
      return 'Belum ada jadwal untuk hari ini.';
    }

    final firstEntry = entries.first;
    return '${formatTimeRange(firstEntry)} - ${firstEntry.subject}';
  }
}
