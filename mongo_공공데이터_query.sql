db.area.count()
db.area.find()

db.by_month.count()
db.by_month.find({},{month_data:1, _id:0})

db.by_road_type.count()
db.by_road_type.find()

db.by_type.count()
db.by_type.find()
db.by_type.aggregate([
    {$group:{_id:"$type"}}
])

//1. by_road_type : 강릉시(county 값) 교차로 내에서 일어난 총 사고 숫자를 출력한다.
db.by_road_type.find({county:"강릉시"})
db.by_road_type.find({county:"강릉시"},{"교차로내.accident_count":1})
db.by_road_type.find({county:"강릉시"},{"교차로내.accident_count":1, _id:0, city_or_province:1, county:1})
//2. by_road_type : 전국의 도로 종류 중에 “기타단일로” 에서 사망자수가 0 인 지역을 출력한다.
db.by_road_type.find({"기타단일로.death_toll":0},{_id:0, city_or_province:1, county:1, 기타단일로:1})
//3. by_type : 전국의 “차대차” 사고에서 100 회 이상 사고가 발생하였지만, 사망자 수가 0 회인 지역을 출력한다.
db.by_type.find(
    {type:"차대차", accident_count:{$gte:100}, death_toll:0},
    {_id:0, city_or_province:1, county:1}
)
//4. by_type : 전국의 “차대사람” 사고에서 사망자수가 0 회 이거나 중상자수가 0 회인 지역을 출력한다.
db.by_type.find(
    {type:"차대사람", $or:[{death_toll:0},{heavy_injury:0}]},
    {_id:0, city_or_province:1, county:1}
)
//5. area : 행정구역명이 시 라는 이름으로 끝나는 지역의 수를 출력한다.
db.area.find({county:/시$/},{_id:0}).sort({county:1})
db.area.find({county:/시$/},{_id:0}).count()

//6. area : 행정구역명이 군 이면서 인구수가 10 만 이상인 곳을 출력한다.인구순서대로 ASC
db.area.find(
    {county:/군$/, population:{$gte:100000}},
    {_id:0}
).sort({population:-1})
//6.1 area : 행정구역명이 시 이면서 인구수가 10 만 이상인 곳을 출력한다. 인구순서대로 DESC
db.area.find(
    {county:/시$/, population:{$gte:100000}},
    {_id:0}
).sort({population:-1})

//7. area : 행정구역명이 구 이면서, 이름의 첫 글자 초성이 “ㅇ” 인 행정구역명을 출력한다.
db.area.find(
    {county:{ $regex:/구$/, $gte:"아", $lt:"자"}},
    {_id:0}
)
//8. by_month : 서울시에서 한달에 200 회 이상 교통사고가 발생한 지역의 행정구역명을 출력한다.
db.by_month.find()
db.by_month.find(
    {city_or_province:"서울", "month_data.accident_count":{$gte:200}},
    {_id:0, county:1,}
)

db.by_month.find(
    {city_or_province:"서울", "month_data.accident_count":{$gte:200}},
    {_id:0, county:1,"month_data.month":1}
)
//9. by_month : 1 월에 중상자 수가 0 명이고, 2 월에 사망자 수가 0 명인 광역단체명과 행정구역명을 출력한다.
db.by_month.find({},{_id:0,month_data:1})
//$elemMatch
db.by_month.find(
    {$and:[
        {month_data:{$elemMatch:{month:"01월",heavy_injury:0}}},
        {month_data:{$elemMatch:{month:"02월",death_toll:0}}}
        ]},
    {_id:0, city_or_province:1, county:1}
)
//10. by_road_type : 전국의 도로 종류 중 “기타단일로” 에서 사망자수가 0 인 광역단체명,행정구역명, 기타단일로의 사망자수를 출력한다.
db.by_road_type.find(
    {"기타단일로.death_toll":0},
    {_id:0, city_or_province:1, county:1, "기타단일로.death_toll":1}
)
//11. by_moth : 행정구역명이 구로 끝나고, 행정구역명의 첫글자 초성이 “ㅇ” 인 document 를
//찾아서 광역단체명, 행정구역명, 매월 사고 횟수가 150 회 이상인 월을 출력한다.
//11. by_moth : 행정구역명이 구로 끝나고, 행정구역명의 첫글자 초성이 “ㅇ” 인 document 를
//  --- criteria
//찾아서 광역단체명, 행정구역명, 매월 사고 횟수가 150 회 이상인 월을 출력한다.
//  --- projection
db.by_month.find(
    {county:{ $regex:/구$/, $gte:"아", $lt:"자"}},
    {
        month_data:{$elemMatch:{accident_count:{$gte:150}}},
        city_or_province:1, county:1, "month_data.month":1
    }
  )

db.by_month.find({county:"은평구"},{month_data:1})
//12. by_month : 서울시에서 한달에 200 회 이상 사고가 발생한 document 를 찾고, 200 회
//이상 사고가 발생한 월의 정보가 한달치만(month_data.$) 출력되어야 한다. month_data, 행정구역명을 출력한다.
db.by_month.find(
    {city_or_province:"서울", "month_data.accident_count":{$gte:200}},
    {"month_data.$":1, county:1 }
)