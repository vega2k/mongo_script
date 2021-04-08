//Aggregation (집계)
use my_db

db.createCollection("orders")
db.orders.insertMany([
{
 cust_id: "abc123",
 ord_date: ISODate("2012-01-02T17:04:11.102Z"),
 status: 'A',
 price: 100,
 items: [ { sku: "xxx", qty: 25, price: 1 },
 { sku: "yyy", qty: 25, price: 1 } ]
 },
 {
 cust_id: "abc123",
 ord_date: ISODate("2012-01-02T17:04:11.102Z"),
 status: 'A',
 price: 500,
 items: [ { sku: "xxx", qty: 25, price: 1 },
 { sku: "yyy", qty: 25, price: 1 } ]
 },
 {
 cust_id: "abc123",
 ord_date: ISODate("2012-01-02T17:04:11.102Z"),
 status: 'B',
 price: 130,
 items: [ { sku: "jkl", qty: 35, price: 2 },
 { sku: "abv", qty: 35, price: 1 } ]
 },
 {
 cust_id: "abc123",
 ord_date: ISODate("2012-01-02T17:04:11.102Z"),
 status: 'B',
 price: 230,
 items: [ { sku: "jkl", qty: 25, price: 2 },
 { sku: "abv", qty: 25, price: 1 } ]
 },
 {
 cust_id: "abc123",
 ord_date: ISODate("2012-01-02T17:04:11.102Z"),
 status: 'A',
 price: 130,
 items: [ { sku: "xxx", qty: 15, price: 1 },
 { sku: "yyy", qty: 15, price: 1 } ]
 },
 {
 cust_id: "abc456",
 ord_date: ISODate("2012-02-02T17:04:11.102Z"),
 status: 'C',
 price: 70,
 items: [ { sku: "jkl", qty: 45, price: 2 },
 { sku: "abv", qty: 45, price: 3 } ]
 },
 {
 cust_id: "abc456",
 ord_date: ISODate("2012-02-02T17:04:11.102Z"),
 status: 'A',
 price: 150,
 items: [ { sku: "xxx", qty: 35, price: 4 },
 { sku: "yyy", qty: 35, price: 5 } ]
 },
 {
 cust_id: "abc456",
 ord_date: ISODate("2012-02-02T17:04:11.102Z"),
 status: 'B',
 price: 20,
 items: [ { sku: "jkl", qty: 45, price: 2 },
 { sku: "abv", qty: 45, price: 1 } ]
 },
 {
 cust_id: "abc456",
 ord_date: ISODate("2012-02-02T17:04:11.102Z"),
 status: 'B',
 price: 120,
 items: [ { sku: "jkl", qty: 45, price: 2 },
 { sku: "abv", qty: 45, price: 1 } ]
 },
 {
 cust_id: "abc780",
 ord_date: ISODate("2012-02-02T17:04:11.102Z"),
 status: 'B',
 price: 260,
 items: [ { sku: "jkl", qty: 50, price: 2 },
 { sku: "abv", qty: 35, price: 1 } ]
 }
])

db.orders.count()

//1. select count(*) as count from orders

//2. select sum(price) as total from orders

//3. select cust_id,sum(price) as total from orders group by cust_id

//4. select cust_id,sum(price) as total from orders group by cust_id order by total desc

//5. select cust_id,ord_date,sum(price) as total from orders group by cust_id,ord_date

//6. select cust_id,count(*) from orders group by cust_id having count(*) > 1

//7. select status,count(*) from orders group by status having count(*) > 1페이지 33 | 37

//8. select status,sum(price) as total from orders group by status

//9. select cust_id,ord_date,sum(price) as total from orders group by cust_id,ord_date having
//total > 250

//10. select cust_id,sum(price) as total from orders where status = 'B' group by cust_id

//11. select cust_id,ord_date,sum(price) as total from orders where stauts ='B' group by
//cust_id,ord_date having total > 250

//12. select cust_id, sum(li.qty) as qty from orders o, order_lineitem li where o_id = li.order_id
//group by cust_id
/*
13. select count(*)
 from (
 select cust_id,ord_date
 from orders
 group by cust_id,ord_date
 ) as d
*/
