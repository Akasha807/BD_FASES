/* *****************************************************
  INSTITUT TIC de Barcelona
    CFGS DAM 1 B
    Mòdul: 0484 Bases de dades. 
    AUTORS: Akasha Karam
    DATA: 18/3/25
****************************************************** */

-- Pregunta 1
SELECT a.ciutat AS ciutat_desti, 
       COUNT(v.codi) AS total_vols
FROM VOL v
JOIN AEROPORT a ON v.aeroport_desti = a.codi
WHERE YEAR(v.data) = 2023
GROUP BY a.ciutat
HAVING total_vols >= 800
ORDER BY total_vols DESC;


-- Pregunta 2
SELECT c.nom AS companyia, 
       COUNT(v.codi) AS total_vols, 
       COALESCE(AVG(v.durada), 0) AS durada_promig, 
       COALESCE(MAX(v.data), 'No hi ha vols') AS ultim_vol
FROM COMPANYIA c
LEFT JOIN AVIO a ON c.nom = a.companyia
LEFT JOIN VOL v ON a.num_serie = v.avio
WHERE c.pais = 'Spain'
GROUP BY c.nom
ORDER BY c.nom;


-- Pregunta 3
SELECT 
    YEAR(v.data) AS any, 
    MONTH(v.data) AS mes, 
    c.nom AS companyia,   
    COUNT(v.codi) AS total_vols
FROM COMPANYIA c
LEFT JOIN AVIO a ON c.nom = a.companyia
LEFT JOIN VOL v ON a.num_serie = v.avio 
WHERE c.pais = 'Spain' AND (v.data IS NULL OR YEAR(v.data) = 2023)
GROUP BY YEAR(v.data), MONTH(v.data), c.nom
ORDER BY any, mes, companyia;


-- Pregunta 4
SELECT v.codi, 
       ao.nom AS aeroport_origen, 
       ao.pais AS pais_origen, 
       ad.nom AS aeroport_desti, 
       ad.pais AS pais_desti
FROM VOL v
JOIN AEROPORT ao ON v.aeroport_origen = ao.codi
JOIN AEROPORT ad ON v.aeroport_desti = ad.codi
WHERE (v.data, v.aeroport_origen, v.aeroport_desti) = 
      (SELECT data, aeroport_origen, aeroport_desti FROM VOL WHERE codi = 482739)
AND v.codi <> 482739;


-- Pregunta 5
SELECT c.nom AS companyia, COUNT(v.codi) AS total_vols
FROM COMPANYIA c
JOIN AVIO a ON c.nom = a.companyia
JOIN VOL v ON a.num_serie = v.avio
GROUP BY c.nom
HAVING total_vols > (
    SELECT COUNT(v.codi)
    FROM COMPANYIA c
    JOIN AVIO a ON c.nom = a.companyia
    JOIN VOL v ON a.num_serie = v.avio
    WHERE c.nom = 'British Airways'
)
ORDER BY total_vols DESC;

