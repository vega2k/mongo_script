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