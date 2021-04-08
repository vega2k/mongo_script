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
db.orders.find()
db.orders.count()
db.orders.aggregate([
    {
        $unwind:"$items"
    },
    {
        $group:{
            _id:"$cust_id",
            item_qty:{$sum:"$items.qty"}
        }
    }
])

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

//items collection 생성
db.createCollection("items")
db.items.insertMany([
{ "_id" : 1, "item" : "abc", "price" : 10, "quantity" : 2, "date" : ISODate("2014-01-01T08:00:00Z"),"sizes": [ "S", "M"] },
{ "_id" : 2, "item" : "jkl", "price" : 20, "quantity" : 1, "date" : ISODate("2014-02-03T09:00:00Z"),"sizes": [ "S"] },
{ "_id" : 3, "item" : "xyz", "price" : 5, "quantity" : 5, "date" : ISODate("2014-02-03T09:05:00Z"),"sizes": [ "S", "M","L"] },
{ "_id" : 4, "item" : "abc", "price" : 10, "quantity" : 10, "date" : ISODate("2014-02-15T08:00:00Z"),"sizes": [ "S", "M","L"] },
{ "_id" : 5, "item" : "xyz", "price" : 5, "quantity" : 10, "date" : ISODate("2014-02-15T09:05:00Z"),"sizes": [ "S", "M","L","XL"] },
{ "_id" : 6, "item" : "xyz", "price" : 5, "quantity" : 5, "date" : ISODate("2014-02-15T12:05:10Z"),"sizes": [ "S", "M","L"] },
{ "_id" : 7, "item" : "xyz", "price" : 5, "quantity" : 10, "date" : ISODate("2014-02-15T14:12:12Z"),"sizes": [ "S", "M","L","XL"] }
])
db.items.find()

db.items.aggregate([
 {
     $group:{
         _id: { year:{$year:"$date"},
                month:{$month:"$date"},
                day:{$dayOfMonth:"$date"}
              },
         totalPrice: {$sum:{$multiply:["$price","$quantity"]}},
         avgQuantity: {$avg:"$quantity"},
         count: {$sum:1}
     }
 }
])
//$first
db.items.aggregate(
 [
     {
         $group:
         {
            _id: "$item",
            firstSalesDate: { $first: "$date" }
         }
     },
     {
        $sort: { item: 1, date: 1 }
     }
 ]
)
//$last
db.items.aggregate(
 [
     {
         $group:
         {
            _id: "$item",
            firstSalesDate: { $last: "$date" }
         }
     },
     {
        $sort: { item: 1, date: 1 }
     }
 ]
)
//$min
db.items.aggregate(
 [
     {
         $group:
         {
            _id: "$item",
            min_quantity: { $min: "$quantity" }
         }
     },
     {
        $sort: { item: 1, quantity: 1 }
     }
 ]
)

//$unwind stage
db.items.aggregate([
 {
    $unwind:"$sizes"
 }
])

db.items.aggregate([
     {
        $unwind:"$sizes"
     },
     {
        $group:
        {
            _id: "$sizes",
            countSizes: {$sum:1},
        }
     }
])

//1. area : 광역시도별 건수 - $group, $sort
//2. area: 광역시도별 인구수의 합계 ( 인구수 250 만 보다 크고, 많은 순서대로 정렬) - $group, $match, $sort
//3. local : 광역시도별 인건비의 평균 지출 비용 ( 소수점이하 버림, 큰 순서대로 정렬)- $match, $group, $project, $sort
//4. city_or_province : 자치단체별로 총 사용한 운영비와,세부항목별로 총 사용한 운영비를 같이 출력한다. - $facet, $group 스테이지
//5. city_or_province : 자치단체를 랜덤하게 두곳을 골라서 올해 가장 많이 사용한 운영비 세부항목을 출력한다 - $group, $sort, $sample
