# Ender 3 V2 — Start & End G-code

Ender 3 V2 için baskı başlangıcını ve bitişini düzenleyen iki G-code betiği. Başlangıçta kayıtlı mesh etkinleştirilir, tabla/nozul ısıtılır ve iki temizleme çizgisi basılır. Bitişte geri çekme, park etme, sesli bildirim, tabla soğumasını bekleme ve ışık kapatma sırası uygulanır.

## Dosyalar

| Dosya | Dilimleyicideki alan |
|---|---|
| `start.gcode` | Start G-code / Başlangıç G-code |
| `end.gcode` | End G-code / Bitiş G-code |

## Cura’da kullanım

1. Kullanılan Ender 3 V2 yazıcı profilinin makine ayarlarını açın.
2. `start.gcode` içeriğini başlangıç, `end.gcode` içeriğini bitiş G-code alanına yerleştirin.
3. Yazıcının tabla ölçülerini ve ekstrüzyon modunu kontrol edin.
4. Modeli dilimleyin ve üretilen dosyada sıcaklık/tabla değişkenlerinin sayısal değerlere dönüştüğünü doğrulayın.

Dosyalarda Cura biçimindeki şu değişkenler bulunur:

| Değişken | Anlam |
|---|---|
| `{material_bed_temperature_layer_0}` | İlk katman tabla sıcaklığı |
| `{material_print_temperature_layer_0}` | İlk katman nozul sıcaklığı |
| `{machine_depth}` | Park konumu için Y ekseni derinliği |

Başka bir dilimleyicide bunları ilgili profilin değişken sözdizimine uyarlamak gerekir. Dosyalar yer tutucularıyla birlikte doğrudan yazıcıya gönderilecek bağımsız baskı dosyaları değildir.

## Başlangıç sırası

1. `M355 S1 P255` ile kasa ışığını açar.
2. Ekstrüder konumunu sıfırlar ve `G28` ile eksenleri home eder.
3. `M420 S1 Z2` ile kayıtlı mesh’i etkinleştirir; fade yüksekliğini 2 mm olarak ayarlar. Yeni bir mesh ölçümü yapılmaz.
4. Z’yi 5 mm’ye kaldırır, tabla/nozul hedeflerini ayarlar ve hedeflere ulaşılmasını bekler.
5. X=0.1 ve X=0.4 üzerinde Y=20–200 arasında, Z=0.3 yüksekliğinde iki hazırlık çizgisi çizer.
6. Ekstrüderi yeniden sıfırlar ve baskıya geçiş konumuna gelir.

## Bitiş sırası

1. `G91` ile göreli harekete geçer; iki geri çekme komutu, kısa temizleme hareketi ve Z yükseltme uygular.
2. `G90` ile mutlak harekete döner; X=0, Y=tabla derinliği konumunda baskıyı öne sunar.
3. `M84 X Y E` ile X/Y/E motorlarını serbest bırakır; Z motorunu bu komutla kapatmaz.
4. Üç kısa ses üretir ve `M190 R40` ile tablanın 40 °C hedefine ulaşmasını bekler.
5. Uzun sesin ardından kasa ışığını, fanı, hotend’i ve tabla ısıtıcısını kapatır.

**Sıralama ayrıntısı:** `M104 S0` ve `M106 S0`, tabla bekleme komutundan sonradır. Bu nedenle mevcut betikte hotend ve fan, tabla bekleyişi bitmeden kapatılmaz. `M190 R40` yalnızca gecikme değil, 40 °C hedefiyle sıcaklık bekleme komutudur.

## Profil uyumu

- `M355` için firmware’de kasa ışığı, `M300` için uygun ses desteği gerekir.
- `M420` için geçerli bir kayıtlı mesh ve firmware’de mesh leveling desteği bulunmalıdır.
- Başlangıç çizgileri Y=200’e gider; park hareketi profilin `machine_depth` değerine bağlıdır. Bu konumlar fiziksel hareket alanı içinde olmalıdır.
- Başlangıç betiği `G90`, `M82` veya `M83` seçmez. E15/E30 hazırlık çizgileri, dilimleyicinin ekstrüzyon modu ile birlikte değerlendirilmelidir.
- Bitişin göreli Z yükseltmeleri, yüksek baskılarda eksenin üst sınırını aşmamalıdır.

## Uyarlama noktaları

Temizleme çizgisinin konumları/hızı `G1` satırlarında, mesh fade yüksekliği `M420` satırında, bitişte beklenen sıcaklık `M190 R40` satırında ve seslerin frekans/süreleri `M300` satırlarında düzenlenebilir.
