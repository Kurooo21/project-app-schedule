import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_style.dart';
import 'schedule_board_screen.dart';
import 'schedule_form_screen.dart';
import 'schedule_models.dart';
import 'schedule_widgets.dart';

class DayActionScreen extends StatefulWidget {
  const DayActionScreen({
    super.key,
    required this.day,
    required this.initialEntries,
  });

  final DayInfo day;
  final List<ScheduleEntry> initialEntries;

  @override
  State<DayActionScreen> createState() => _DayActionScreenState();
}

class _DayActionScreenState extends State<DayActionScreen> {
  late List<ScheduleEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = sortedEntries(widget.initialEntries);
  }

  Future<bool> _handlePop() async {
    Navigator.pop(context, _entries);
    return false;
  }

  Future<void> _openBoard(AgendaBoardMode mode) async {
    final updatedEntries = await Navigator.push<List<ScheduleEntry>>(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleBoardScreen(
          day: widget.day,
          initialEntries: _entries,
          mode: mode,
        ),
      ),
    );

    if (updatedEntries == null) {
      return;
    }

    setState(() {
      _entries = sortedEntries(updatedEntries);
    });
  }

  Future<void> _openForm({ScheduleEntry? entry}) async {
    final result = await Navigator.push<ScheduleEntry>(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleFormScreen(
          day: widget.day,
          initialEntry: entry,
        ),
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      if (entry == null) {
        _entries = sortedEntries([..._entries, result]);
      } else {
        _entries = sortedEntries(
          _entries
              .map((item) => item.id == result.id ? result : item)
              .toList(growable: false),
        );
      }
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          entry == null
              ? 'Jadwal untuk ${widget.day.name} berhasil ditambahkan.'
              : 'Jadwal untuk ${widget.day.name} berhasil diperbarui.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final previewEntries = _entries.take(2).toList(growable: false);

    return WillPopScope(
      onWillPop: _handlePop,
      child: Scaffold(
        body: AppBackdrop(
          child: SafeArea(
            child: ScreenSurface(
              child: Column(
                children: [
                  SimpleTopBar(
                    title: widget.day.name,
                    subtitle: 'Pilih aksi untuk jadwal hari ini',
                    onBack: () => Navigator.pop(context, _entries),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: buildPanelDecoration(
                      color: AppPalette.primarySoft,
                      borderColor: const Color(0xFFC6DCE8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.day.motto,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            height: 1.55,
                            color: AppPalette.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        MenuButton(
                          title: 'Lihat jadwal',
                          subtitle: 'Buka daftar agenda untuk ${widget.day.name}.',
                          leading: _actionIcon(Icons.visibility_rounded),
                          onTap: () => _openBoard(AgendaBoardMode.view),
                        ),
                        const SizedBox(height: 10),
                        MenuButton(
                          title: 'Tambah jadwal',
                          subtitle: 'Masukkan agenda baru untuk hari ini.',
                          leading: _actionIcon(Icons.add_circle_outline_rounded),
                          onTap: () => _openForm(),
                        ),
                        const SizedBox(height: 10),
                        MenuButton(
                          title: 'Edit jadwal',
                          subtitle: 'Pilih agenda yang ingin diubah.',
                          leading: _actionIcon(Icons.edit_note_rounded),
                          onTap: () => _openBoard(AgendaBoardMode.edit),
                        ),
                        const SizedBox(height: 10),
                        MenuButton(
                          title: 'Hapus jadwal',
                          subtitle: 'Pilih agenda yang sudah tidak dipakai.',
                          leading: _actionIcon(Icons.delete_outline_rounded),
                          onTap: () => _openBoard(AgendaBoardMode.delete),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  HeaderPanel(title: 'PREVIEW JADWAL'),
                  const SizedBox(height: 12),
                  Expanded(
                    child: previewEntries.isEmpty
                        ? EmptyPanel(
                            icon: Icons.inbox_rounded,
                            title: 'Belum ada agenda',
                            message:
                                'Kamu bisa mulai dari tombol tambah jadwal agar hari ini langsung terisi.',
                            actionLabel: 'Tambah jadwal',
                            onAction: () => _openForm(),
                          )
                        : ListView.separated(
                            itemCount: previewEntries.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final entry = previewEntries[index];
                              return AgendaCard(
                                entry: entry,
                                actionLabel: 'Tap untuk ubah',
                                onTap: () => _openForm(entry: entry),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: AppPalette.primaryDark),
    );
  }
}
