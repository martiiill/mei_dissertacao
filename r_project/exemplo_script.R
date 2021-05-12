#libs
install.packages("tidyverse")
install.packages("suncalc")
install.packages("Holidays")
install.packages("chron")
install.packages("hydroTSM")
install.packages("reshape")

library(tidyverse)
library(lubridate)
library(suncalc)
library(Holidays)
library(timeDate)
library(chron)
library(ggplot2)
library(hydroTSM)
library(reshape)
library(rjson)
library(rvest)
library(plyr)
library(dplyr)

# utils
gc()

#My DataSet
newyork <- read.csv("1minute_data_newyork.csv")

#Metadata
metadata <- read.csv("metadata.csv")

#Casas com paines solares
subset_homes_with_solar <- subset(newyork, solar > 0 | solar2 > 0)
#ds_homes_with_solar<- data.frame(subset_homes_with_solar)
nrow(subset_homes_with_solar)

#Casas sem paines solares
homes_with_no_solar <- subset(newyork, is.na(solar) & is.na(solar2))
#ds_homes_with_no_solar<- data.frame(homes_with_no_solar)
nrow(homes_with_no_solar)
#Conclusão: Existem mais casas sem painés solares.

#Dia de trabalho?
date <- as.character(newyork$localminute)
date <- as.POSIXct(date, format="%Y-%m-%d")
consumo_data <- aggregate(grid ~ date, data = newyork, FUN="mean")

ggplot(consumo_data, aes(date, grid, color=weekdays(date) %in% c("saturday","sunday")))
+geom_point() +
  ggtitle('Consumo energético') +
  xlab('Data') +
  ylab('Consumo') + 
  scale_color_discrete(name="É Fim de Semana?") 
+geom_line()
#é sempre segunda-feira? Hum.... estranho. Pode-se dizer que o consumo aumentou a partir de Out. Regreso á rotina?

#É feriado?
hlist <- c("USChristmasDay","USGoodFriday","USIndependenceDay","USLaborDay","USNewYearsDay","USThanksgivingDay")       
myholidays  <- dates(as.character(holiday(2000:2020,hlist)),format="Y-M-D")

ggplot(consumo_data, aes(date, grid, color=is.holiday(date,myholidays)))
+geom_point()
+ ggtitle('Consumo energético') +
  xlab('Data') +
  ylab('Consumo') + 
  scale_color_discrete(name="É Feriado?") 
#O ser feriado ou não é irrelevante, neste caso. Existem apenas 2 feriados  neste dataset.

#Tempo de sol no dia 
sunlight_times <- getSunlightTimes(date = as.Date(newyork$localminute, format="%Y-%m-%d"), keep = c("sunrise",  "sunset"), lat = 40.7128, lon = 74.0060, tz = "UTC") #For coordinates of New York
newyork$horas_Sol <- difftime(sunlight_times$sunset, sunlight_times$sunrise, units="hours")

#Que estação do ano é?
newyork$estacao_ano <- time2season(as.Date(newyork$localminute, format="%Y-%m-%d"), out.fmt = "seasons", type="default")

#Qual a estação do ano que se gasta mais e que se gasta menos?
newyork$total_consumo <- rowSums(newyork[ , c(3:31,33:67,77)], na.rm=TRUE)
consumo_p_estacao_ano <- aggregate(newyork$total_consumo ~ estacao_ano, data = newyork, FUN = "sum")
consumo_p_estacao_ano
#A estação que se gasta mais é o Verão. A estação que se gasta menos é a Primavera.

#Variáveis importantes: Mês do Ano
newyork$mes <- format(as.Date(newyork$localminute, format = "%Y-%m-%d") , "%B")     


#Dados Meteorologicos
history_data <- read.csv("history_data.csv")

for (row in 1:nrow(newyork)) 
{
  my_date <- as.Date(newyork[row, c(2)], format="%d/%m/%Y")
  
  print(my_date)
  
  #Se existem dados meteorologicos
  if(is.element(my_date,unlist(history_data)))
  {
      #obter dados
  }
  
  #month <- as.Date( newyork[row, c(2)], format="%m")
  #day <- as.Date( newyork[row, c(2)], format="%d")

  # create formatted url with desired dates
  #url <- sprintf('https://www.timeanddate.com/scripts/cityajax.php?n=usa/newyork&mode=historic&hd=%4d%02d%02d&month=%d&year=%4d&json=1', year, month, day, month, year)
  
  
  #webpage <- read_html(url) %>% html_text()
  
  # json string is not formatted the way from JSON function needs so I had to parse it manually
  
  # split string on each row
  #x <- strsplit(webpage, "\\{c:")[[1]]
  # remove first element (garbage)
  #x <- x[2:length(x)]
  # clean last 2 characters in each row
  #x <- sapply(x, FUN=function(xx){substr(xx[1], 1, nchar(xx[1])-2)}, USE.NAMES = FALSE)
  
  # function to get actual data in each row and put it into a dataframe
  
  #parse.row <- function(row.string) {
    # parse columns using '},{' as divider
   # a <- strsplit(row.string, '\\},\\{')[[1]]
    # remove some lefover characters from parsing
    #a <- gsub('\\[\\{|\\}\\]', '', a)
    # remove what I think is metadata
    #a <- gsub('h:', '', gsub('s:.*,', '', a))
    
    #df <- data.frame(time=a[1], temp=a[3], weather=a[4], wind=a[5], humidity=a[7],
     #                barometer=a[8])
    
    #return(df)
  #}
  
  # use ldply to run function parse.row for each element of x and combine the results in a single dataframe
  #df.final <- ldply(x, parse.row)
}



#head(df.final)
#############################################################################################################

#filtrar dados de uma casa específica
d_1 <- dataset_pecan_street[dataset_pecan_street$dataid == 558,]

#como se relaciona o consumo do ar condicionado 1 com a energia consumida?
ggplot(data = d_1) + 
 geom_point(mapping = aes(x = air1, y = grid))

#qual a correlação entre estas variáveis?
cor(d_1$air1, d_1$grid)

#Consumo médio da casa ao longo do dia
d_1$date <- as.character(d_1$localminute)
d_1$date <- as.POSIXct(d_1$date, format="%Y-%m-%d %H:%M:%S")
d_1$hour <- as.numeric(format(d_1$date, format = "%H"))
consumo_hora1 <- aggregate(grid ~ hour, data = d_1, FUN="mean")

ggplot(data=consumo_hora1, aes(x=hour, y=grid, group = 1)) +
 geom_line()+
 geom_point()


#Distribuição do consumo ao longo do dia
#ggplot(data = d_1) + 
 # geom_point(mapping = aes(x = hour, y = grid)) +
  #geom_smooth(mapping = aes(x = hour, y = grid))


#comparar consumo médio ao longo do dia para duas casas, em que uma delas (Casa 2) tem paineis solares
d_2 <- newyork[newyork$dataid == 5997,]

d_2$date <- as.character(d_2$localminute)
d_2$date <- as.POSIXct(d_2$date, format="%Y-%m-%d %H:%M:%S")
d_2$hour <- as.numeric(format(d_2$date, format = "%H"))
consumo_hora2 <- aggregate(grid ~ hour, data = d_2, FUN="mean")
consumo_hora2$casa <- "Casa 2"

compara_consumo <- consumo_hora1
compara_consumo$casa <- "Casa 1"
compara_consumo <- rbind(compara_consumo, consumo_hora2)
compara_consumo$consumo <- compara_consumo$grid
compara_consumo$grid <- NULL

ggplot(data=compara_consumo, aes(x=hour, y=consumo, group=casa)) +
  geom_line(aes(linetype = casa, color = casa))+
  geom_point()


#Para uma casa com painel solar, mostrar quanta energia é consumida e quanta é produzida ao longo do dia
d_2$total_consumo <- rowSums(d_2[,c(3:31,33:67,77)])
d_2$total_produzido <- d_2$solar + d_2$solar2

consumo_agg <- aggregate(d_2$total_consumo ~ hour, data = d_2, FUN = "mean")
producao_agg <- aggregate(total_produzido ~ hour, data = d_2, FUN = "mean")
compara_prod_consumo <- data.frame(consumo_agg$hour, consumo_agg$total_consumo, producao_agg$total_produzido)
colnames(compara_prod_consumo) <- c("Hora", "Consumo", "Producao")

ggplot(compara_prod_consumo, aes(x=Hora)) + 
  geom_line(aes(y = Consumo), color = "darkred") + 
  geom_line(aes(y = Producao), color="darkgreen", linetype="twodash") 

