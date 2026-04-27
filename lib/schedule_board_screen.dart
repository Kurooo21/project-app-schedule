import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_style.dart';
import 'schedule_form_screen.dart';
import 'schedule_models.dart';
import 'schedule_widgets.dart';

class ScheduleBoardScreen extends StatefulWidget {
  const ScheduleBoardScreen({
    super.key,
    required this.day,
    required this.initialEntries,
    required this.mode,
  });

  final DayInfo day;
  final List<ScheduleEntry> initialEntries;
  final AgendaBoardMode mode;

  @override
  State<ScheduleBoardScreen> createState() => _ScheduleBoardScreenState();
}

class _ScheduleBoardScreenState extends State<ScheduleBoardScreen> {
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
      final index = _entries.indexWhere((item) => item.id == result.id);
      if (index == -1) {
        _entries = sortedEntries([..._entries, result]);
      } else {
        final updated = [..._entries];
        updated[index] = result;
        _entries = sortedEntries(updated);
      }
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          entry == null
              ? 'Jadwal baru berhasil ditambah.'
              : 'Jadwal berhasil diperbarui.',
        ),
      ),
    );
  }

  Future<void> _handleEntryTap(ScheduleEntry entry) async {
    switch (widget.mode) {
      case AgendaBoardMode.view:
        await _showEntrySheet(entry);
        break;
      case AgendaBoardMode.edit:
        await _openForm(entry: entry);
        break;
      case AgendaBoardMode.delete:
        await _confirmDelete(entry);
        break;
    }
  }

  Future<void> _showEntrySheet(ScheduleEntry entry) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(14),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: buildPanelDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.subject,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppPalette.primaryDark,
                        ),
                      ),
                    ),
                    TagPill(label: entry.tag),
                  ],
                ),
                const SizedBox(height: 12),
                InfoLine(
                  icon: Icons.schedule_rounded,
                  text: formatTimeRange(entry),
                ),
                const SizedBox(height: 8),
                InfoLine(
                  icon: Icons.place_rounded,
                  text: entry.location,
                ),
                const SizedBox(height: 8),
                InfoLine(
                  icon: Icons.notes_rounded,
                  text: entry.note,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _openForm(entry: entry);
                        },
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppPalette.danger,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await _confirmDelete(entry);
                        },
                        child: const Text('Hapus'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(ScheduleEntry entry) async {
    final approved = await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(14),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: buildPanelDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hapus jadwal ini?',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppPalette.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${entry.subject} pada ${formatTimeRange(entry)} akan dihapus dari ${widget.day.name}.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.6,
                        color: AppPalette.subtleText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppPalette.danger,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Hapus'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;

    if (!approved) {
      return;
    }

    setState(() {
      _entries = _entries
          .where((item) => item.id != entry.id)
          .toList(growable: false);
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${entry.subject} berhasil dihapus.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modeLabel = boardLabels[widget.mode]!;

    return WillPopScope(
      onWillPop: _handlePop,
      child: Scaffold(
        body: AppBackdrop(
          child: SafeArea(
            child: ScreenSurface(
              child: Column(
                children: [
                  SimpleTopBar(
                    title: modeLabel.title,
                    subtitle: '${widget.day.name} - ${modeLabel.subtitle}',
                    onBack: () => Navigator.pop(context, _entries),
                  ),
                  const SizedBox(height: 18),
                  HeaderPanel(
                    title: '${widget.day.name.toUpperCase()}  |  TOTAL ${_entries.length}',
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: _entries.isEmpty
                        ? EmptyPanel(
                            icon: modeLabel.emptyIcon,
                            title: modeLabel.emptyTitle,
                            message: modeLabel.emptyMessage,
                            actionLabel: widget.mode == AgendaBoardMode.view
                                ? 'Tambah sekarang'
                                : 'Kembali',
                            onAction: widget.mode == AgendaBoardMode.view
                                ? _openForm
                                : () => Navigator.pop(context, _entries),
                          )
                        : ListView.separated(
                            itemCount: _entries.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final entry = _entries[index];
                              return AgendaCard(
                                entry: entry,
                                actionLabel: modeLabel.actionLabel,
                                onTap: () => _handleEntryTap(entry),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, _entries),
                          child: const Text('Kembali'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            if (widget.mode == AgendaBoardMode.view) {
                              _openForm();
                              return;
                            }

                            Navigator.pop(context, _entries);
                          },
                          child: Text(
                            widget.mode == AgendaBoardMode.view
                                ? 'Tambah'
                                : 'Selesai',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
