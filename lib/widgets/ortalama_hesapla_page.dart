import 'package:flutter/material.dart';
import 'package:flutter_dinamik_not/constants/app_constants.dart';
import 'package:flutter_dinamik_not/helper/data_helper.dart';
import 'package:flutter_dinamik_not/model/ders.dart';
import 'package:flutter_dinamik_not/widgets/ders_listesi.dart';
import 'package:flutter_dinamik_not/widgets/harf_dropdown_widget.dart';
import 'package:flutter_dinamik_not/widgets/kredi_dropdown_widget.dart';
import 'package:flutter_dinamik_not/widgets/ortalama_goster.dart';
import 'package:google_fonts/google_fonts.dart';

class OrtalamaHesaplaPage extends StatefulWidget {
  OrtalamaHesaplaPage({Key? key}) : super(key: key);

  @override
  _OrtalamaHesaplaPageState createState() => _OrtalamaHesaplaPageState();
}

class _OrtalamaHesaplaPageState extends State<OrtalamaHesaplaPage> {
  var formKey = GlobalKey<FormState>();
  double secilenHarfDegeri = 4;
  double secilenKrediDegeri = 1;
  String girilenDersAdi = '';

  @override
  Widget build(BuildContext context) {
    print('Scaffold build tetiklendi');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(Sabitler.baslikText, style: Sabitler.baslikStyle),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildForm(),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: OrtalamaGoster(
                      ortalama: DataHelper.ortalamaHesapla(),
                      dersSayisi: DataHelper.tumeklenenDersler.length),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: DersListesi(
              onElemanCikarildi: (index) {
                setState(() {
                  DataHelper.tumeklenenDersler.removeAt(index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: Sabitler.yatayPadding8,
            child: _builderTextFormField(),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Padding(
                padding: Sabitler.yatayPadding8,
                child: HarfDropdownWidget(
                  onHarfSecildi: (harf) {
                    secilenHarfDegeri = harf;
                  },
                ),
              )),
              Expanded(
                  child: Padding(
                      padding: Sabitler.yatayPadding8,
                      child: KrediDropdownWidget(
                        onKrediCikarilan: (kredi) {
                          secilenKrediDegeri = kredi;
                        },
                      ))),
              IconButton(
                  onPressed: _dersEkleveOrtalamaHesapla,
                  icon: Icon(Icons.arrow_forward_ios_outlined)),
            ],
          )
        ],
      ),
    );
  }

  Widget _builderTextFormField() {
    return TextFormField(
        onSaved: (deger) {
          setState(() {
            girilenDersAdi = deger!;
          });
        },
        validator: (s) {
          if (s!.length <= 0) {
            return 'Ders Adini Giriniz!';
          } else
            return null;
        },
        decoration: InputDecoration(
          hintText: 'Ders adınızı giriniz',
          border: OutlineInputBorder(
              borderRadius: Sabitler.borderRadius, borderSide: BorderSide.none),
          filled: true,
          fillColor: Sabitler.anaRenk.shade100.withOpacity(0.2),
        ));
  }

  _dersEkleveOrtalamaHesapla() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var eklenecekDers = Ders(
          ad: girilenDersAdi,
          harfDegeri: secilenHarfDegeri,
          krediDegeri: secilenKrediDegeri);
      DataHelper.dersEkle(eklenecekDers);
      setState(() {});
    }
  }
}
