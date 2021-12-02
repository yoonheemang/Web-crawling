##cmd창 열어서 입력
# cd C:\r_selenium
# java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445


sku<-read.table("C:/Users/user/Documents/카카오톡 받은 파일/상품코드.txt")
#install.packages('RSelenium')
#install.packages('dplyr')
#install.packages('rvest')

library(RSelenium)
#library(dplyr)
library(rvest)
remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445L,
      browserName = "chrome" ) #크롬에서 연결해서 열겠다

##########################################################################
remDr$open()
remDr$navigate("http://www.gs1kr.org/Service/Service/appl/01.asp")



#바코드검색

##for문 돌리기
webElemButton<-remDr$findElement(using="xpath",value='//*[@id="CODE"]')
webElemButton$clearElement()
webElemButton$sendKeysToElement(list('880111111000'))



#검색결과에서 클릭
gsButton<-remDr$findElement(using="xpath",value='//*[@id="skip-content"]/div/div/div[2]/div[3]/div[1]/div[1]/form/div/p[3]/a')
gsButton$clickElement() 


html<-read_html(remDr$getPageSource()[[1]])

man_name<-html_nodes(html,".row")

man2<-html_text(man_name[2])

kkk<-strsplit(man2,split = '업체명', fixed = TRUE)
kkk2<-gsub("\n","",gsub("영문","",kkk[[1]][2]))
kkk2


remDr$close()