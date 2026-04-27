import 'package:flutter/material.dart';

import 'app_style.dart';

class DayInfo {
  const DayInfo({
    required this.name,
    required this.motto,
    required this.icon,
  });

  final String name;
  final String motto;
  final IconData icon;
}

class ScheduleEntry {
  const ScheduleEntry({
    required this.id,
    required this.subject,
    required this.start,
    required this.end,
    required this.location,
    required this.note,
    required this.tag,
  });

  final String id;
  final String subject;
  final TimeOfDay start;
  final TimeOfDay end;
  final String location;
  final String note;
  final String tag;
}

enum AgendaBoardMode { view, edit, delete }

class BoardLabel {
  const BoardLabel({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;
}

const List<String> scheduleTags = <String>[
  'Pelajaran',
  'Tugas',
  'Praktik',
  'Organisasi',
];

const List<DayInfo> weekDays = <DayInfo>[
  DayInfo(
    name: 'Senin',
    motto: 'Awal minggu untuk mulai fokus.',
    icon: Icons.wb_sunny_rounded,
  ),
  DayInfo(
    name: 'Selasa',
    motto: 'Jaga ritme belajar tetap konsisten.',
    icon: Icons.auto_graph_rounded,
  ),
  DayInfo(
    name: 'Rabu',
    motto: 'Pertengahan minggu, tetap stabil.',
    icon: Icons.local_cafe_rounded,
  ),
  DayInfo(
    name: 'Kamis',
    motto: 'Waktunya menyusun progres dengan rapi.',
    icon: Icons.layers_rounded,
  ),
  DayInfo(
    name: 'Jumat',
    motto: 'Beri ruang untuk refleksi dan review.',
    icon: Icons.favorite_rounded,
  ),
  DayInfo(
    name: 'Sabtu',
    motto: 'Hari yang fleksibel untuk latihan.',
    icon: Icons.sports_esports_rounded,
  ),
  DayInfo(
    name: 'Minggu',
    motto: 'Atur ulang energi untuk minggu berikutnya.',
    icon: Icons.nightlight_round,
  ),
];

const Map<AgendaBoardMode, BoardLabel> boardLabels =
    <AgendaBoardMode, BoardLabel>{
  AgendaBoardMode.view: BoardLabel(
    title: 'Lihat Jadwal',
    subtitle: 'cek dan buka detail agenda',
    actionLabel: 'Lihat detail',
    emptyIcon: Icons.event_busy_rounded,
    emptyTitle: 'Belum ada jadwal',
    emptyMessage:
        'Halaman ini masih kosong. Tambah agenda dulu supaya jadwal bisa langsung dipantau.',
  ),
  AgendaBoardMode.edit: BoardLabel(
    title: 'Edit Jadwal',
    subtitle: 'pilih agenda yang ingin diubah',
    actionLabel: 'Tap untuk edit',
    emptyIcon: Icons.edit_off_rounded,
    emptyTitle: 'Tidak ada yang bisa diedit',
    emptyMessage:
        'Belum ada agenda untuk diperbarui. Tambah jadwal lebih dulu dari menu sebelumnya.',
  ),
  AgendaBoardMode.delete: BoardLabel(
    title: 'Hapus Jadwal',
    subtitle: 'pilih agenda yang ingin dihapus',
    actionLabel: 'Tap untuk hapus',
    emptyIcon: Icons.delete_sweep_rounded,
    emptyTitle: 'Tidak ada yang bisa dihapus',
    emptyMessage:
        'Daftar agenda masih kosong, jadi belum ada item yang bisa dihapus saat ini.',
  ),
};

Map<String, List<ScheduleEntry>> buildInitialSchedules() {
  return <String, List<ScheduleEntry>>{
    'Senin': <ScheduleEntry>[
      const ScheduleEntry(
        id: 'senin-1',
        subject: 'Matematika',
        start: TimeOfDay(hour: 7, minute: 0),
        end: TimeOfDay(hour: 8, minute: 30),
        location: 'Ruang 2A',
        note: 'Fokus latihan aljabar dan bawa buku paket.',
        tag: 'Pelajaran',
      ),
      const ScheduleEntry(
        id: 'senin-2',
        subject: 'Diskusi Kelompok',
        start: TimeOfDay(hour: 10, minute: 0),
        end: TimeOfDay(hour: 11, minute: 0),
        location: 'Perpustakaan',
        note: 'Bahas presentasi proyek akhir.',
        tag: 'Organisasi',
      ),
    ],
    'Selasa': <ScheduleEntry>[
      const ScheduleEntry(
        id: 'selasa-1',
        subject: 'Bahasa Indonesia',
        start: TimeOfDay(hour: 8, minute: 0),
        end: TimeOfDay(hour: 9, minute: 30),
        location: 'Ruang 1C',
        note: 'Presentasi cerpen dan siapkan outline.',
        tag: 'Pelajaran',
      ),
      const ScheduleEntry(
        id: 'selasa-2',
        subject: 'Latihan Soal',
        start: TimeOfDay(hour: 13, minute: 0),
        end: TimeOfDay(hour: 14, minute: 0),
        location: 'Rumah',
        note: 'Kerjakan 10 soal untuk persiapan kuis.',
        tag: 'Tugas',
      ),
    ],
    'Rabu': <ScheduleEntry>[
      const ScheduleEntry(
        id: 'rabu-1',
        subject: 'Praktikum IPA',
        start: TimeOfDay(hour: 9, minute: 0),
        end: TimeOfDay(hour: 11, minute: 0),
        location: 'Lab IPA',
        note: 'Gunakan jas lab dan catat hasil pengamatan.',
        tag: 'Praktik',
      ),
    ],
    'Kamis': <ScheduleEntry>[],
    'Jumat': <ScheduleEntry>[
      const ScheduleEntry(
        id: 'jumat-1',
        subject: 'Review Mingguan',
        start: TimeOfDay(hour: 7, minute: 30),
        end: TimeOfDay(hour: 8, minute: 15),
        location: 'Kelas utama',
        note: 'Ringkas materi seminggu terakhir.',
        tag: 'Tugas',
      ),
    ],
    'Sabtu': <ScheduleEntry>[],
    'Minggu': <ScheduleEntry>[],
  };
}

List<ScheduleEntry> sortedEntries(Iterable<ScheduleEntry> entries) {
  final sorted = List<ScheduleEntry>.from(entries);
  sorted.sort(
    (left, right) =>
        timeInMinutes(left.start).compareTo(timeInMinutes(right.start)),
  );
  return sorted;
}

String formatTimeRange(ScheduleEntry entry) {
  return '${formatTime(entry.start)} - ${formatTime(entry.end)}';
}

String formatTime(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

int timeInMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

Color tagColor(String tag) {
  switch (tag) {
    case 'Tugas':
      return AppPalette.warning;
    case 'Praktik':
      return AppPalette.success;
    case 'Organisasi':
      return const Color(0xFF8B8BE0);
    default:
      return AppPalette.primary;
  }
}

String currentDateLabel() {
  final now = DateTime.now();
  const months = <String>[
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  return '${now.day} ${months[now.month - 1]} ${now.year}';
}
