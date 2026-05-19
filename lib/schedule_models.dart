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

const Duration defaultReminderLeadTime = Duration(minutes: 5);

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
  'Pekerjaan',
  'Rutin',
  'Sosial',
  'Hiburan',
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
        subject: 'Olahraga Pagi',
        start: TimeOfDay(hour: 6, minute: 0),
        end: TimeOfDay(hour: 7, minute: 0),
        location: 'Taman Komplek',
        note: 'Lari pagi 3km.',
        tag: 'Rutin',
      ),
      const ScheduleEntry(
        id: 'senin-2',
        subject: 'Meeting Mingguan',
        start: TimeOfDay(hour: 10, minute: 0),
        end: TimeOfDay(hour: 11, minute: 0),
        location: 'Kantor / Zoom',
        note: 'Bahas target minggu ini.',
        tag: 'Pekerjaan',
      ),
    ],
    'Selasa': <ScheduleEntry>[
      const ScheduleEntry(
        id: 'selasa-1',
        subject: 'Belanja Bulanan',
        start: TimeOfDay(hour: 16, minute: 0),
        end: TimeOfDay(hour: 17, minute: 30),
        location: 'Supermarket',
        note: 'Beli kebutuhan dapur dan sabun.',
        tag: 'Rutin',
      ),
      const ScheduleEntry(
        id: 'selasa-2',
        subject: 'Makan Malam Bersama',
        start: TimeOfDay(hour: 19, minute: 0),
        end: TimeOfDay(hour: 20, minute: 30),
        location: 'Restoran',
        note: 'Makan bareng teman lama.',
        tag: 'Sosial',
      ),
    ],
    'Rabu': <ScheduleEntry>[
      const ScheduleEntry(
        id: 'rabu-1',
        subject: 'Selesaikan Laporan',
        start: TimeOfDay(hour: 9, minute: 0),
        end: TimeOfDay(hour: 12, minute: 0),
        location: 'Meja Kerja',
        note: 'Kirim laporan akhir bulan ke bos.',
        tag: 'Pekerjaan',
      ),
    ],
    'Kamis': <ScheduleEntry>[],
    'Jumat': <ScheduleEntry>[
      const ScheduleEntry(
        id: 'jumat-1',
        subject: 'Nonton Film',
        start: TimeOfDay(hour: 20, minute: 0),
        end: TimeOfDay(hour: 22, minute: 30),
        location: 'Ruang TV',
        note: 'Nonton serial Netflix terbaru.',
        tag: 'Hiburan',
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

int notificationIdForEntry(ScheduleEntry entry) =>
    entry.id.hashCode.abs() % 100000;

int startNotificationIdForEntry(ScheduleEntry entry) =>
    notificationIdForEntry(entry) + 100000;

int weekdayFromName(String name) {
  const map = <String, int>{
    'Senin': DateTime.monday,
    'Selasa': DateTime.tuesday,
    'Rabu': DateTime.wednesday,
    'Kamis': DateTime.thursday,
    'Jumat': DateTime.friday,
    'Sabtu': DateTime.saturday,
    'Minggu': DateTime.sunday,
  };

  return map[name] ?? DateTime.monday;
}

DateTime nextScheduleDateTimeForDay({
  required String dayName,
  required TimeOfDay time,
  DateTime? from,
}) {
  final now = from ?? DateTime.now();
  var daysUntilTarget = (weekdayFromName(dayName) - now.weekday) % 7;

  if (daysUntilTarget == 0) {
    final sameDayTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (!sameDayTime.isAfter(now)) {
      daysUntilTarget = 7;
    }
  }

  final targetDate = now.add(Duration(days: daysUntilTarget));
  return DateTime(
    targetDate.year,
    targetDate.month,
    targetDate.day,
    time.hour,
    time.minute,
  );
}

DateTime reminderDateTimeForEntry({
  required String dayName,
  required TimeOfDay start,
  Duration leadTime = defaultReminderLeadTime,
  DateTime? from,
}) {
  return nextScheduleDateTimeForDay(
    dayName: dayName,
    time: start,
    from: from,
  ).subtract(leadTime);
}

Color tagColor(String tag) {
  switch (tag) {
    case 'Rutin':
      return AppPalette.warning;
    case 'Sosial':
      return AppPalette.success;
    case 'Hiburan':
      return const Color(0xFF8B8BE0);
    default:
      return AppPalette.primary;
  }
}

String currentDateLabel() {
  final now = DateTime.now();
  return formatCalendarDate(now);
}

String formatCalendarDate(DateTime date) {
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

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String weekdayName(int weekday) {
  const weekNames = <String>[
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  return weekNames[weekday - 1];
}

String formatReminderDateTime(DateTime value) {
  final time = TimeOfDay.fromDateTime(value);
  return '${weekdayName(value.weekday)}, ${formatCalendarDate(value)} pukul ${formatTime(time)}';
}
