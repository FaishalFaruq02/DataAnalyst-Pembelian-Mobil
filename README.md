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

### Kamus data

| Kolom | Arti |
|---|---|
| `sales_date` | Tanggal transaksi (tersimpan sebagai teks) |
| `order_id` | ID transaksi (`TRX00001`, dst.) |
| `customer_name` | Kode pelanggan (`Customer_913`) |
| `branch` | Cabang / kota showroom |
| `product_name`, `category`, `color` | Produk, kategori (SUV, MPV, Hatchback, Pickup, City Car EV), dan warna |
| `price`, `quantity` | Harga per unit dan jumlah unit (1–3) |
| `payment_type` | Kredit, Cash, Kredit + Trade In, Cash + Trade In |
| `trade_in`, `discount` | Nilai trade-in dan potongan diskon |
| `total` | `price × quantity` |
| `total_sales` | `total − trade_in − discount` |
| `status` | `completed`, `cancelled`, atau `refund` |
| `branch_address` | Alamat cabang |
| `date_clean` | Kolom bantu: `sales_date` yang sudah diubah menjadi tipe tanggal |
| `trade_in_quantity` | Kolom bantu: 1 jika transaksi memakai trade-in, 0 jika tidak |

### 1. Validasi data (Excel)

| Pemeriksaan | Hasil |
|---|---|
| `order_id` duplikat | 0 |
| Nilai kosong pada kolom data | 0 |
| `total` = `price × quantity` | Cocok di 100% baris |
| `total_sales` = `total − trade_in − discount` | Cocok di 100% baris |
| Satu cabang = satu alamat | Konsisten |
| Satu produk = satu kategori dan satu harga | Konsisten |
| Rentang tanggal | 1 Jan – 31 Des 2025, tanpa tanggal yang gagal dibaca |

Satu temuan yang perlu dicatat: **251 transaksi memiliki `total_sales` negatif** (total −Rp8,08 miliar). Semuanya memakai trade-in, dan nilai trade-in-nya lebih besar daripada harga mobil baru. Baris ini tetap dipakai dan dibahas di [Project Insight](#project-insight).

### 2. Transform (Excel)

| Langkah | Contoh rumus |
|---|---|
| Ubah `sales_date` dari teks menjadi tanggal (`date_clean`) | `=DATEVALUE(A2)` |
| Tandai transaksi yang memakai trade-in (`trade_in_quantity`) | `=IF(K2>0,1,0)` |
| Pivot table untuk angka pembanding: `total_sales` per status, cabang, dan kategori; persentase trade-in per cabang | `Insert` → `PivotTable` |

_Huruf kolom pada rumus hanyalah contoh; sesuaikan dengan sheet Anda._

### 3. Dashboard (Power BI)

Sumber data: `Sheet1` dari file Excel, memakai `date_clean` sebagai sumbu waktu.

Contoh measure DAX untuk empat kartu KPI:

```DAX
Total Pendapatan = SUM(Sheet1[total_sales])

Transaksi Completed =
CALCULATE(COUNTROWS(Sheet1), Sheet1[status] = "completed")

Total Transaksi = COUNTROWS(Sheet1)

Persentase = DIVIDE([Transaksi Completed], [Total Transaksi])
```

| Visual | Field |
|---|---|
| 4 kartu KPI | Total Pendapatan, Transaksi Completed, Total Transaksi, Persentase |
| Tren Penjualan (garis) | Bulan dari `date_clean` × `total_sales` |
| Total Penjualan per Kategori (bar) | `category` × `total_sales` |
| Total Penjualan per Kota (kolom) | `branch` × `total_sales` |
| 5 Produk Tertinggi (kolom) | `product_name` × `total_sales`, filter Top 5 |
| Status (pie) | `status` × `total_sales` |
| Type Pembelian (donat) | `payment_type` × `total_sales` |
| Tabel detail transaksi | `order_id`, kota, produk, kategori, tipe pembayaran, trade-in, diskon, total sales, status |
| Slicer | Rentang waktu, Kota, Kategori |

---

## Dashboard

![Dashboard penjualan showroom mobil](dashboard/screenshot.png)

_Dashboard Power BI: KPI penjualan dan transaksi, tren bulanan, penjualan per kategori, kota, dan produk, status transaksi, tipe pembelian, dan tabel detail, dengan slicer rentang waktu, kota, dan kategori._

**Cara membaca KPI**

| KPI | Arti | Nilai |
|---|---|---|
| Total Pendapatan | Jumlah `total_sales` dari **semua status**, termasuk cancelled dan refund | Rp3,09 T |
| Transaksi Completed | Jumlah transaksi berstatus completed | 8.966 |
| Total Transaksi | Jumlah seluruh transaksi | 10.000 |
| Persentase | Transaksi Completed ÷ Total Transaksi | 89,7% |

> **Catatan:** Total Pendapatan di atas belum memisahkan transaksi yang gagal. Penjualan dari transaksi completed saja adalah **Rp2,77 T**.

- **File Power BI:** [`dashboard/showroom-sales.pbix`](dashboard/showroom-sales.pbix)
- **Versi online (opsional):** _[tempel link Power BI Service di sini bila sudah dipublikasikan]_

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

### Keterbatasan
- Data hanya mencakup **satu tahun (2025)**, jadi pola musiman dan pertumbuhan tahunan belum bisa dipastikan.
- Tidak ada data biaya atau margin, sehingga **keuntungan tidak bisa dihitung**.
- Tidak ada kolom alasan cancelled atau refund, sehingga penyebabnya tidak bisa dianalisis.
- `customer_name` berupa kode pelanggan, bukan identitas sebenarnya.
- Perbedaan antar cabang dan metode pembayaran kecil; baca sebagai kecenderungan, bukan sebab-akibat.

---

## Struktur repo

```
car-showroom-sales-dashboard/
├── data/
│   └── showroom_mobil_10cabang_10k.xlsx
├── dashboard/
│   ├── showroom-sales.pbix
│   └── screenshot.png
└── README.md
```

**Tools:** Microsoft Excel (validasi, kolom bantu, pivot table) · Power BI (DAX)
