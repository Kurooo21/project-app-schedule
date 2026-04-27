import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_style.dart';
import 'schedule_models.dart';
import 'schedule_widgets.dart';

class ScheduleFormScreen extends StatefulWidget {
  const ScheduleFormScreen({
    super.key,
    required this.day,
    this.initialEntry,
  });

  final DayInfo day;
  final ScheduleEntry? initialEntry;

  @override
  State<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends State<ScheduleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectController;
  late final TextEditingController _locationController;
  late final TextEditingController _noteController;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late String _selectedTag;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(
      text: widget.initialEntry?.subject ?? '',
    );
    _locationController = TextEditingController(
      text: widget.initialEntry?.location ?? 'Ruang kelas',
    );
    _noteController = TextEditingController(
      text: widget.initialEntry?.note ?? '',
    );
    _startTime =
        widget.initialEntry?.start ?? const TimeOfDay(hour: 7, minute: 0);
    _endTime = widget.initialEntry?.end ?? const TimeOfDay(hour: 8, minute: 0);
    _selectedTag = widget.initialEntry?.tag ?? scheduleTags.first;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isStart}) async {
    final result = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppPalette.primaryStrong,
                ),
          ),
          child: child!,
        );
      },
    );

    if (result == null) {
      return;
    }

    setState(() {
      if (isStart) {
        _startTime = result;
      } else {
        _endTime = result;
      }
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (timeInMinutes(_endTime) <= timeInMinutes(_startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jam selesai harus lebih besar dari jam mulai.'),
        ),
      );
      return;
    }

    final current = widget.initialEntry;

    Navigator.pop(
      context,
      ScheduleEntry(
        id: current?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        subject: _subjectController.text.trim(),
        start: _startTime,
        end: _endTime,
        location: _locationController.text.trim(),
        note: _noteController.text.trim().isEmpty
            ? 'Tidak ada catatan tambahan.'
            : _noteController.text.trim(),
        tag: _selectedTag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialEntry != null;

    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: ScreenSurface(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SimpleTopBar(
                    title: isEditing ? 'Edit Jadwal' : 'Tambah Jadwal',
                    subtitle: '${widget.day.name} - isi data jadwal',
                    onBack: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 18),
                  HeaderPanel(title: 'FORM JADWAL'),
                  const SizedBox(height: 14),
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
                          'Preview singkat',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppPalette.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: buildPanelDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TagPill(label: _selectedTag),
                              const SizedBox(height: 10),
                              Text(
                                _subjectController.text.trim().isEmpty
                                    ? 'Nama kegiatan'
                                    : _subjectController.text.trim(),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppPalette.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${formatTime(_startTime)} - ${formatTime(_endTime)} | ${widget.day.name}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppPalette.text,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _locationController.text.trim().isEmpty
                                    ? 'Tambahkan lokasi'
                                    : _locationController.text.trim(),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppPalette.subtleText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _subjectController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Mata pelajaran / kegiatan',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Isi nama kegiatan terlebih dulu.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TimeFieldButton(
                                label: 'Jam mulai',
                                value: formatTime(_startTime),
                                onTap: () => _pickTime(isStart: true),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TimeFieldButton(
                                label: 'Jam selesai',
                                value: formatTime(_endTime),
                                onTap: () => _pickTime(isStart: false),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _locationController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Lokasi',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Lokasi tidak boleh kosong.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: buildPanelDecoration(
                            color: AppPalette.surfaceSoft,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kategori',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppPalette.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: scheduleTags.map((tag) {
                                  final selected = tag == _selectedTag;
                                  return ChoiceChip(
                                    label: Text(tag),
                                    selected: selected,
                                    onSelected: (_) {
                                      setState(() {
                                        _selectedTag = tag;
                                      });
                                    },
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? AppPalette.primaryDark
                                          : AppPalette.subtleText,
                                    ),
                                    backgroundColor: AppPalette.surface,
                                    selectedColor: AppPalette.primarySoft,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: selected
                                            ? AppPalette.primaryStrong
                                            : AppPalette.line,
                                      ),
                                    ),
                                  );
                                }).toList(growable: false),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _noteController,
                          onChanged: (_) => setState(() {}),
                          minLines: 3,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Catatan',
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _save,
                            child: Text(
                              isEditing ? 'Simpan perubahan' : 'Tambah jadwal',
                            ),
                          ),
                        ),
                      ],
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
}
