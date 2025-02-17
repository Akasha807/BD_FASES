/* *****************************************************
  INSTITUT TIC de Barcelona
    CFGS DAM 1 B
    Mòdul: 0484 Bases de dades. 
    AUTORS:Akasha Karam
    DATA: 18/2/25
****************************************************** */


-- problema 1
select nom,ICAO from companyia 
where pais ="Spain"; 

-- problema 2
-- Dudas sobre el boeing
select  num_serie,fabricant,any_fabricacio as any ,companyia 
from avio where fabricant not like 'Boeing' 
and any_fabricacio >= 2020 
order by any_fabricacio,fabricant,num_serie;

-- problema 3
select (concat('L''aeroport ', nom, ' està a ', ciutat, ' i va ser construït l’any ', any_construccio)) 
as aeroport from aeroport  
where  pais='Spain' order by nom;


-- problema 4
select nom,pais, char_length(nom) as longitud
from aeroport where char_length(nom)>= 7 and char_length(nom) <=9 
and nom like '%e%e%e%' order by  char_length(nom),pais;

-- Pregunta 5
select num_serie from avio where (fabricant like 'Concorde%' 
or companyia  like 'Alitalia%') and any_fabricacio = 2008 order by num_serie;

-- Pregunta 6
-- Me sale todo empty
select concat(cognom + ', ' + nom) as nom_complet
from passatger 
where (nom like '%k%k%' or cognom like '%k%k%')
and passaport like 'barcelona' 
order by cognom asc;

-- Pregunta 7
select distinct fabricant from avio where any_fabricacio = 2000 order by fabricant;

-- Pregunta 8
-- Como que no sabemos como esta escrito tenemos que por year,month and dia. 
select 
    cognom,nom,
    date_format(data_naix,'%d/%m/%Y (%W)') as naixament
from passatger
where 
    year(data_naix) = 2003 
    and month(data_naix) = 10 
    and nom not like '%a%'
order by
    data_naix desc, 
    cognom asc;

-- Pregunta 9
-- Restamos el año que nacio por el año actua

select nom,cognom,telefon,data_naix 
from passatger
where year(curdate()) - year(data_naix) = 54 and 55
and telefon % 2 = 1
and adreca is null 
order by data_naix,nom;

