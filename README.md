# AnimalHome

使用 「臺北市開放認養動物」Open data 在UITableView 顯示API回傳的內容，API每次撈取30
筆資料，使用者往下滾動時會撈取下一頁(30筆)。

Table view cell 顯示
-  Name
-  Variety
-  Note  (cell 大小需要依據文字 動態調整高度 ) 
-  ImageName

API:
http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f4a75ba9-7721-4363-884d-c3820b0b917c&offset=303&limit=30

使用語言: Objective-C
