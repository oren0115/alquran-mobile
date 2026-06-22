class ShalatHarian {
  const ShalatHarian({
    required this.tanggal,
    required this.tanggalLengkap,
    required this.hari,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });

  final int tanggal;
  final String tanggalLengkap;
  final String hari;
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;

  factory ShalatHarian.fromJson(Map<String, dynamic> json) {
    return ShalatHarian(
      tanggal: json['tanggal'] as int,
      tanggalLengkap: json['tanggal_lengkap'] as String,
      hari: json['hari'] as String,
      imsak: json['imsak'] as String,
      subuh: json['subuh'] as String,
      terbit: json['terbit'] as String,
      dhuha: json['dhuha'] as String,
      dzuhur: json['dzuhur'] as String,
      ashar: json['ashar'] as String,
      maghrib: json['maghrib'] as String,
      isya: json['isya'] as String,
    );
  }

  List<({String name, String time})> get waktuSholat => [
        (name: 'Subuh', time: subuh),
        (name: 'Dzuhur', time: dzuhur),
        (name: 'Ashar', time: ashar),
        (name: 'Maghrib', time: maghrib),
        (name: 'Isya', time: isya),
      ];

  List<({String name, String time})> get waktuLengkap => [
        (name: 'Imsak', time: imsak),
        (name: 'Subuh', time: subuh),
        (name: 'Terbit', time: terbit),
        (name: 'Dhuha', time: dhuha),
        (name: 'Dzuhur', time: dzuhur),
        (name: 'Ashar', time: ashar),
        (name: 'Maghrib', time: maghrib),
        (name: 'Isya', time: isya),
      ];
}

class ShalatBulanan {
  const ShalatBulanan({
    required this.provinsi,
    required this.kabkota,
    required this.bulan,
    required this.tahun,
    required this.bulanNama,
    required this.jadwal,
  });

  final String provinsi;
  final String kabkota;
  final int bulan;
  final int tahun;
  final String bulanNama;
  final List<ShalatHarian> jadwal;

  factory ShalatBulanan.fromJson(Map<String, dynamic> json) {
    final list = json['jadwal'] as List<dynamic>;
    return ShalatBulanan(
      provinsi: json['provinsi'] as String,
      kabkota: json['kabkota'] as String,
      bulan: json['bulan'] as int,
      tahun: json['tahun'] as int,
      bulanNama: json['bulan_nama'] as String,
      jadwal: list
          .map((e) => ShalatHarian.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ShalatHarian? jadwalHariIni([DateTime? date]) {
    final now = date ?? DateTime.now();
    for (final item in jadwal) {
      if (item.tanggal == now.day) return item;
    }
    return null;
  }

  ShalatHarian? jadwalBesok([DateTime? date]) {
    final now = date ?? DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    for (final item in jadwal) {
      if (item.tanggal == tomorrow.day) return item;
    }
    return null;
  }
}

class NextPrayer {
  const NextPrayer({
    required this.name,
    required this.time,
    required this.remaining,
  });

  final String name;
  final String time;
  final Duration remaining;

  String get remainingLabel {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    if (hours > 0) return '${hours}j ${minutes}m';
    if (minutes > 0) return '${minutes}m';
    return 'Segera';
  }
}

class ShalatHelper {
  ShalatHelper._();

  static DateTime parseTime(String time, DateTime date) {
    final parts = time.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  static NextPrayer? hitungBerikutnya(
    ShalatHarian today,
    ShalatHarian? tomorrow, [
    DateTime? now,
  ]) {
    final current = now ?? DateTime.now();
    for (final prayer in today.waktuSholat) {
      final scheduled = parseTime(prayer.time, current);
      if (scheduled.isAfter(current)) {
        return NextPrayer(
          name: prayer.name,
          time: prayer.time,
          remaining: scheduled.difference(current),
        );
      }
    }

    if (tomorrow != null) {
      final scheduled = parseTime(
        tomorrow.subuh,
        DateTime(current.year, current.month, current.day + 1),
      );
      return NextPrayer(
        name: 'Subuh',
        time: tomorrow.subuh,
        remaining: scheduled.difference(current),
      );
    }

    return null;
  }
}
