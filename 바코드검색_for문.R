#install.packages('RSelenium')
#install.packages('dplyr')
#install.packages('rvest')
#install.packages("readxl")
#install.packages("xlsx")

##cmd창 열어서 입력
# cd C:\r_selenium
# java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445

library(RSelenium)
library(dplyr)
library(rvest)
library(readxl)
library(xlsx)

remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445L,
      browserName = "chrome" ) #크롬에서 연결해서 열겠다

file=read_excel("C:/Users/a/Desktop/file.xlsx",sheet=1,col_names=T)[1]
file2=file%>%filter(nchar(유통상품코드)==13,substr(유통상품코드,1,3)=="880") #880으로 시작하는 13자리코드

code=as.vector(file2[[1]])

##############################################################################
remDr$open()

geo_code=function(code,n=length(code)){
  	url='http://www.gs1kr.org/Service/Service/appl/01.asp'
  	remDr$navigate(url)
  	search=NULL
	data=NULL
	for(i in 1:length(code)){
		search<-remDr$findElement(using="xpath",value='//*[@id="CODE"]')
    		search$clearElement()
    		search$sendKeysToElement(list(code[i]))
		gsButton<-remDr$findElement(using="xpath",value='//*[@id="skip-content"]/div/div/div[2]/div[3]/div[1]/div[1]/form/div/p[3]/a')
		gsButton$clickElement() 

		html<-read_html(remDr$getPageSource()[[1]])
		man<-html_text(html_nodes(html,".row")[2])
		kkk<-strsplit(man,split = '업체명', fixed = TRUE) 
		kkk2<-gsub("\n","",gsub("영문","",kkk[[1]][2])) #결과값 없을경우 NA
  	 	data=rbind(data,data.frame(code=code[i],name=kkk2))
  	}
  	return(data)
}

a=geo_code(code)
remDr$close()
#a


write.xlsx(a,file="C:/Users/a/Desktop/result.xlsx") #엑셀파일로 저장

#만들어진 엑셀파일을 작업파일에 vlookup을 이용해서 붙이면 된다!
