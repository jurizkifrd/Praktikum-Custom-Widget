import 'dart:math';
import 'package:flutter/material.dart';

class Captcha extends StatefulWidget {
  double lebar, tinggi;
  int jumlahTitikMaks = 10;

  var stokWarna = {
    'merah': Color(0xa9ec1c1c),
    'hijau': Color(0xa922b900),
    'hitam': Color(0xa9000000),
  };
  var warnaTerpakai = {};
  String warnaYangDitanyakan = 'merah';

  Captcha(this.lebar, this.tinggi);

  @override
  State<StatefulWidget> createState() => _CaptchaState();
}

class _CaptchaState extends State<Captcha> {
  var random = Random();
  TextEditingController jawabanController = TextEditingController();
  bool isAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    buatPertanyaan();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: widget.lebar,
            height: widget.tinggi,
            child: CustomPaint(
              painter: isAnswerCorrect ? BenarPainter() : CaptchaPainter(widget),
            ),
          ),
          SizedBox(height: 16),
          Text(
            isAnswerCorrect ? 'BENAR!' : 'Berapa jumlah titik warna ${widget.warnaYangDitanyakan}?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, height: 2),
          ),
          SizedBox(height: 16),
          TextField(
            controller: jawabanController,
            keyboardType: TextInputType.number,
            enabled: !isAnswerCorrect,
            decoration: InputDecoration(
              labelText: 'Jawaban',
            ),
          ),
          ElevatedButton(
            onPressed: isAnswerCorrect ? null : periksaJawaban,
            child: Text('Jawab'),
          ),
        ],
      ),
    );
  }

  void buatPertanyaan() {
    setState(() {
      widget.warnaYangDitanyakan = widget.stokWarna.keys.elementAt(random.nextInt(3));
    });
  }

  void periksaJawaban() {
    int jawabanPengguna = int.tryParse(jawabanController.text) ?? -1;

    if (jawabanPengguna == widget.warnaTerpakai[widget.warnaYangDitanyakan]) {
      setState(() {
        isAnswerCorrect = true;
      });
    } else {
      setState(() {
        isAnswerCorrect = false;
        buatPertanyaan();
      });
    }
  }
}

class CaptchaPainter extends CustomPainter {
  Captcha captcha;
  var random = Random();

  CaptchaPainter(this.captcha);

  @override
  void paint(Canvas canvas, Size size) {
    var catBingkai = Paint()
      ..color = Color(0xFF000000)
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Offset(0, 0) & Size(captcha.lebar, captcha.tinggi), catBingkai);

    captcha.stokWarna.forEach((key, value) {
      var jumlah = random.nextInt(captcha.jumlahTitikMaks + 1);
      if (jumlah == 0) jumlah = 1;
      captcha.warnaTerpakai[key] = jumlah;

      for (var i = 0; i < jumlah; i++) {
        var catTitik = Paint()
          ..color = value
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(
            random.nextDouble() * captcha.lebar,
            random.nextDouble() * captcha.tinggi),
            6, catTitik);
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BenarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Offset(0, 0) & size, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'BENAR!',
        style: TextStyle(
          color: Colors.green,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
