-- 1. Jumlah Reservasi Per Kelas Kamar
SELECT 
rc.name AS room_class, 
COUNT(*) AS total_reservations
FROM 
reservation res
INNER JOIN 
room_information r ON res.room_ID = r.room_ID
INNER JOIN 
room_class rc ON r.class_ID = rc.class_ID
GROUP BY 
rc.name
ORDER BY 
total_reservations DESC;

-- 2. Pendapatan Per Kelas Kamar
SELECT 
rc.name AS room_class, 
SUM(r.price) AS total_revenue
FROM 
transactions t
INNER JOIN 
reservation res ON t.reservation_ID = res.reservation_ID
INNER JOIN 
room_information r ON res.room_ID = r.room_ID
INNER JOIN 
room_class rc ON r.class_ID = rc.class_ID
GROUP BY 
rc.name
ORDER BY 
total_revenue DESC;

-- 3. Laporan Berdasarkan Transaksi
SELECT 
t.transaction_name, 
COUNT(r.report_ID) AS total_reports
FROM 
reports r
LEFT JOIN 
transactions t ON r.transaction_ID = t.transaction_ID
GROUP BY 
t.transaction_name
ORDER BY 
total_reports DESC;

-- 4. Jumlah Total Reservasi dan Total Pendapatan Per Kelas Kamar
SELECT 
    rc.name AS room_class,
    COUNT(res.reservation_ID) AS total_reservations,
    SUM(r.price) AS total_revenue
FROM 
    room_class rc
LEFT JOIN 
    room_information r ON rc.class_ID = r.class_ID
LEFT JOIN 
    reservation res ON r.room_ID = res.room_ID
GROUP BY 
    rc.name
ORDER BY 
    total_reservations DESC;

-- 5. Pelanggan yang Melakukan Reservasi Terbanyak
SELECT 
cust_ID, 
custfname, 
custlname, 
total_reservations
FROM 
( SELECT 
    c.cust_ID, 
    c.custfname, 
    c.custlname, 
    COUNT(res.reservation_ID) AS total_reservations
  FROM 
    customer_information c
  LEFT JOIN 
    reservation res ON c.cust_ID = res.customer_ID
 GROUP BY 
    c.cust_ID, c.custfname, c.custlname) AS subquery
ORDER BY 
    total_reservations DESC;

-- 6. Karyawan dengan Pendapatan Tertinggi dari Transaksi
SELECT 
e.employee_ID, 
e.fname, 
e.lname, 
total_revenue
FROM 
( SELECT 
    t.employee_ID, 
    SUM(r.price) AS total_revenue
  FROM 
    transactions t
  INNER JOIN 
    reservation res ON t.reservation_ID = res.reservation_ID
  INNER JOIN 
    room_information r ON res.room_ID = r.room_ID
  GROUP BY 
    t.employee_ID) AS subquery
LEFT JOIN 
 employees e ON subquery.employee_ID = e.employee_ID
ORDER BY 
 total_revenue DESC;

-- 7.  Jumlah Reservasi dan Pendapatan per Pelanggan
SELECT 
  rc.name AS room_class,
  (SELECT 
    COUNT(res.reservation_ID)
   FROM 
     reservation res
   LEFT JOIN 
     room_information r ON res.room_ID = r.room_ID
   WHERE 
     r.class_ID = rc.class_ID) AS total_reservations,
  (SELECT 
     SUM(r.price)
   FROM 
     room_information r
   LEFT JOIN 
     reservation res ON r.room_ID = res.room_ID
   WHERE 
     r.class_ID = rc.class_ID) AS total_revenue
FROM 
    room_class rc
ORDER BY 
    total_reservations DESC;

-- 8. Pendapatan Berdasarkan Kelas Kamar dengan Kategori Pendapatan
SELECT 
rc.name AS room_class,
SUM(r.price) AS total_revenue,
CASE
	WHEN SUM(r.price) < 1000000 THEN 'Low'
    WHEN SUM(r.price) BETWEEN 1000000 AND 5000000 THEN 'Medium'
    ELSE 'High'
END AS revenue_category
FROM 
room_class rc
INNER JOIN 
room_information r ON rc.class_ID = r.class_ID
INNER JOIN 
reservation res ON r.room_ID = res.room_ID
GROUP BY 
rc.name
ORDER BY 
total_revenue DESC;

-- 9. Kategori Lama Menginap Tamu
SELECT 
customer_ID,
custfname,
custlname,
(date_out - date_in) AS stay_duration,
CASE
	WHEN (date_out - date_in) < INTERVAL '3 days' THEN 'Short Stay'
    WHEN (date_out - date_in) BETWEEN INTERVAL '3 days' AND INTERVAL '7 days' THEN 'Medium Stay'
    ELSE 'Long Stay'
END AS stay_category
FROM 
reservation
LEFT JOIN 
customer_information ci ON reservation.customer_ID = ci.cust_ID
WHERE 
date_out IS NOT NULL AND date_in IS NOT NULL;

-- 10. Kategori Pendapatan Karyawan Berdasarkan Transaksi
SELECT 
e.employee_ID,
e.fname,
e.lname,
SUM(r.price) AS total_revenue,
CASE
	WHEN SUM(r.price) < 1000000 THEN 'Low'
    WHEN SUM(r.price) BETWEEN 1000000 AND 5000000 THEN 'Medium'
    ELSE 'High'
END AS revenue_category
FROM 
employees e
INNER JOIN 
transactions t ON e.employee_ID = t.employee_ID
INNER JOIN 
reservation res ON t.reservation_ID = res.reservation_ID
INNER JOIN 
room_information r ON res.room_ID = r.room_ID
GROUP BY 
e.employee_ID, e.fname, e.lname
ORDER BY 
total_revenue DESC;

-- 11. Kategori Pembayaran Berdasarkan Tanggal Pembayaran
SELECT 
payment_ID,
customer_ID,
payment_date,
CASE
	WHEN payment_date < CURRENT_DATE THEN 'Early'
    WHEN payment_date = CURRENT_DATE THEN 'On Time'
    ELSE 'Late'
END AS payment_status
FROM 
payments;