#1 filter nama pelanggan unik
select distinct customer_name
from showroom.data10cabang;

#2 rekap transaksi kredit
select sales_date, order_id, customer_name, branch, total_sales
from showroom.data10cabang
where payment_type = 'Kredit'
order by sales_date asc;

#3 pembelian quantity terbanyak
select customer_name, sum(quantity) as quantity
from showroom.data10cabang
group by customer_name
order by quantity desc
limit 5;

#4 model mobil hitam metalik
select sales_date, order_id, customer_name, product_name, color, total_sales
from showroom.data10cabang
where color = 'Hitam Metalik'
order by total_sales desc;

#5 komposisi metode
select payment_type, count(payment_type) jumlah_transaksi
from showroom.data10cabang
group by payment_type
order by jumlah_transaksi desc;

#6 evaluasi margin
select category, avg(discount) as ratarata_diskon
from showroom.data10cabang
group by category
order by ratarata_diskon desc;

#7 filter pendapatan
select branch, sum(total_sales) as total_pendapatan
from showroom.data10cabang
group by branch
having sum(total_sales) > 50000000000
order by total_pendapatan desc;

#8 investigasi diskon
select order_id, product_name, discount
from showroom.data10cabang
where discount > (
  select avg(discount) from showroom.data10cabang
)
order by discount desc;

#9 pendapatan kategori
select category, avg(total_sales) as ratarata_pendapatan
from (
    select *
    from showroom.data10cabang
    where status = 'completed'
) as completed
group by category
order by ratarata_pendapatan desc;

#10 model mobil terbaik
with jumlah_per_model as (
  select product_name, count(*) as jumlah_transaksi
  from showroom.data10cabang
  group by product_name
)
select *
from jumlah_per_model
order by jumlah_transaksi desc
limit 3;
