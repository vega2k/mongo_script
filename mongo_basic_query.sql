use my_db
show dbs
show collections
//select * from my_col where _id = 2
db.my_col.find({_id:2})
//select 배우이름, 생년월일 from my_col where _id = 2
db.my_col.find(
    {_id:2},
    {배우이름:1, 생년월일:1, _id:0}
)
db.my_col.insertOne(
    {
     "_id":2,
     "배우이름" : "유아인",
     "흥행지수" : 167829,
     "출연영화" : ["＃살아있다","버닝"],
     "랭킹" : "1",
     "다른 이름" : "엄홍식",
     "직업" : "배우",
     "생년월일" : "1986-10-06",
     "성별" : "남",
     "홈페이지" : "https://www.instagram.com/hongsick/https://twitter.com/seeksik",
     "신장/체중" : "178cm, 60kg",
     "학교" : "단국대학교 연극",
     "취미" : "피아노 연주, 인터넷 게임, 영화, 음악감상",
     "특기" : "스노우보드, 수영"
    }
)

db.my_col.isCapped()

db.cappedCollection.drop()

db.createCollection("cappedCollection", {capped:true, size:10000})
db.cappedCollection.isCapped()
db.cappedCollection.insertOne({x:1})

//db.cappedCollection.deleteMany({})

for( i=0; i < 1000; i++) {
    db.cappedCollection.insertOne({"x":i})
}

db.cappedCollection.find().count()
db.cappedCollection.find()
db.cappedCollection.stats()

db.createCollection("emp")
show collections

db.my_col.drop()

db.emp.stats()

use admin
db.runCommand({ "renameCollection": "my_db.emp", "to": "my_db.employees", "dropTarget": true })

use my_db

//1.employee_db 생성
//2.employees 컬렉션 생성
//3. employees 컬렉션 capped 확인
db.employees.isCapped()
//4. employees 컬렉션 statistics 확인
db.employees.stats()
//5.document 추가 insertMany() 사용
/*
  {"number":1001,"last_name":"Smith","first_name":"John","salary":62000,"department":"sales", hire_date:ISODate("2016-01-02")},
  {"number":1002,"last_name":"Anderson","first_name":"Jane","salary":57500,"department":"marketing", hire_date:ISODate("2013-11-09")},
  {"number":1003,"last_name":"Everest","first_name":"Brad","salary":71000,"department":"sales", hire_date:ISODate("2017-02-03")},
  {"number":1004,"last_name":"Horvath","first_name":"Jack","salary":42000,"department":"marketing", hire_date:ISODate("2017-06-01")},
*/
db.employees.insertMany([
  {"number":1001,"last_name":"Smith","first_name":"John","salary":62000,"department":"sales", hire_date:ISODate("2016-01-02")},
  {"number":1002,"last_name":"Anderson","first_name":"Jane","salary":57500,"department":"marketing", hire_date:ISODate("2013-11-09")},
  {"number":1003,"last_name":"Everest","first_name":"Brad","salary":71000,"department":"sales", hire_date:ISODate("2017-02-03")},
  {"number":1004,"last_name":"Horvath","first_name":"Jack","salary":42000,"department":"marketing", hire_date:ISODate("2017-06-01")},
])

//6.document select all
db.employees.find()
//7.SELECT * FROM employees WHERE department='sales';
db.employees.find({department:'sales'})
//8.select * from employees where hire_date >= "2017-01-01"
db.employees.find({
    hire_date:{
        $gte: ISODate("2017-01-01")
    }
})
//9.select number,last_name,first_name from employees
db.employees.find({},{number:1,last_name:true, first_name:1, _id:0})
//10.select number,last_name,first_name from employees where number=1003
db.employees.find({number:1003},{number:1,last_name:true, first_name:1, _id:0})
//11.select * from employees where number = 1001 and department = 'sales'
db.employees.find({number:1001, department:'sales'})
//12.select * from employees where number = 1002 or department = 'sales'
db.employees.find({
    $or:[{number:1002},{department:'sales'}]
})
//13.select * from employees where number in (1001,1003)
db.employees.find({
    number: {$in:[1001,1003]}
})
//14.select * from employees where number not in (1001,1003)
db.employees.find({
    number: {$nin:[1001,1003]}
})
//15.select * from employees where last_name like '%e%'
db.employees.find({last_name:/e/})
db.employees.find({last_name:{$regex:/e/}})
//15.1 select * from employees where last_name like '%e%' or department='sales'
db.employees.find({
    $or:[{last_name:{$regex:/e/}},{department:'sales'}]
})
//16.select * from employees where firs_name like 'J%'
db.employees.find({first_name:/^J/})
//17.select * from employees where first_name like 'B%'

//18.select * from employees where last_name like '%k'
db.employees.find({first_name:/k$/})
//19.select * from employees order by department
db.employees.find().sort({department:1})
//select * from employees order by number desc
db.employees.find().sort({number:-1})
//20.select * from employees order by hire_date desc
db.employees.find().sort({hire_date:-1})
//21.select count(*) from employees
db.employees.count()
db.employees.count({first_name:/^J/})
//22.db.employees.find().count() 않됨

//23.insertOne
//insert into employees (number,last_name,first_name,salary,department,status)
//values (1005,'Hong','Gildong',55000,'clerk','A')
//insert into employees (number,last_name,first_name,salary,department,status)
//values (1006,'박','둘리',50000,'clerk','B')
db.employees.insertOne({number:1005,last_name:"Hong",first_name:"Gildong",salary:55000,department:"clerk",status:"A"})
//24.select * from employees where status = 'A'
db.employees.insertOne({number:1006,last_name:"박",first_name:"둘리",salary:50000,department:"clerk",status:"A"})

db.employees.find()
//update employess set status = 'B' where number = 1005
db.employees.updateOne({number:1005},{$set:{status:"B"}})
//25.select * from employees where status in ('A','B)
db.employees.find({status:{$in:['A','B']}})
//26.status column이 존재하는 document 조회
db.employees.find({status:{$exists:true}})
//27.status column이 존재하지 않는 document 조회
db.employees.find({status:{$exists:false}})
//28.hire_date column이 존재하는 document 조회
db.employees.find({hire_date:{$exists:true}})
//29.hire_date column이 존재하지 않는 document 조회
db.employees.find({hire_date:{$exists:false}})

//30.status column이 존재하는 document count 조회
db.employees.count({status:{$exists:false}})
//31.hire_date column이 존재하는 document count 조회
db.employees.count({hire_date:{$exists:true}})
//32.select distinct(department) from employees
db.employees.aggregate([
    {$group:{_id:"$department"}}
])
//33.select * from employees where salary >= 50000
db.employees.find({salary:{$gte:50000}})
//34.select number,first_name, last_name, salary from emploees where salary < 50000
db.employees.find({salary:{$gt:50000}},{number:1,first_name:1,last_name:1,salary:1,_id:0})
//35.select number,first_name, last_name, salary, hire_date from employees where salary > 45000 and salary <= 60000
db.employees.find(
    {salary:{$gt:45000, $lte:60000}},
    {number:1,first_name:1,last_name:1,salary:1,_id:0, hire_date:1})
//36.update employees set salary = 57000 where number = 1005
db.employees.updateOne({number:1005},{$set:{salary:57000}})

//37.update employees set salary = salary - 500 where last_name like 'H%'
db.employees.updateMany({last_name:/H/},{$inc:{salary:-500}})
//38.update employees set salary = salary + 100 where number in (1005,1006)
db.employees.updateMany({number:{$in:[1005,1006]}},{$inc:{salary:100}})

//update() operation uses the $unset operator to remove the fields status and salary
//39. number가 1006 인 document의 status , salary  필드값 제거하기
db.employees.updateOne({number:1006},{$unset:{status:"", salary:0}})

//40.first_name이 둘리 인 document에 alias 라는 필드를 추가한다
db.employees.updateOne({first_name:"둘리"},{$set:{alias:"Dooly"}})

//41.delete from employees where alias = 'Dooly'
db.employees.deleteMany({alias:"Dooly"})

//students collection 생성
db.createCollection("students")
db.students.insertMany([
{
  "_id": 1,
  "alias": [ "The American Cincinnatus", "The American Fabius" ],
  "mobile": "555-555-5555",
  "nmae": { "first" : "george", "last" : "washington" }
},
{
  "_id": 2,
  "alias": [ "My dearest friend" ],
  "mobile": "222-222-2222",
  "nmae": { "first" : "abigail", "last" : "adams" }
},
{
  "_id": 3,
  "alias": [ "Amazing grace" ],
  "mobile": "111-111-1111",
  "nmae": { "first" : "grace", "last" : "hopper" }
}
])

db.students.updateMany( {}, { $rename: { "nmae": "name" } } )
db.students.updateOne( { _id: 1 }, { $rename: { "name.first": "name.fname" } } )
//wife 라는 필드명이 없으므로 아무일도 발생하지 않는다
db.students.updateOne( { _id: 1 }, { $rename: { 'wife': 'spouse' } } )
db.students.find()


//배열 데이터 처리
db.createCollection("developer")
db.developer.insertMany([
 {name:"Rohit", language:["C#","Python","Java"], personal:{age:25,semesterMarks:[70,73.3,76.5,78.6]}},

 {name:"Sumit", language:["Java","Perl","C#"], personal:{age:24,semesterMarks:[89,80.1,78,71]}}
])
db.developer.find()

