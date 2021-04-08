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

db.orders.find()

//1. select count(*) as count from orders
db.orders.aggregate([
    {
        $group:{ _id: null, count: {$sum:1} }
    }
])
//2. select sum(price) as total from orders
db.orders.aggregate([
    {
        $group:{ _id:null, sum_price:{$sum:"$price"}}
    }
])
//3. select cust_id,sum(price) as total from orders group by cust_id
db.orders.aggregate([
    {
        $group:{_id:"$cust_id", total:{$sum:"$price"}}
    }
])
//4. select cust_id,sum(price) as total from orders group by cust_id order by total desc
db.orders.aggregate([
    {
        $group:{_id:"$cust_id", total:{$sum:"$price"}}
    },
    {
        $sort:{total:-1}
    }
])
//5. select cust_id,ord_date,sum(price) as total from orders group by cust_id,ord_date
db.orders.insertOne({
 cust_id: "abc456",
 ord_date: ISODate("2012-04-11T16:04:11.102Z"),
 status: 'C',
 price: 1000,
 items: [ { sku: "jkl", qty: 45, price: 2 },
 { sku: "abv", qty: 45, price: 3 } ]
 })

db.orders.aggregate([
    {
        $group:{_id:{cust_id:"$cust_id", order_date:{$dateToString:{format:"%Y-%m-%d",date:"$ord_date"}}},
                total:{$sum:"$price"}}
    },
    {
        $sort:{"_id.cust_id":1}
    }
])
db.orders.find()
//6. select cust_id,count(*) from orders group by cust_id having count(*) > 1
db.orders.aggregate([
    {$group:{_id:"$cust_id", count:{$sum:1}}},
    {$match:{count:{$gt:1}}}
])
//7. select status,count(*) from orders group by status having count(*) > 2
db.orders.aggregate([
    {
        $group:{
            _id: "$status",
            count: {$sum:1}
        }
    },
    {
        $match:{count: {$gt:2}}
    }
])

//8. select status,sum(price) as total from orders group by status
db.orders.aggregate([
    {
        $group:{_id:"$status", total:{$sum:"$price"}}
    }
])
//9. select cust_id,ord_date,sum(price) as total from orders group by cust_id,ord_date having total > 350
db.orders.aggregate([
    {
        $group:{_id:{cust_id:"$cust_id", order_date:{$dateToString:{format:"%Y-%m-%d",date:"$ord_date"}}},
                total:{$sum:"$price"}}
    },
    {
        $match:{total:{$gt:350}}
    },
    {
        $sort:{"_id.cust_id":1}
    }
])
//10. select cust_id,sum(price) as total from orders where status = 'B' group by cust_id order by cust_id
db.orders.aggregate([
    {$match:{status:"B"}},
    {$group:{_id:"$cust_id", total:{$sum:"$price"}}},
    {$sort:{_id:1}}
])
db.orders.find({status:"B"},{cust_id:1,price:1,status:1,_id:0})
//11. select cust_id,ord_date,sum(price) as total from orders where stauts ='B' group by
//cust_id,ord_date having total > 140
db.orders.insertOne({
 cust_id: "abc456",
 ord_date: ISODate("2012-04-20T16:04:11.102Z"),
 status: 'B',
 price: 2000,
 items: [ { sku: "jkl", qty: 45, price: 2 },
 { sku: "abv", qty: 45, price: 3 } ]
 })

db.orders.aggregate([
    {$match:{status:"B"}},
    {
        $group:{_id:{cust_id:"$cust_id", order_date:{$dateToString:{format:"%Y-%m-%d",date:"$ord_date"}}},
                total:{$sum:"$price"}}
    },
    {$match:{total:{$gt:140}}},
    {
        $sort:{"_id.order_date":1}
    }
])

//12. select cust_id, sum(li.qty) as qty from orders o, order_lineitem li where o_id = li.order_id
//group by cust_id
//$unwind 스테이지 사용


/*
13. select count(*)
 from (
 select cust_id,ord_date
 from orders
 group by cust_id,ord_date
 ) as d
*/
db.orders.aggregate([
    {
        $group:{
            _id:{cust_id:"$cust_id",
                 order_date:{$dateToString:{format:"%Y-%m-%d",date:"$ord_date"}}}
        }
    },
    {
        $group:{
            _id:null,
            count:{$sum:1}
        }
    }
])

db.orders.aggregate([
    {
        $group:{
            _id:{cust_id:"$cust_id",
                 order_date:{$dateToString:{format:"%Y-%m-%d",date:"$ord_date"}}},
             count:{$sum:1}
        }
    }
])