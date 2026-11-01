# Car Showroom Sales Analysis Dashboard

Analisis end to end penjualan 10 cabang showroom mobil sepanjang 2025

**Dataset:** `showroom_mobil_10cabang_10k_data_awal.xlsx`
[Lihat file mentah](https://github.com/USERNAME/car-showroom-sales-dashboard/blob/main/data/showroom_mobil_10cabang_10k.xlsx) ·

**Isi:** [Pertanyaan](#pertanyaan) · [Proses](#proses) · [Dashboard](#dashboard) · [Project Insight](#project-insight)

---

## Pertanyaan

1. Berapa **total penjualan**, jumlah transaksi, dan persentase transaksi yang **completed**?
2. Bagaimana **tren penjualan bulanan** sepanjang 2025?
3. **Kategori mobil** mana yang paling besar kontribusinya?
4. **Cabang** mana yang penjualannya tertinggi, dan seberapa merata antar cabang?
5. Apa **lima produk** dengan penjualan tertinggi?
6. Bagaimana komposisi **metode pembayaran**, dan seberapa besar peran **trade-in**?
7. Berapa banyak transaksi **gagal** (cancelled dan refund), dan berapa nilainya?

---

## Proses

```
Data mentah (Excel)
   │
   ├─ 1. Mengolah data      ── Excel, Python, SQL
   └─ 2. Dashboard          ── Power BI
```

---

## Dashboard

<img width="1210" height="687" alt="Screenshot" src="https://github.com/user-attachments/assets/b36f8b42-5d4b-4a4e-ba1d-4043a6ee8b4e" />

_Dashboard Power BI: KPI penjualan dan transaksi, tren bulanan, penjualan per kategori, kota, dan produk, status transaksi, tipe pembelian, dan tabel detail, dengan slicer rentang waktu, kota, dan kategori._

**Cara membaca KPI**

| KPI | Arti | Nilai |
|---|---|---|
| Total Pendapatan | Jumlah `total_sales` dari **semua status**, termasuk cancelled dan refund | Rp3,09 T |
| Transaksi Completed | Jumlah transaksi berstatus completed | 8.966 |
| Total Transaksi | Jumlah seluruh transaksi | 10.000 |
| Persentase | Transaksi Completed ÷ Total Transaksi | 89,7% |

> **Catatan:** Total Pendapatan di atas belum memisahkan transaksi yang gagal. Penjualan dari transaksi completed saja adalah **Rp2,77 T**.

---

## Project Insight

1. **Penjualan 2025 mencapai Rp3,09 triliun dari 10.000 transaksi.** Dari jumlah itu, Rp2,77 triliun (89,5%) berasal dari transaksi completed. Transaksi cancelled (Rp169,9 miliar) dan refund (Rp154,6 miliar) bernilai total **Rp324,5 miliar, atau 10,5%** dari seluruh penjualan.
2. **SUV dan MPV mendominasi.** SUV menyumbang 54,3% (Rp1,68 T) dan MPV 32,2% (Rp1,00 T), sehingga keduanya 86,6% dari penjualan. Pickup 8,0%, City Car (EV) 3,2%, dan Hatchback 2,3%.
3. **Penjualan antar cabang sangat merata.** Dari Rp295 miliar (Karawang) sampai Rp325 miliar (Malang), selisih tertinggi dan terendah hanya sekitar 10%. Tidak ada cabang yang tertinggal jauh, jadi perbedaan hasil lebih ditentukan produk dan kategori daripada lokasi.
4. **Lima produk teratas menyumbang 41,9% penjualan.** Honda CR-V 1.5 Turbo RS memimpin dari sisi nilai (Rp299,6 miliar), diikuti Toyota Fortuner (Rp290,2 miliar), Mitsubishi Pajero Sport Dakar (Rp273,8 miliar), Isuzu D-Max (Rp246,2 miliar), dan Honda HR-V (Rp186,7 miliar). Dari sisi jumlah unit, HR-V justru terlaris (577 unit), karena harganya lebih rendah.
5. **Tren bulanan berfluktuasi tanpa pola musiman yang jelas.** Titik terendah Juni (Rp233 miliar) dan tertinggi Agustus (Rp276 miliar). Kuartal 3 paling kuat (Rp791 miliar), kuartal 1 paling lemah (Rp757 miliar).
6. **Kredit menopang penjualan.** Pembayaran Kredit saja 50,4% dari penjualan; bersama Kredit + Trade In menjadi 63,5%. Sebanyak 35,2% transaksi memakai trade-in, dengan nilai Rp579,3 miliar atau setara 18,7% dari total penjualan.
7. **Ada anomali pada trade-in.** 251 transaksi (2,5%) memiliki `total_sales` negatif karena nilai trade-in melebihi harga mobil baru (hingga 158% dari harga). Total efeknya −Rp8,08 miliar, dan 214 di antaranya berstatus completed. Perlu diverifikasi apakah ini penilaian trade-in yang wajar atau salah input.
8. **Tingkat transaksi gagal relatif seragam.** Completed 89,7%, cancelled 5,4%, dan refund 4,9%. Antar cabang, kategori, dan metode pembayaran, tingkat completed hanya berkisar 87,6–90,6%. Transaksi 3 unit lebih sering batal (9,9%), tetapi jumlahnya hanya 71 transaksi.
9. **Diskon hampir tidak berperan.** Hanya 318 transaksi (3,2%) yang mendapat potongan, semuanya Rp1 juta, total Rp318 juta atau sekitar 0,01% dari penjualan.

### Rekomendasi
- Pertahankan fokus stok dan promosi pada SUV dan MPV, karena keduanya menopang lebih dari 86% penjualan.
- Tinjau kebijakan penilaian trade-in, terutama untuk transaksi yang nilai trade-in-nya melebihi harga mobil baru.
- Selidiki penyebab cancelled dan refund, karena nilainya mencapai Rp324,5 miliar. Cabang dengan tingkat completed terendah (Jakarta dan Malang, sama-sama 88,7%) bisa menjadi titik awal.
- Pisahkan pendapatan completed dari total di dashboard agar angka penjualan tidak menyertakan transaksi yang gagal.
