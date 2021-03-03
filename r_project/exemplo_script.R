
install.packages("tidyverse")
library(tidyverse)

ny_1 <- read.csv("datasets/1minute_data_newyork/1minute_data_newyork.csv")

#filtrar dados de uma casa específica
d_1 <- ny_1[ny_1$dataid == 558,]

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
ggplot(data = d_1) + 
  geom_point(mapping = aes(x = hour, y = grid)) +
  geom_smooth(mapping = aes(x = hour, y = grid))


#comparar consumo médio ao longo do dia para duas casas, em que uma delas (Casa 2) tem paineis solares
d_2 <- ny_1[ny_1$dataid == 5997,]

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

consumo_agg <- aggregate(total_consumo ~ hour, data = d_2, FUN = "mean")
producao_agg <- aggregate(total_produzido ~ hour, data = d_2, FUN = "mean")
compara_prod_consumo <- data.frame(consumo_agg$hour, consumo_agg$total_consumo, producao_agg$total_produzido)
colnames(compara_prod_consumo) <- c("Hora", "Consumo", "Producao")


ggplot(compara_prod_consumo, aes(x=Hora)) + 
  geom_line(aes(y = Consumo), color = "darkred") + 
  geom_line(aes(y = Producao), color="darkgreen", linetype="twodash") 

