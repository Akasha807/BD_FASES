/* *****************************************************
  INSTITUT TIC de Barcelona
    CFGS DAM 
    Mòdul: 0484 Bases de dades. 
    AUTORS: Akasha Karam
    DATA: 17/3/25
****************************************************** */

-- Pregunta 1
-- Mostra la ciutat(ciutat), el nom de l’aeroport origen (aeroport_origen/vol) 
-- i la data i el codi dels vols (data,codi/vol)
-- que tinguin una durada inferior a 40 minuts i que siguin del mes de febrer del 2024
-- i que hagin estat endarrerits (descripcio/Vol/delayed). Ordena els resultats per la ciutat
-- i per la data.

-- 19 rows
SELECT 
    aeroport.ciutat,
    aeroport.nom AS aeroport_origen,
    vol.data,
    vol.codi
FROM vol, aeroport
WHERE aeroport.codi = vol.aeroport_origen
AND vol.durada < 40 
AND EXTRACT(MONTH FROM vol.data) = 2 
AND EXTRACT(YEAR FROM vol.data) = 2024
AND vol.descripcio = 'delayed'
ORDER BY aeroport.ciutat, vol.data;

-- Pregunta 2
-- 59 rows
SELECT avio.any_fabricacio AS any, 
       companyia.nom AS companyia, 
       avio.num_serie, 
       avio.tipus
FROM avio, companyia
WHERE avio.companyia = companyia.nom
AND companyia.pais = 'Spain'
AND avio.any_fabricacio < 2000
ORDER BY avio.any_fabricacio DESC, companyia.nom ASC, avio.num_serie ASC;

-- Pregunta 3
-- personal 
-- pilot
-- vol
-- 15 rows
SELECT vol.codi, 
       vol.data, 
       CONCAT(personal.cognom, ' ', personal.nom, ' (', pilot.hores_Vol, ')') AS pilot, 
       vol.avio AS companyia
FROM vol, pilot, personal
WHERE vol.pilot = pilot.num_empleat
AND pilot.num_empleat = personal.num_empleat
AND EXTRACT(MONTH FROM vol.data) = 2 
AND EXTRACT(YEAR FROM vol.data) = 2024
AND personal.sou > 53000
AND pilot.hores_Vol > 7000
AND vol.descripcio LIKE 'DELAYED'
ORDER BY vol.avio, vol.data, vol.codi;

-- Pregunta 4
-- passatger
-- hostessa
-- vol
-- Tipo Recursiva 
-- La hostessa no tiene cognom ni nom
-- Vacio 
-- vol y volar
-- 2
7
SELECT 
    CONCAT(passatger.cognom, ', ', passatger.nom) AS passatger,
    CONCAT(hostessa.num_empleat, ', Hostessa') AS hostessa,
    vol.aeroport_origen,
    vol.aeroport_desti,
    vol.durada
FROM vol, passatger, hostessa, aeroport A, aeroport B, volar
WHERE vol.hostessa = hostessa.num_empleat
AND vol.aeroport_origen = A.codi
AND vol.aeroport_desti = B.codi
AND vol.codi=volar.vol
AND passatger.passaport = volar.passatger
AND passatger.adreca LIKE '%Madrid%' 
AND vol.data = '2023-12-25'
ORDER BY passatger.cognom;


-- Pregunta 5
-- vol
-- aeroport
-- Tipo Recursiva con aeroport_origen,aeroport_destí
-- 27 rows
SELECT 
    vol.codi, 
    CONCAT(A.nom, ' (', A.ciutat, ')') AS origen, 
    CONCAT(B.nom, ' (', B.ciutat, ')') AS desti
FROM vol, aeroport A, aeroport B
WHERE vol.aeroport_origen = A.codi 
AND vol.aeroport_desti = B.codi 
AND YEAR(vol.data) = 2024 
AND vol.durada > 160
AND SUBSTRING(A.ciutat, 3, 1) = 'o'
AND SUBSTRING(B.ciutat, 3, 1) = 'o'
ORDER BY vol.codi;

-- Pregunta 6
-- companyia
-- hostessa
-- passatger 
-- vol 
-- Recursiva filial_de
-- 142 
SELECT 
    c1.nom AS companyia,
    COALESCE(c2.nom, '-') AS companyia_mare,  -- Si no hay matriz, muestra "-"
    CONCAT(pilot.cognom, ', ', pilot.nom) AS pilot,
    CONCAT(hostessa.cognom, ', ', hostessa.nom) AS hostessa
FROM vol
JOIN avio ON vol.avio = avio.num_serie
JOIN companyia c1 ON avio.companyia = c1.nom
LEFT JOIN companyia c2 ON c1.filial_de = c2.nom
JOIN personal pilot ON vol.pilot = pilot.num_empleat
JOIN personal hostessa ON vol.hostessa = hostessa.num_empleat
WHERE avio.any_fabricacio = 2008
AND c1.filial_de IS NOT NULL
ORDER BY pilot.cognom, hostessa.cognom;


-- Pregunta 7
-- companyia
-- Con left
-- 239 rows 
SELECT 
    C1.nom AS companyia,
    COALESCE(C2.nom, '-') AS companyia_mare
FROM companyia C1
LEFT JOIN companyia C1 ON C2.nom = C1.filial_de
ORDER BY C1.filial_de;


-- Pregunta 8
select 'No ho sé';
