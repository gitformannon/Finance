// ✅ Nima uchun bu yaxshiroq?
// Yaxshiroq (short)
// Semantik yo‘q — faqat raqam	Mazmunli — short nima degani aniq
// 200 ni eslab qolish kerak	short degani quick delay degan ma'noni beradi
// Katta loyihada chalkashlik bo‘ladi	Oson tushuniladi va maintain qilinadi

class TimeDelays {
  // Milliseconds
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 500);

  // Seconds
  static const Duration oneSecond = Duration(seconds: 1);
  static const Duration twoSeconds = Duration(seconds: 2);
  static const Duration threeSeconds = Duration(seconds: 3);
}