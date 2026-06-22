class Doa {
  const Doa({
    required this.id,
    required this.grup,
    required this.nama,
    required this.ar,
    required this.tr,
    required this.idn,
    required this.tentang,
    required this.tags,
  });

  final int id;
  final String grup;
  final String nama;
  final String ar;
  final String tr;
  final String idn;
  final String tentang;
  final List<String> tags;

  factory Doa.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tag'];
    return Doa(
      id: json['id'] as int,
      grup: json['grup'] as String,
      nama: json['nama'] as String,
      ar: json['ar'] as String,
      tr: json['tr'] as String,
      idn: json['idn'] as String,
      tentang: json['tentang'] as String,
      tags: rawTags is List
          ? rawTags.map((e) => e.toString()).toList()
          : const [],
    );
  }
}
