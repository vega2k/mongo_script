
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
    db.cappedCollection.insertOne({x:i})
}

db.cappedCollection.find().count()
db.cappedCollection.find()
db.cappedCollection.stats()






