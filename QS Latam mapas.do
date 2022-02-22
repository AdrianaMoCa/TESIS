/******************************************************************************
***********************Marketing_Mapas*****************************************
*******************************************************************************

by: 	Marcy Castro :)
date: 	01-02-2017
*/
clear all
set mat 2000
set more off 

//Set pathways
di in yellow "USER:`c(username)'"

qui if "`c(username)'"=="marcy" {
	gl path "/Users/marcy/Dropbox/03 Working/08 DAE"
	cd "/Users/marcy/Dropbox/03 Working/08 DAE/data/"
}

qui if "`c(username)'"=="c3368" {
	*gl path "C:\Users\c3368\OneDrive\Documentos\TRABAJO_ClaudioCabrera\SEMANA_01_030222"
}


gl minedu "X:\Dropbox\12_Related projects\Lineas de Investigacion 2017\Marketing\07_Questionnaries&Data\03_DataManagement\01 Data security\"
gl beca18 "X:\Dropbox\educ_peru\07_Questionnaires & Data\01_Data\Data administrativa\Data\Raw\Beca 18"
gl sri "X:\Dropbox\educ_peru\07_Questionnaires & Data\01_Data\Data administrativa\Data\Raw\Matricula Univ SRI Nom"
gl admin "X:\Dropbox\educ_peru\07_Questionnaires & Data\01_Data\Data administrativa\Data\Working"
gl maps "X:\Dropbox\12_Related projects\Lineas de Investigacion 2017\Marketing\Presentation\INE\03 Limite Distrital Abril 2015"
gl maps_departamental "X:\Dropbox\12_Related projects\Lineas de Investigacion 2017\Marketing\Presentation\INE\01 Limite Departamental Abril 2015"
gl data "X:\Dropbox\12_Related projects\Lineas de Investigacion 2017\Marketing\data\working data"
gl outputs "X:\Dropbox\12_Related projects\Lineas de Investigacion 2017\Marketing\10_Analysis&Results\03 Reports and papers\Presentation\minedu_latex"
gl prob_ing "X:\Dropbox\12_Related projects\Lineas de Investigacion 2017\Marketing\07_Questionnaries&Data\03_DataManagement\01 Data security\working data"
gl clean "X:\Dropbox\12_Related projects\Lineas de Investigacion 2017\Marketing\07_Questionnaries&Data\03_DataManagement\01 Data security\Clean data"
gl sri "X:\Dropbox\educ_peru\07_Questionnaires & Data\01_Data\Data administrativa\Data\Raw\Matricula Univ SRI Nom"
gl temp "X:\Dropbox\12_Related projects\Lineas de Investigacion 2017\Marketing\10_Analysis&Results\03 Reports and papers\Presentation\minedu_latex"


ssc install spmap
ssc install shp2dta
ssc install mif2dta

gl maps_departamental "X:\Dropbox\12_Related projects\Lineas de Investigacion 2017\Marketing\Presentation\INE\01 Limite Departamental Abril 2015"

shp2dta using "${path}/data/clean/Shapefile_LATAM/LatinAmerica.shp.", ///
	database(auxi_latam_pais_shp.dta) coord(auxi_latam_pais_xy.dta) genid(id_dist) replace	

*Preparing data 
*General overview
import excel "/Users/marcy/Downloads/2022 QS LATAM Rankings Results v1.1 (for qs.com)-2.xlsx", sheet("RANKED") cellrange(A4:AF422) firstrow clear
br
tostring rankinsubregion, gen(latamid)
bysort rankinsubregion: gen n=_n
tostring n, replace 
replace latamid= latamid+"-"+n
br
save QS_ranking_latam_univs.dta, replace

* Subjects data 
use "/Users/marcy/Downloads/QS_ranking_BYsubject.dta", clear
encode subject, gen(key_carrera)
encode area, gen(key_area)
keep key* institution location academic employer citations h score subject area latam rank_2021_num
order key* institution location latam subject area rank_2021_num academic employer citations h score
ren (academic employer citations h score) (subj_academic subj_employer subj_citations subj_h subj_score)

gen latam_id =""
gen institution_upp=""

local v1 "ü á é í ó ú ü ñ ã ô è" 
local v2 "U Á É Í Ó Ú Ü Ñ Ã O E" // UNIVERSIDADE DE SãO PAULO FUNDAçãO GETULIO VARGAS (FGV) UNIVERSIDADE FEDERAL DO VALE DO SÃO FRANCISCO
local n : word count `v1'

forvalues i= 1/`n'{
local a : word `i' of `v1'
local b : word `i' of `v2'
 
 replace institution_upp=subinstr(institution, "`a'", "`b'",.)
 }
replace institution_upp = upper(institution_upp)
ren (institution_upp institution) (institution subj_institution)

merge m:1 institution using QS_ranking_latam_univs.dta, keep(master match) keepusing(latamid)


replace latam_id="1-1" if institution_upp=="PONTIFICIA UNIVERSIDAD CATÓLICA DE CHILE (UC)"
replace latam_id="2-1" if institution_upp=="UNIVERSIDADE DE SÃO PAULO"
replace latam_id="3-1" if institution_upp=="UNIVERSIDAD DE CHILE"
replace latam_id="4-1" if institution_upp=="TECNOLÓGICO DE MONTERREY"
replace latam_id="5-1" if institution_upp=="UNIVERSIDAD DE LOS ANDES"

replace latam_id="6-1" if institution_upp=="UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO  (UNAM)"
replace latam_id="7-1" if institution_upp=="UNIVERSIDADE ESTADUAL DE CAMPINAS (UNICAMP)"
replace latam_id="8-1" if institution_upp=="UNIVERSIDAD DE BUENOS AIRES (UBA)"
replace latam_id="9-1" if institution_upp=="UNIVERSIDADE FEDERAL DO RIO DE JANEIRO"
replace latam_id="10-1" if institution_upp=="UNIVERSIDAD NACIONAL DE COLOMBIA"
replace latam_id="11-1" if institution_upp=="UNIVERSIDAD DE CONCEPCIÓN"
replace latam_id="12-1" if institution_upp=="UNESP"
replace latam_id="13-1" if institution_upp=="PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ"
replace latam_id="14-1" if institution_upp=="UNIVERSIDAD DE ANTIOQUIA"
replace latam_id="15-1" if institution_upp=="UNIVERSIDAD DE SANTIAGO DE CHILE (USACH)"
replace latam_id="16-1" if institution_upp=="UNIVERSIDADE FEDERAL DE MINAS GERAIS"
replace latam_id="17-1" if institution_upp=="PONTIFÍCIA UNIVERSIDADE CATÓLICA DO RIO DE JANEIRO"
replace latam_id="18-1" if institution_upp=="PONTIFICIA UNIVERSIDAD JAVERIANA"
replace latam_id="19-1" if institution_upp=="UNIVERSIDADE FEDERAL DO RIO GRANDE DO SUL"
replace latam_id="20-1" if institution_upp=="UNIVERSIDAD DE COSTA RICA
replace latam_id="21-1" if institution_upp=="UNIVERSIDAD NACIONAL DE LA PLATA (UNLP)
replace latam_id="22-1" if institution_upp=="PONTIFICIA UNIVERSIDAD CATÓLICA DE VALPARAÍSO
replace latam_id="23-1" if institution_upp=="UNIVERSIDADE FEDERAL DE SANTA CATARINA
replace latam_id="24-1" if institution_upp=="UNIVERSIDAD ADOLFO IBÁÑEZ
replace latam_id="25-1" if institution_upp=="INSTITUTO POLITÉCNICO NACIONAL (IPN)
replace latam_id="26-1" if institution_upp=="UNIVERSIDAD AUSTRAL
replace latam_id="27-1" if institution_upp=="UNIVERSIDAD DE LA HABANA
replace latam_id="28-1" if institution_upp=="UNIVERSIDADE FEDERAL DE SÃO PAULO
replace latam_id="28-2" if institution_upp=="UNIVERSIDADE DE BRASÍLIA
replace latam_id="30-1" if institution_upp=="UNIVERSIDAD AUTÓNOMA METROPOLITANA (UAM)
replace latam_id="31-1" if institution_upp=="UNIVERSIDAD DIEGO PORTALES (UDP)
replace latam_id="32-1" if institution_upp=="UNIVERSIDADE FEDERAL DO PARANÁ - UFPR
replace latam_id="33-1" if institution_upp=="UNIVERSIDADE FEDERAL DE SÃO CARLOS (UFSCAR)
replace latam_id="34-1" if institution_upp=="UNIVERSIDAD TÉCNICA FEDERICO SANTA MARÍA (USM)
replace latam_id="35-1" if institution_upp=="UNIVERSIDAD NACIONAL DE CÓRDOBA - UNC
replace latam_id="36-1" if institution_upp=="UNIVERSIDAD TORCUATO DI TELLA
replace latam_id="37-1" if institution_upp=="UNIVERSIDAD AUSTRAL DE CHILE
replace latam_id="38-1" if institution_upp=="UNIVERSIDAD DEL ROSARIO
replace latam_id="39-1" if institution_upp=="UNIVERSIDAD IBEROAMERICANA IBERO
replace latam_id="40-1" if institution_upp=="UNIVERSIDAD CENTRAL DE VENEZUELA
replace latam_id="40-2" if institution_upp=="UNIVERSIDAD DE PUERTO RICO
replace latam_id="42-1" if institution_upp=="UNIVERSIDAD DE LA REPÚBLICA (UDELAR)
replace latam_id="43-1" if institution_upp=="PONTIFICIA UNIVERSIDAD CATÓLICA ARGENTINA
replace latam_id="44-1" if institution_upp=="UNIVERSIDAD DE GUADALAJARA (UDG)
replace latam_id="45-1" if institution_upp=="UNIVERSIDAD DE LA SABANA
replace latam_id="46-1" if institution_upp=="INSTITUTO TECNOLÓGICO AUTÓNOMO DE MÉXICO (ITAM)
replace latam_id="47-1" if institution_upp=="UNIVERSIDAD SIMÓN BOLÍVAR (USB)
replace latam_id="48-1" if institution_upp=="UNIVERSIDAD AUTÓNOMA DE NUEVO LEÓN
replace latam_id="49-1" if institution_upp=="UNIVERSIDADE FEDERAL DE PERNAMBUCO (UFPE)
replace latam_id="50-1" if institution_upp=="UNIVERSIDAD DEL VALLE
replace latam_id="51-1" if institution_upp=="UNIVERSIDAD DEL NORTE
replace latam_id="51-2" if institution_upp=="UNIVERSIDAD DE TALCA
replace latam_id="53-1" if institution_upp=="UNIVERSIDAD DE LAS AMÉRICAS PUEBLA (UDLAP)
replace latam_id="54-1" if institution_upp=="UNIVERSIDAD PERUANA CAYETANO HEREDIA (UPCH)
replace latam_id="55-1" if institution_upp=="UNIVERSIDAD DE LA FRONTERA (UFRO)
replace latam_id="55-2" if institution_upp=="UNIVERSIDAD EAFIT
replace latam_id="57-1" if institution_upp=="PONTIFÍCIA UNIVERSIDADE CATÓLICA DO RIO GRANDE DO SUL (PUCRS)
replace latam_id="58-1" if institution_upp=="UNIVERSIDAD DE LOS ANDES - CHILE
replace latam_id="58-2" if institution_upp=="UNIVERSIDADE FEDERAL DO CEARÁ (UFC)
replace latam_id="60-1" if institution_upp=="UNIVERSIDAD SAN FRANCISCO DE QUITO (USFQ)
replace latam_id="replace latam_id="61-1" if institution_upp=="UNIVERSIDAD NACIONAL DE ROSARIO (UNR)
replace latam_id="61-2" if institution_upp=="UNIVERSIDADE FEDERAL FLUMINENSE
replace latam_id="63-1" if institution_upp=="UNIVERSIDAD DE VALPARAÍSO (UV)
replace latam_id="64-1" if institution_upp=="PONTIFÍCIA UNIVERSIDADE CATÓLICA DE SÃO PAULO
replace latam_id="65-1" if institution_upp=="UNIVERSIDAD INDUSTRIAL DE SANTANDER - UIS
replace latam_id="66-1" if institution_upp=="UNIVERSIDAD PONTIFICIA BOLIVARIANA
replace latam_id="67-1" if institution_upp=="UNIVERSIDAD DE SAN ANDRÉS - UDESA
replace latam_id="68-1" if institution_upp=="UNIVERSIDADE DO ESTADO DO RIO DE JANEIRO (UERJ)
replace latam_id="69-1" if institution_upp=="UNIVERSIDAD DE LOS ANDES - (ULA) MÉRIDA
replace latam_id="70-1" if institution_upp=="UNIVERSIDADE FEDERAL DA BAHIA
replace latam_id="71-1" if institution_upp=="UNIVERSIDAD ANDRÉS BELLO
replace latam_id="72-1" if institution_upp=="UNIVERSIDADE FEDERAL DE PELOTAS
replace latam_id="73-1" if institution_upp=="UNIVERSIDAD NACIONAL MAYOR DE SAN MARCOS
replace latam_id="73-2" if institution_upp=="UNIVERSIDAD AUTÓNOMA DEL ESTADO DE MÉXICO (UAEMEX)
replace latam_id="75-1" if institution_upp=="UNIVERSIDAD EXTERNADO DE COLOMBIA
replace latam_id="76-1" if institution_upp=="UNIVERSIDAD CATÓLICA ANDRES BELLO
replace latam_id="77-1" if institution_upp=="UNIVERSIDAD ANÁHUAC MÉXICO
replace latam_id="78-1" if institution_upp=="BENEMÉRITA UNIVERSIDAD AUTÓNOMA DE PUEBLA
replace latam_id="79-1" if institution_upp=="UNIVERSIDAD DE MONTEVIDEO (UM)
replace latam_id="79-2" if institution_upp=="UNIVERSIDAD NACIONAL, COSTA RICA
replace latam_id="81-1" if institution_upp=="UNIVERSIDAD DE ORIENTE SANTIAGO DE CUBA
replace latam_id="82-1" if institution_upp=="ESCUELA SUPERIOR POLITÉCNICA DEL LITORAL (ESPOL)
replace latam_id="82-2" if institution_upp=="COLEGIO DE MÉXICO
replace latam_id="84-1" if institution_upp=="UNIVERSIDAD PANAMERICANA (UP)
replace latam_id="85-1" if institution_upp=="UNIVERSIDAD ORT URUGUAY
replace latam_id="86-1" if institution_upp=="INSTITUTO TECNOLÓGICO DE BUENOS AIRES (ITBA)
replace latam_id="87-1" if institution_upp=="UNIVERSIDAD CATÓLICA DEL NORTE
replace latam_id="88-1" if institution_upp=="UNIVERSIDAD DEL DESARROLLO (UDD)
replace latam_id="89-1" if institution_upp=="UNIVERSIDAD DEL PACÍFICO
replace latam_id="90-1" if institution_upp=="TECNOLÓGICO DE COSTA RICA -TEC
replace latam_id="91-1" if institution_upp=="UNIVERSIDAD CATÓLICA DEL URUGUAY (UCU)
replace latam_id="92-1" if institution_upp=="UNIVERSIDADE FEDERAL DE VIÇOSA (UFV)
replace latam_id="93-1" if institution_upp=="UNIVERSIDADE FEDERAL DE SANTA MARIA
replace latam_id="94-1" if institution_upp=="UNIVERSIDAD DE PALERMO (UP)
replace latam_id="94-2" if institution_upp=="UNIVERSIDAD NACIONAL DE CUYO
replace latam_id="96-1" if institution_upp=="UNIVERSIDADE ESTADUAL DE MARINGÁ
replace latam_id="97-1" if institution_upp=="UNIVERSIDADE FEDERAL DO RIO GRANDE DO NORTE
replace latam_id="98-1" if institution_upp=="UNIVERSIDAD ICESI
replace latam_id="99-1" if institution_upp=="UNIVERSIDAD DE GUANAJUATO
replace latam_id="99-2" if institution_upp=="UNIVERSIDAD NACIONAL DEL LITORAL
replace latam_id="101-1" if institution_upp=="UNIVERSIDADE FEDERAL DA PARAÍBA
replace latam_id="101-2" if institution_upp=="UNIVERSIDADE FEDERAL DE JUIZ DE FORA- (UFJF)
replace latam_id="103-1" if institution_upp=="UNIVERSIDAD DE MONTERREY (UDEM)
replace latam_id="104-1" if institution_upp=="UNIVERSIDADE ESTADUAL DE LONDRINA
replace latam_id="105-1" if institution_upp=="ESCUELA POLITÉCNICA NACIONAL
replace latam_id="106-1" if institution_upp=="UNIVERSIDAD DEL BÍO-BÍO
replace latam_id="106-2" if institution_upp=="UNIVERSIDADE FEDERAL DO ABC (UFABC)
replace latam_id="108-1" if institution_upp=="UNIVERSIDAD TECNOLÓGICA NACIONAL (UTN)
replace latam_id="109-1" if institution_upp=="UNIVERSIDAD DE BELGRANO
replace latam_id="110-1" if institution_upp=="UNIVERSIDAD NACIONAL DE SAN MARTÍN (UNSAM)
replace latam_id="111-1" if institution_upp=="UNIVERSIDADE FEDERAL DO ESPÍRITO SANTO
replace latam_id="112-1" if institution_upp=="UNIVERSIDADE FEDERAL DE OURO PRETO
replace latam_id="113-1" if institution_upp=="UNIVERSIDAD DE ANTOFAGASTA
replace latam_id="114-1" if institution_upp=="UNIVERSIDADE FEDERAL DE UBERLÂNDIA
replace latam_id="115-1" if institution_upp=="UNIVERSIDADE FEDERAL DE LAVRAS
replace latam_id="116-1" if institution_upp=="PONTIFICIA UNIVERSIDAD CATÓLICA DEL ECUADOR (PUCE)
replace latam_id="117-1" if institution_upp=="UNIVERSIDAD DE LA SERENA
replace latam_id="117-2" if institution_upp=="PONTIFÍCIA UNIVERSIDADE CATÓLICA DO PARANÁ
replace latam_id="119-1" if institution_upp=="UNIVERSIDADE FEDERAL DO RIO GRANDE
replace latam_id="120-1" if institution_upp=="UNIVERSIDAD IBEROAMERICANA (UNIBE)
replace latam_id="121-1" if institution_upp=="UNIVERSIDAD TECNOLÓGICA DE PANAMÁ (UTP)
replace latam_id="122-1" if institution_upp=="UNIVERSIDAD DE LIMA
replace latam_id="123-1" if institution_upp=="UNIVERSIDADE FEDERAL DE GOIÁS
replace latam_id="124-1" if institution_upp=="UNIVERSIDADE TECNOLÓGICA FEDERAL DO PARANÁ
replace latam_id="125-1" if institution_upp=="UNIVERSIDADE FEDERAL DE CAMPINA GRANDE
replace latam_id="125-2" if institution_upp=="UNIVERSIDAD NACIONAL DEL SUR
replace latam_id="127-1" if institution_upp=="UNIVERSIDADE FEDERAL DO PARÀ - UFPA
replace latam_id="128-1	UNIVERSIDADE DO VALE DO RIO DOS SINOS
replace latam_id="129-1	UNIVERSIDAD NACIONAL DE MAR DEL PLATA
replace latam_id="130-1	UNIVERSIDAD VERACRUZANA
replace latam_id="131-1	UNIVERSIDAD NACIONAL AGRARIA LA MOLINA
replace latam_id="131-2	UNIVERSIDADE ESTADUAL DE PONTA GROSSA
replace latam_id="133-1	UNIVERSIDAD NACIONAL DE LA ASUNCIÓN
replace latam_id="replace latam_id="133-2	UNIVERSIDAD EL BOSQUE
replace latam_id="135-1	UNIVERSIDAD CENTRAL "MARTA ABREU" DE LAS VILLAS
replace latam_id="136-1	UNIVERSIDAD PERUANA DE CIENCIAS APLICADAS
replace latam_id="136-2	FEDERAL UNIVERSITY OF HEALTH SCIENCES OF PORTO ALEGRE (UFCSPA)
replace latam_id="136-3	UNIVERSIDAD DE TARAPACA
replace latam_id="139-1	UNIVERSIDADE FEDERAL DE ITAJUBÁ
replace latam_id="140-1	UNIVERSIDAD AUTÓNOMA DE CHILE
replace latam_id="140-2	UNIVERSIDADE FEDERAL DE ALAGOAS
replace latam_id="140-3	UNIVERSIDAD AUTÓNOMA DE SAN LUIS DE POTOSÍ
replace latam_id="140-4	UNIVERSIDAD AUTÓNOMA DE BAJA CALIFORNIA
replace latam_id="144-1	UNIVERSIDAD AUTÓNOMA DE QUERÉTARO (UAQ)
replace latam_id="145-1	UNIVERSIDADE FEDERAL DO TRIÂNGULO MINEIRO
replace latam_id="146-1	UNIVERSIDADE FEDERAL RURAL DO RIO DE JANEIRO
replace latam_id="147-1	UNIVERSIDAD DEL ZULIA
replace latam_id="147-2	UNIVERSIDAD NACIONAL DE QUILMES
replace latam_id="149-1	UNIVERSIDAD MAYOR DE SAN ANDRÉS (UMSA)
replace latam_id="150-1	UNIVERSIDADE FEDERAL DE SERGIPE (UFS)
replace latam_id="151-1	UNIVERSIDAD NACIONAL DE TUCUMÀ¡N
replace latam_id="151-2	UNIVERSIDAD DEL VALLE DE GUATEMALA (UVG)
replace latam_id="153-1	UNIVERSIDAD AUTONOMA DE YUCATAN
replace latam_id="154-1	UNIVERSIDAD LATINOAMERICANA DE CIENCIA Y TECNOLOGÍA COSTA RICA (ULACIT)
replace latam_id="155-1	UNIVERSIDAD NACIONAL DE SAN LUIS
replace latam_id="156-1	UNIVERSIDAD AUTÓNOMA DEL ESTADO DE HIDALGO (UAEH)
replace latam_id="157-1	UNIVERSIDAD DE CARABOBO
replace latam_id="157-2	UNIVERSIDADE FEDERAL DE ALFENAS
replace latam_id="159-1	UNIVERSIDAD DE PANAMÁ - UP
replace latam_id="160-1	UNIVERSIDAD AUTÓNOMA DEL ESTADO DE MORELOS (UAEM)
replace latam_id="161-1	UNIVERSIDAD METROPOLITANA
replace latam_id="162-1	UNIVERSIDAD DE PIURA
163-1	UNIVERSIDADE FEDERAL DO MARANHÃO
164-1	UNIVERSIDAD DE MEDELLÍN
164-2	UNIVERSIDAD DE MAGALLANES (UMAG)
166-1	UNIVERSIDADE PRESBITERIANA MACKENZIE
167-1	UNIVERSIDAD DE CÓRDOBA - COLOMBIA
167-2	ITESO, UNIVERSIDAD JESUITA DE GUADALAJARA
169-1	UNIVERSIDADE FEDERAL DO MATO GROSSO DO SUL
170-1	UNIVERSIDADE FEDERAL DO AMAZONAS
171-1	UNIVERSIDAD NACIONAL DEL CENTRO DE LA PROVINCIA DE BUENOS AIRES (UNICEN)
172-1	UNIVERSIDAD TECNOLÓGICA DE PEREIRA
172-2	UNIVERSIDAD CENTRAL DEL ECUADOR
174-1	UNIVERSIDADE ESTADUAL DO OESTE DO PARANÁ
174-2	PONTIFICIA UNIVERSIDADE CATÓLICA DO CAMPINAS - PUC CAMPINAS
176-1	UNIVERSIDAD DE COLIMA
177-1	UNIVERSIDAD ALBERTO HURTADO
178-1	UNIVERSIDAD MICHOACANA DE SAN NICOLÁS DE HIDALGO
178-2	UNIVERSIDAD ARGENTINA DE LA EMPRESA -UADE
178-3	UNIVERSIDAD CATÓLICA DE TEMUCO
181-1	UNIVERSIDADE FEDERAL DO PAMPA
181-2	INSTITUTO TECNOLÓGICO DE SANTO DOMINGO (INTEC)
181-3	THE UNIVERSITY OF FORTALEZA-UNIFOR
184-1	UNIVERSIDAD DE LAS AMÉRICAS (UDLA) ECUADOR
185-1	UNIVERSIDAD DEL VALLE DE MEXICO (UVM)
186-1	UNIVERSIDAD LA SALLE (ULSA)
186-2	UNIVERSIDAD AUTÓNOMA DE CHIAPAS
188-1	UNIVERSIDAD DEL CAUCA
189-1	UNIVERSIDAD DE SONORA
189-2	UNIVERSIDAD AUTÓNOMA DE CHAPINGO
191-1	UNIVERSIDAD NACIONAL DEL COMAHUE
192-1	UNIVERSIDADE FEDERAL DE MATO GROSSO
193-1	UNIVERSIDADE FEDERAL DOS VALES DO JEQUITINHONHA E MUCURI
194-1	CATÓLICA DE CÓRDOBA
195-1	UNIVERSIDAD DE CARTAGENA
195-2	FUNDAÇÃO UNIVERSIDADE FEDERAL DO VALE DO SÃO FRANCISCO
197-1	FUNDACIÓN UNIVERSIDAD DE BOGOTÁ-JORGE TADEO LOZANO
197-2	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA - USAC
199-1	UNIVERSIDAD DE ESPECIALIDADES ESPIRITU SANTO
200-1	UNIVERSIDAD ANTONIO NARIÑO (UAN)
200-2	UNIVERSIDAD CATÓLICA DE LA SANTÍSIMA CONCEPCIÓN - UCSC
202-1	UNIVERSIDAD DE LAS FUERZAS ARMADAS ESPE (EX - ESCUELA POLITÉCNICA DEL EJÉRCITO)
203-1	UNIVERSIDAD DEL TOLIMA
204-1	UNIVERSIDAD DE CUENCA
204-2	UNIVERSIDAD DE LA SALLE
204-3	UNIVERSIDADE DO ESTADO DE SANTA CATARINA
207-1	UNIVERSIDAD TECNOLÓGICA DE LA HABANA JOSÉ ANTONIO ECHEVERRÍA, CUJAE
208-1	UNIVERSIDADE ESTADUAL DO NORTE FLUMINENSE
208-2	UNIVERSIDAD AUTÓNOMA DE AGUASCALIENTES
210-1	UNIVERSIDAD SERGIO ARBOLEDA
210-2	UNIVERSIDADE FEDERAL DE SÃO JOÃO DEL-REI UFSJ
212-1	UNIVERSIDAD DE QUINTANA ROO
213-1	UNIVERSIDAD DEL SALVADOR
214-1	INSTITUTO FEDERAL DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DO PARANÁ - IFPR
215-1	UNIVERSIDAD DE SANTANDER - UDES
216-1	UNIVERSIDAD NACIONAL DE ENTRE RÍOS
217-1	UNIVERSIDAD PRIVADA BOLIVIANA
217-2	UNIVERSIDAD TECNICA PARTICULAR DE LOJA (UPTL)
219-1	UNIVERSIDADE FEDERAL DO ESTADO DO RIO DE JANEIRO - UNIRIO
220-1	UNIVERSIDAD IBEROAMERICANA PUEBLA
221-1	PONTIFICIA UNIVERSIDAD CATOLICA MADRE Y MAESTRA
221-2	UNIVERSIDAD MAYOR DE SAN SIMÓN COCHABAMBA
223-1	UNIVERSIDADE DO ESTADO DA BAHIA
223-2	UNIVERSIDAD SAN IGNACIO DE LOYOLA
223-3	UNIVERSIDAD CATÓLICA DE COLOMBIA
226-1	UNIVERSIDAD SANTA MARÍA LA ANTIGUA-USMA
226-2	UNIVERSIDAD AUTÓNOMA DE GUADALAJARA (UAG)
228-1	UNIVERSIDAD DE SAN BUENAVENTURA
228-2	UNIVERSIDADE FEDERAL DE RORAIMA
230-1	UNIVERSIDADE FEDERAL DO ACRE
231-1	PONTIFICIA UNIVERSIDADE CATÓLICA DO MINAS GERAIS - PUC MINAS
232-1	UNIVERSIDAD LATINA DE COSTA RICA
233-1	FUNDACIÓN UNIVERSITARIA KONRAD LORENZ
234-1	ESCUELA DE INGENIERÍA DE ANTIOQUIA - EIA
234-2	UNIVERSIDAD AUTÓNOMA DE ZACATECAS
234-3	UNIVERSIDAD AUTÓNOMA DE COAHUILA
237-1	UNIVERSIDADE ESTADUAL DE FEIRA DE SANTANA
237-2	UNIVERSIDAD CATÓLICA DEL MAULE
237-3	UNIVERSIDADE ESTADUAL DA PARAÍBA
240-1	DOM BOSCO CATHOLIC UNIVERSITY
241-1	UNIVERSIDAD DE CALDAS
241-2	UNIVERSIDAD POPULAR AUTÓNOMA DEL ESTADO DE PUEBLA (UPAEP)
243-1	UNIVERSIDAD DEL VALLE DE ATEMAJAC
244-1	UNIVERSIDAD TECNOLÓGICA DE BOLÍVAR
245-1	UNIVERSIDADE ESTADUAL DO CENTRO-OESTE
246-1	UNIVERSIDAD CENTRAL DE CHILE
247-1	UNIVERSIDAD DEL MAGDALENA
247-2	UNIVERSIDADE DE RIBEIRÃO PRETO
247-3	UNIVERSIDAD INTERAMERICANA DE PUERTO RICO
247-4	UNIVERSIDAD ESAN
251-1	UNIVERSIDAD NACIONAL DE RÍO CUARTO - UNRC
252-1	UNIVERSIDAD SAN SEBASTIÁN - CHILE
253-1	UNIVERSIDAD AUTÓNOMA DE CIUDAD DE JUÁREZ
253-2	UNIVERSIDAD DE CIENFUEGOS CARLOS RAFAEL RODRÍGUEZ
255-1	UNIVERSIDAD MAYOR
255-2	UNIVERSIDADE ESTADUAL DE MONTES CLAROS
255-3	UNIVERSIDAD DE CIENCIAS EMPRESARIALES Y SOCIALES (UCES)
255-4	UNIVERSIDAD DE LA COSTA
259-1	UNIVERSIDADE POTIGUAR (UNP)
259-2	UNIVERSIDAD SANTO TOMÁS
261-1	UNIVERSIDAD AUTÓNOMA DE CHIHUAHUA
262-1	UNIVERSIDAD DE SAN MARTÍN DE PORRES -USMP
263-1	UNIVERSIDAD AUTÓNOMA DE CAMPECHE
264-1	UNIVERSIDADE DE SANTA CRUZ DO SUL
265-1	UNIVERSIDAD CES
265-2	UNIVERSIDADE DE CAXIAS DO SUL
267-1	UNIVERSIDAD CATÓLICA NUESTRA SEÑORA DE LA ASUNCIÓN
268-1	UNIVERSIDAD DISTRITAL FRANCISCO JOSÉ DE CALDAS
268-2	UNIVERSIDAD NACIONAL DE SAN ANTONIO ABAD DEL CUSCO
270-1	UNIVERSIDAD NACIONAL DE ITAPÚA (UNI)
271-1	UNIVERSIDADE LUTERANA DO BRASIL
271-2	INSTITUTO TECNOLÓGICO DE SONORA (ITSON)
273-1	UNIVERSIDADE DO VALE ITAJAÍ (UNIVALI)
274-1	CETYS UNIVERSIDAD
275-1	UNIVERSIDAD JUÁREZ DEL ESTADO DE DURANGO
275-2	NATIONAL UNIVERSITY OF THE PATAGONIA SAN JUAN BOSCO
277-1	UNIVERSIDAD AUTÓNOMA DE BUCARAMANGA
278-1	UNIVERSIDAD NACIONAL DE SALTA
278-2	UNIVERSIDAD BERNARDO O'HIGGINS
278-3	UNIVERSIDAD CATÓLICA BOLIVIANA "SAN PABLO"
281-1	UNIVERSIDAD TECNOLÓGICA DE MÉXICO (UNITEC)
281-2	UNIVERSIDAD CATÓLICA DE SANTIAGO DE GUAYAQUIL
281-3	UNIVERSIDAD AUTÓNOMA DEL CARIBE (UAC)
284-1	UNIVERSIDAD EAN
285-1	UNIVERSIDAD CIENTIFICA DEL SUR
285-2	UNIVERSIDAD UTE
287-1	UNIVERSIDAD DE LOS LAGOS
288-1	UNIVERSIDADE ESTADUAL DE GOIÁS
288-2	UNIVERSIDAD AUTÓNOMA DE ASUNCIÓN
290-1	UNIVERSIDAD NACIONAL PEDRO HENRÍQUEZ UREÑA
291-1	UNIVERSIDADE PAULISTA - UNIP
291-2	UNIVERSIDAD NACIONAL AUTÓNOMA DE HONDURAS (UNAH)
293-1	UNIVERSIDAD DEL ATLÁNTICO
294-1	UNIVERSIDAD LIBRE
294-2	UNIVERSIDAD DE CIENCIAS Y ARTES DE CHIAPAS
294-3	UNIVERSIDAD NACIONAL DE SAN JUAN
297-1	UNIVERSIDAD ARTURO PRAT
297-2	UNIVERSIDAD DEL NORTE (UNINORTE)"
replace latam_id="297-3" if institution=="UNIVERSIDADE NOVE DE JULHO (UNINOVE)"
replace latam_id="300-1" if institution=="UNIVERSIDAD NACIONAL DE CHIMBORAZO"
replace latam_id="300-2" if institution=="UNIVERSIDAD POLITECNICA SALESIANA"
replace latam_id="302-1" if institution=="UNIVERSIDAD ABIERTA INTERAMERICANA - UAI"
replace latam_id="303-1" if institution=="UNIVERSIDAD DE NARIÑO"
replace latam_id="304-1" if institution=="UNIVERSIDAD MILITAR NUEVA GRANADA"
replace latam_id="305-1" if institution=="UNIVERSIDAD DE PLAYA ANCHA"
replace latam_id="306-1" if institution=="UNIVERSIDAD AUTÓNOMA Â BENITO JUÀREZ DE OAXACA (UABJO)"
replace latam_id="306-2" if institution=="UNIVERSIDAD AUTÓNOMA NACIONAL DE NICARAGUA- MANAGUA - UNAN"
replace latam_id="308-1" if institution=="UNIVERSIDAD NACIONAL DE TRUJILLO"
replace latam_id="308-2" if institution=="UNIVERSIDADE DO VALE DO PARAÍBA (UNIVAP)"
replace latam_id="310-1" if institution=="UNIVERSIDAD AUTÓNOMA DE SANTO DOMINGO"
replace latam_id="311-1" if institution=="UNIVERSIDAD SANTO TOMÁS - CHILE"
replace latam_id="312-1" if institution=="UNIVERSIDAD AUTÓNOMA DE SINALOA"
replace latam_id="313-1" if institution=="UNIVERSIDADE DE PASSO FUNDO"
replace latam_id="314-1" if institution=="UNIVERSIDAD INTERAMERICANA DE PANAMÁ"
replace latam_id="314-2" if institution=="UNIVERSIDAD TECNOLÓGICA CENTROAMERICANA (UNITEC) - HONDURAS"
replace latam_id="316-1" if institution=="UNIVERSIDAD DE HOLGUÍN"
replace latam_id="317-1" if institution=="UNIVERSIDAD DEL CEMA"
replace latam_id="317-2" if institution=="UNIVERSIDAD SANTIAGO DE CALI"
replace latam_id="319-1" if institution=="UNIVERSIDAD SIMÓN BOLÍVAR COLOMBIA"
replace latam_id="319-2" if institution=="UNIVERSIDAD NACIONAL DE SAN AGUSTÍN DE AREQUIPA"
replace latam_id="321-1" if institution=="UNIVERSIDAD NACIONAL DE TRES DE FEBRERO"
replace latam_id="322-1" if institution=="UNIVERSIDAD TECNOLÓGICA METROPOLITANA"
replace latam_id="322-2" if institution=="UNIVERSIDAD AUTÓNOMA DE MANIZALES"
replace latam_id="322-3" if institution=="UNIVERSIDADE ESTADUAL DO MARANHÃO"
replace latam_id="325-1" if institution=="UNIVERSIDAD DE ATACAMA"
replace latam_id="326-1" if institution=="UNIVERSIDAD CENTROAMERICANA "JOSÉ SIMEÓN CAÑAS" - UCA"
replace latam_id="327-1" if institution=="UNIVERSIDADE ESTADUAL DO RIO GRANDE DO SUL"
replace latam_id="327-2" if institution=="UNIVERSIDAD NACIONAL DEL NOROESTE DE LA PROVINCIA DE BUENOS AIRES"
replace latam_id="327-3" if institution=="UNIVERSIDAD RICARDO PALMA"
replace latam_id="330-1" if institution=="UNIVERSIDAD JUÁREZ AUTÓNOMA DE TABASCO"
replace latam_id="331-1" if institution=="UNIVERSIDAD AUTÓNOMA DEL CARMEN"
replace latam_id="332-1" if institution=="UNIVERSIDAD DEL AZUAY"
replace latam_id="333-1" if institution=="UNIVERSIDAD FINIS TERRAE"
replace latam_id="334-1" if institution=="ESCUELA COLOMBIANA DE INGENIERÍA JULIO GARAVITO"
replace latam_id="334-2" if institution=="UNIVERSIDAD CATÓLICA SAN PABLO, AREQUIPA"
replace latam_id="334-3" if institution=="UNIVERSIDAD FRANCISCO MARROQUÍN (UFM)"
replace latam_id="337-1" if institution=="UNIVERSIDAD NACIONAL DE LA PAMPA"
replace latam_id="337-2" if institution=="UNIVERSIDAD AUTÓNOMA DE TAMAULIPAS"
replace latam_id="339-1" if institution=="UNIVERSIDAD LATINA DE PANAMÁ"
replace latam_id="339-2" if institution=="UNIVERSIDADE REGIONAL DE BLUMENAU"
replace latam_id="341-1" if institution=="UNIVERSIDADE SALVADOR"
replace latam_id="342-1" if institution=="UNIVERSIDAD AUTÓNOMA DE GUERRERO"
replace latam_id="342-2" if institution=="UNIVERSIDAD NACIONAL DE LA MATANZA"
replace latam_id="344-1" if institution=="UNIVERSIDAD PRIVADA DEL NORTE"
replace latam_id="345-1" if institution=="UNIVERSIDAD NACIONAL FEDERICO VILLARREAL - UNFV"
replace latam_id="346-1" if institution=="UNIVERSIDAD NACIONAL DEL NORDESTE"
replace latam_id="347-1" if institution=="UNIVERSIDAD DE PAMPLONA"
replace latam_id="348-1" if institution=="UNIVERSIDAD AUTÓNOMA DE OCCIDENTE"
replace latam_id="349-1" if institution=="UNIVERSIDAD DE MANIZALES"
replace latam_id="350-1" if institution=="UNIVERSIDAD COOPERATIVA DE COLOMBIA"
replace latam_id="350-2" if institution=="UNIVERSIDAD CENTROAMERICANA (UCA)"
replace latam_id="350-3" if institution=="UNIVERSIDAD PARA LA COOPERACIÓN INTERNACIONAL (UCI)"
replace latam_id="350-4" if institution=="UNIVERSIDAD AUTÓNOMA DE NAYARIT"
replace latam_id="354-1" if institution=="UNIVERSIDAD POLITÉNICA DE PUERTO RICO"
replace latam_id="354-2" if institution=="UNIVERSIDAD DE GUAYAQUIL"
replace latam_id="356-1" if institution=="UNIVERSIDAD DEL CARIBE"
replace latam_id="357-1" if institution=="UNIVERSIDAD TECNOLÓGICA DEL CENTRO (UNITEC)"
replace latam_id="358-1" if institution=="UNIVERSIDAD DE EL SALVADOR"
replace latam_id="358-2" if institution=="UNIVERSIDADE DO ESTADO DO PARÁ"
replace latam_id="358-3" if institution=="UNIVERSIDAD DEL QUINDÍO"
replace latam_id="361-1" if institution=="UNIVERSIDAD CATÓLICA CARDENAL RAÚL SILVA HENRÍQUEZ - UCSH"
replace latam_id="362-1" if institution=="UNIVERSIDAD NACIONAL DE LUJAN"
replace latam_id="362-2" if institution=="UNIVERSIAD CRISTÓBAL COLÓN"
replace latam_id="362-3" if institution=="UNIVERSIDAD INTERNACIONAL SEK"
replace latam_id="362-4" if institution=="UNIVERSIDAD NACIONAL DE GENERAL SARMIENTO"
replace latam_id="365-1" if institution=="UNIVERSIDAD DEL ISTMO (UDI)"
replace latam_id="366-1" if institution=="UNIVERSIDAD REGIOMONTANA"
replace latam_id="367-1" if institution=="INSTITUTO TECNOLÓGICO METROPOLITANO - ITM"
replace latam_id="367-2" if institution=="UNIVERSIDAD AUTÓNOMA DE CHIRIQUÍ (UNACHI)"
replace latam_id="369-1" if institution=="UNIVERSIDAD MAYOR DE SAN FRANCISCO XAVIER"
replace latam_id="370-1" if institution=="UNIVERSIDADE POSITIVO"
replace latam_id="371-1" if institution=="UNIVERSIDAD DEL NORESTE"
replace latam_id="371-2" if institution=="UNIVERSIDAD NACIONAL DE MISIONES"
replace latam_id="373-1" if institution=="UNIVERSIDADE VILA VELHA"
replace latam_id="374-1" if institution=="UNIVERSIDADE ANHEMBI MORUMBI (UAM)"
replace latam_id="374-2" if institution=="UNIVERSIDAD DE IBAGUÉ"
replace latam_id="376-1" if institution=="UNIVERSIDAD DE LAS AMÉRICAS CHILE (UDLA)"
replace latam_id="376-2" if institution=="UNIVERSIDAD CENTRAL DEL ESTE"
replace latam_id="376-3" if institution=="UNIVERSIDAD NACIONAL DE LANÚS"
replace latam_id="379-1" if institution=="UNIVERSIDAD APEC (UNAPEC)"
replace latam_id="380-1" if institution=="UNIVERSIDAD CATÓLICA TECNOLÓGICA DEL CIBAO - UCATECI"
replace latam_id="380-2" if institution=="UNIVERSIDAD DE LOS LLANOS"
replace latam_id="382-1" if institution=="UNIVERSIDAD TECNOLÓGICA DE EL SALVADOR (UTEC)"
replace latam_id="382-2" if institution=="UNIVERSIDADE REGIONAL DO NOROESTE DO ESTADO DO RIO GRANDE DO SUL"
replace latam_id="382-3" if institution=="UNIVERSIDAD TEC MILENIO"
replace latam_id="385-1" if institution=="ESCUELA SUPERIOR DE ADMINISTRACION PUBLICA (ESAP)"
replace latam_id="385-2" if institution=="UNIVERSIDAD DEL VIÑA DEL MAR"
replace latam_id="387-1" if institution=="UNIVERSIDAD NACIONAL DE LOMAS DE ZAMORA"
replace latam_id="388-1" if institution=="CATHOLIC UNIVERSITY OF MANIZALES"
replace latam_id="388-2" if institution=="UNIVERSIDADE DE TAUBATÉ"
replace latam_id="388-3" if institution=="UNIVERSIDAD CRISTIANA DE BOLIVIA (UCEBOL)"
replace latam_id="388-4" if institution=="UNIVERSIDAD DE LA AMAZONÍA"
replace latam_id="391-1" if institution=="UNIVERSIDAD PRIVADA DEL VALLE (UNIVALLE) - BOLIVIA"
replace latam_id="392-1" if institution=="UNIVERSIDAD DE OCCIDENTE"
replace latam_id="392-2" if institution=="UNIVERSIDAD CATÓLICA DE CUENCA"
replace latam_id="394-1" if institution=="UNIVERSIDAD CATÓLICA DEL SALVADOR"
replace latam_id="395-1" if institution=="UNIVERSIDAD NACIONAL DEL ALTIPLANO"
replace latam_id="396-1" if institution=="UNIVERSIDAD TÉCNICA DE ORURO"
replace latam_id="397-1" if institution=="UNIVERSIDADE VEIGA DE ALMEIDA"
replace latam_id="398-1" if institution=="ESCUELA COLOMBIANA DE CARRERAS INDUSTRIALES - ECCI"
replace latam_id="398-2" if institution=="UNIVERSIDAD CATÓLICA DE SANTO DOMINGO"
replace latam_id="400-1" if institution=="FUNDACIÓN UNIVERSITARIA DEL AREA ANDINA"
replace latam_id="400-2" if institution=="UNIVERSIDAD DEL CARIBE (UNICARIBE)"
replace latam_id="400-3" if institution=="UNIVERSIDAD PEDAGÓGICA NACIONAL FRANCISCO MORAZÁN (UPNFM)"
replace latam_id="403-1" if institution=="COLEGIO MAYOR DE ANTIOQUIA"
replace latam_id="404-1" if institution=="UNIVERSIDAD FRANCISCO GAVIDIA"
replace latam_id="405-1" if institution=="UNIVERSIDAD BELLOSO CHACÍN"
replace latam_id="406-1" if institution=="UNIVERSIDAD CUAUHTÉMOC"
replace latam_id="407-1" if institution=="UNIVERSIDAD TECNOLÓGICA DE HONDURAS (UTH)"
replace latam_id="408-1" if institution=="UNIVERSIDAD MEXIQUENSE DEL BICENTENARIO"
replace latam_id="409-1" if institution=="CENTRO UNIVERSITÁRIO RITTER DOS REIS (UNIRITTER)"
replace latam_id="410-1" if institution=="UNIVERSIDAD ESTATAL DE SONORA"
replace latam_id="410-2" if institution=="UNIVERSIDAD JUAN MISAEL SARACHO"
replace latam_id="410-3" if institution=="UNIVERSIDAD AUTÓNOMA TOMÁS FRÍAS"
replace latam_id="413-1" if institution=="UNIVERSIDAD FEDERICO HENRÍQUEZ Y CARVAJAL"
replace latam_id="414-1" if institution=="UNIVERSIDAD AUTÓNOMA DEL BENI - JOSÉ BALLIVIÁN"
replace latam_id="415-1" if institution=="UNIVERSIDAD DEL DISTRITO FEDERAL"
replace latam_id="416-1" if institution=="UNIVERSIDAD TECHNOLOGICA PRIVADA DE SANTA CRUZ"


keep if latam_rank!=""

	label define K2013  0 "	0" 1 "Entre 1 y 5" 2 "Entre 6 y 10" 3 "Entre 11 y 15" 4 "Más de	16"
	label values K2013 K2013
	label define K2014  0 "	0" 1 "Entre 1 y 5" 2 "Entre 6 y 10" 3 "	Entre 11 y 15" 4 "Más de 16"
	label values K2014 K2014
	label define K2015  0 "	0" 1 "Entre 1 y 5" 2 "Entre 6 y 10" 3 "Entre 11 y 15" 4 "Más de 16"
	label values K2015 K2015
		
		*label values K2013 etiqueta


import excel "/Users/marcy/Downloads/top20_geo.xlsx", sheet("Sheet2") firstrow clear
br
save "/Users/marcy/Downloads/top20_geo", replace
*3.Mapas
*********
use "/Users/marcy/Dropbox/03 Working/08 DAE/data/auxi_latam_pais_shp.dta", clear

spmap using "/Users/marcy/Dropbox/03 Working/08 DAE/data/auxi_latam_pais_xy.dta", id(id_dist) point(data("/Users/marcy/Downloads/top20_geo") xcoord(longitud) ycoord(latitud) ///
shape(+) osize(*2) fcolor(red*.2)) 

graph export "/Users/marcy/Dropbox/03 Working/08 DAE/data/ global.png", as(png) replace
graph export "/Users/marcy/Dropbox/03 Working/08 DAE/data/ global.eps", replace // ya los guardamos


*Mapa 1: mapas de progreso de la postulación de beca 18

*describe using "$beca18//Variables 2012-2015 Dic_FSPOST"
*describe using "$beca18//Variables 2012-2015 Dic_COLE"
*use convocatoria dni1 using "$beca18//Variables 2012-2015 Dic_FSPOST", clear
*use ccoleanio4 coleanio4 tipo4 anio45 ccoleanio5 coleanio5 tipo5 anio56 nro_documento using "$beca18//Variables 2012-2015 Dic_COLE"
		*1Generando la base
		********************
		/*
		use ccoleanio5 coleanio5 tipo5 anio56 nro_documento using "$beca18//Variables 2012-2015 Dic_COLE", clear
		rename ccoleanio5 cod_mod 
		destring cod_mod, gen (cod_mod_n)
		bys cod_mod anio56: egen postulantes= count(cod_mod_n)
		tostring nro_documento, gen(dni1)

		merge 1:m dni1 using "$beca18//Variables 2012-2015 Dic_FSPOST", keepusing(convocatoria consustentodecomunidadindigena) keep(match) nogen
		gen year=.
		replace year=2013 if strpos(convocatoria,"2013")
		replace year=2012 if strpos(convocatoria,"2012")
		replace year=2014 if strpos(convocatoria,"2014")
		replace year=2015 if strpos(convocatoria,"2015")
		
		tab year consustentodecomunidadindigena
		

		collapse (max)postulantes , by(cod_mod year)
		drop if cod_mod==""

		reshape wide postulantes, i(cod_mod) j(year)
		destring cod_mod, replace
		merge 1:1 cod_mod using "$admin//02_base escuelas peru codmod anexo", keep(using match) keepusing(nomiiee ubigeo dpto prov dist latitud longitud area) nogen
		
		recode postulantes* (.=0)
		
		******
		gen K2013=0 if postulantes2013==0
		replace K2013=1 if postulantes2013>=1 & postulantes2013<=5
		replace K2013=2 if postulantes2013>=6 & postulantes2013<=10
		replace K2013=3 if postulantes2013>=11 & postulantes2013<=15
		replace K2013=4 if postulantes2013>=16
		
		
		gen K2014=0 if postulantes2014==0
		replace K2014=1 if postulantes2014>=1 & postulantes2014<=5
		replace K2014=2 if postulantes2014>=6 & postulantes2014<=10
		replace K2014=3 if postulantes2014>=11 & postulantes2014<=15
		replace K2014=4 if postulantes2014>=16
		
		
		gen K2015=0 if postulantes2013==0
		replace K2015=1 if postulantes2015>=1 & postulantes2015<=5
		replace K2015=2 if postulantes2015>=6 & postulantes2015<=10
		replace K2015=3 if postulantes2015>=11 & postulantes2015<=15
		replace K2015=4 if postulantes2015>=16
		
		label define K2013  0 "	0" 1 "Entre 1 y 5" 2 "Entre 6 y 10" 3 "Entre 11 y 15" 4 "Más de	16"
		label values K2013 K2013
		label define K2014  0 "	0" 1 "Entre 1 y 5" 2 "Entre 6 y 10" 3 "	Entre 11 y 15" 4 "Más de 16"
		label values K2014 K2014
		label define K2015  0 "	0" 1 "Entre 1 y 5" 2 "Entre 6 y 10" 3 "Entre 11 y 15" 4 "Más de 16"
		label values K2015 K2015
		
		*label values K2013 etiqueta
			
		gen D=(K2013!=0 | K2014!=0 | K2015!=0)
		save "$temp//escuelasB18.dta", replace
		*/
		
		*2.Cuadro de cambio porcentual por anio
		***************************************
		*collapse por departamento año
		preserve
		use "$temp//escuelasB18.dta", clear
		bys dpto: egen total_2013= sum(postulantes2013)
		bys dpto: egen total_2014= sum(postulantes2014)
		bys dpto: egen total_2015= sum(postulantes2015)
		collapse (max)total_2013 total_2014 total_2015 , by(dpto)
		gen variacion_1314 = total_2013/total_2014
		*replace variacion_1314 = 0 if variacion_1314==.
		gen variacion_1415 = total_2014/total_2015
		*replace variacion_1415 = 0 if variacion_1415==.
		graph hbar (mean) variacion_1314, over(dpto, sort(variacion_1314))
		graph hbar (mean) variacion_1415, over(dpto, sort(variacion_1415))
		*, bar(c(gold*.25)) // cambiar de color :)
		restore
		
		
		
*ssc install spmap
*ssc install shp2dta
*ssc install mif2dta

shp2dta using "$maps_departamental//DEPARTAMENTO_27_04_2015.shp", ///
	database(auxi_per_dep_shp.dta) coord(auxi_per_dep_xy.dta) genid(id_dist) replace	

		*3.Mapas
		*********
		use auxi_per_dep_shp.dta, clear
						
		spmap using auxi_per_dep_xy.dta, id(id_dist) point(data("$temp//escuelasB18.dta") xcoord(longitud) ycoord(latitud) ///
			shape(p ..) osize(*1) fcolor(red*.2)) 

		*graph export "$temp//Marketing_beca18_global.png", as(png) replace
		graph export "$temp//Marketing_beca18_global.eps", replace // ya los guardamos
						
		spmap using auxi_per_dep_xy.dta, id(id_dist) point(data("$temp//escuelasB18.dta") xcoord(longitud) ycoord(latitud) ///
			shape(o o o o o) size(vsmall) fcolor(Reds2) by(K2013)legenda(on) legcount legtitle(Número de Postulantes 2013)leglabel(K2013)proportional(postulantes2013)) legend(title("Leyenda") size(*1.5) pos(7))
		*graph export "$temp//Marketing_beca18_2013.png", as(png)	replace
		*graph export "$temp//Marketing_beca18_2013.eps", replace // ya los guardamos
			
		spmap using auxi_per_dep_xy.dta, id(id_dist) point(data("$temp//escuelasB18.dta") xcoord(longitud) ycoord(latitud) ///
			shape (o o o o o) size(vsmall) fcolor(Reds2) by(K2014)legenda(on) legcount legtitle(Número de Postulantes 2014)leglabel(K2014)proportional(postulantes2014)) legend(title("Leyenda") size(*1.5) pos(7))	
		*graph export "$temp//Marketing_beca18_2014.png", as(png)	replace
		*graph export "$temp//Marketing_beca18_2014.eps", replace // ya lo guardamos
			
		spmap using auxi_per_dep_xy.dta, id(id_dist) point(data("$temp//escuelasB18.dta") xcoord(longitud) ycoord(latitud) ///
			shape(o o o o o) size(vsmall)fcolor(Reds2)  by(K2015)legenda(on) legcount legtitle(Número de Postulantes 2015)leglabel(K2015)proportional(postulantes2015)) legend(title("Leyenda") size(*1.5) pos(7))	
		*graph export "$temp//Marketing_beca18_2015.png", as(png)	replace
		*graph export "$temp//Marketing_beca18_2015.eps", replace // Ya lo guardamos

		
*Mapa 2:  escuelas y la probabilidad de ingreso a la universidad (por quiniles)
*******************************************************************************

	use "$prob_ing//escuelas_prob_ingreso", clear

	gen auxi_prob_2014 = prob_ing_2014 
	replace auxi_prob_2014 = 1 if  prob_ing_2014>1
	gen auxi_prob_2015 = prob_ing_2015
	replace auxi_prob_2015 = 1 if  prob_ing_2015>1
		
	shp2dta using "$maps_departamental//DEPARTAMENTO_27_04_2015.shp", ///
		database(auxi_per_dep_shp.dta) coord(auxi_per_dep_xy.dta) genid(id_dist) replace

	use auxi_per_dep_shp.dta, clear
		
	spmap using auxi_per_dep_xy.dta, id(id_dist) point(data("$prob_ing//escuelas_prob_ingreso.dta") xcoord(longitud) ycoord(latitud) ///
		shape(o o o o o) size(tiny) fcolor(Blues2) by(quintil) proportional(prob_ingreso))	
	*graph export "$outputs//Marketing_prob_ingreso.eps" // ya fue generado por MINEDU	

	
*Mapa 3: Muestra para la aplicacion de a encuesta
*************************************************
use "$clean\Muestra_oficial1_corregido", clear
*label define K2013  0 "	0" 1 "Entre 1 y 5" 2 "Entre 6 y 10" 3 "Entre 11 y 15" 4 "Más de	16"
*label values K2013 K2013

shp2dta using "$maps_departamental//DEPARTAMENTO_27_04_2015.shp", ///
	database(auxi_per_dep_shp.dta) coord(auxi_per_dep_xy.dta) genid(id_dist) replace

use auxi_per_dep_shp.dta, clear
	
spmap using auxi_per_dep_xy.dta, id(id_dist) point(data("$clean\Muestra_oficial1_corregido") xcoord(longitud) ycoord(latitud) ///
	shape(o o o o o) size (small) fcolor(Reds2) by(quintil) legenda(on) legcount legtitle(Quintiles por probabilidad de ingreso)leglabel(K2015)) legend(title("Leyenda") size(*1.3) pos(8))
	
graph export "$temp//Marketing_muestra.eps", replace // ya lo guardamos

	
*Mapa 4: mapa de becarios PB18 por universidad
***********************************************
*use "$sri//sri_nomin1415", clear

			use ccoleanio5 coleanio5 tipo5 anio56 nro_documento using "$beca18//Variables 2012-2015 Dic_COLE", clear
			rename ccoleanio5 cod_mod 
			destring cod_mod, gen (cod_mod_n)
			bys cod_mod anio56: egen postulantes= count(cod_mod_n)
			*tostring nro_documento, gen(dni)
			ren nro_documento dni
				
			merge 1:m dni using "$beca18//Variables 2012-2015 Dic_POST", keepusing(convocatoria condicionbeca condicionbeneficiario institucin tipodegestin region_destino tipo) keep(match) nogen
			
			gen year=.
			replace year=2012 if convocatoria== 1 | convocatoria==2 | convocatoria==3 
			replace year=2013 if convocatoria == 4 | convocatoria==5
			replace year=2014 if convocatoria == 6 | convocatoria==7 |convocatoria==8  
			replace year=2015 if convocatoria == 9 
			gen D_becario =(condicionbeca=="Becario" | condicionbeca=="Ex-Becario")
			
			keep if D_becario==1
			keep if tipo=="Universidad"
			keep if region_destino!="CUBA" & region_destino!="FRANCIA" & region_destino!="HONDURAS"
			
			*IHH
			*****
			preserve
				bys cod_mod institucin: egen x=total(D_becario)
				bys cod_mod: egen z=total(D_becario)
				gen s=x/z
				replace s=s^2
				bys cod_mod institucin: keep if _n==1
				bys cod_mod: egen ihh=total(s)
				summ ihh
				bys cod_mod: keep if _n==1
				*histogram ihh
				histogram ihh, percent scheme(s1color) width(.05) fcolor(blue) lcolor(white) ytitle(Porcentaje) xtitle(IHH - Indice Herfindahl Hirschman)
				*graph export "$temp//ihh_B18.eps", replace
			restore
			
			replace institucin=subinstr(institucin,"UNIVERSIDAD ", "U.",.)
			replace institucin=subinstr(institucin,"NACIONAL ","N.",.)
			replace institucin=subinstr(institucin,"PRIVADA ","PRIV.",.)
			replace institucin=subinstr(institucin,"ASOCIACION ","ASOC.",.)
			replace institucin=subinstr(institucin,"PERUANA","PER.",.)
			replace institucin=subinstr(institucin,"CIENTIFICA","CIENT.",.)
			replace institucin=subinstr(institucin,"CATOLICA","CAT.",.)
			replace institucin=subinstr(institucin,"AMERICA LATINA","A.L.",.)
			replace institucin=subinstr(institucin,"PONTIFICIA","PONT.",.)
			
			
			encode institucin, gen(universidad_n)
			bysort cod_mod: egen universidad=mode(universidad_n), maxmode
			collapse (max)universidad , by(cod_mod)
			label values universidad universidad_n
					
			drop if cod_mod==""
			destring cod_mod, replace
			merge 1:1 cod_mod using "$admin//02_base escuelas peru codmod anexo", keep(using match) keepusing(nomiiee ubigeo dpto prov dist latitud longitud area) nogen
			
			recode universidad* (.=0)
			drop if universidad==0
			
			bysort uni: egen n=count(universidad)
			
			
			preserve
				tempfile rank
				collapse (max) n , by(uni)
				gsort +n uni
				gen position=_n
				gen hola=string(position)
				replace hola="0"+hola if position<10
				replace hola="00"+hola if position<100
				decode uni, gen(uni_n)
				replace uni_n=hola + " " +uni_n
				encode uni_n, gen(uni_real)
				*Cálculos importantes
				*gen hola=sum(n)
				*gen hola2=hola/r(sum)
				gen D_50=(position >= 34)
				save `rank'
			restore
			
			
			merge m:1 universidad using `rank', nogen
			gen mapa=universidad if D_50==1
			replace mapa=0 if mapa==.
			
			label define universidad_n 0 "Otras", add
			label values mapa universidad_n
		
		save "escuelaB18_universidades.dta", replace
		
		use auxi_per_dep_shp.dta, clear
	
		spmap using auxi_per_dep_xy.dta, id(id_dist) point(data("escuelaB18_universidades") xcoord(longitud) ycoord(latitud) ///
		shape (x O ..) size (small) fcolor(Rainbow) by(mapa) legenda(on) legcount legtitle()leglabel(mapa)) legend(title("Leyenda") size(*1) pos(7))
		
		*graph export "$outputs//Marketing_b18_concentracion.eps", replace
		
*Gráfico 2: B18, corte puntaje
******************************
use "$beca18//Variables 2012-2015 Dic_POST", clear

			gen year=.
			replace year=2012 if convocatoria== 1 | convocatoria==2 | convocatoria==3 
			replace year=2013 if convocatoria == 4 | convocatoria==5
			replace year=2014 if convocatoria == 6 | convocatoria==7 |convocatoria==8  
			replace year=2015 if convocatoria == 9 
			
			gen D_beca =(condicionbeca=="Becario" | condicionbeca=="Ex-Becario")	
		
graph twoway (lpolyci D_beca puntajetotal if year==2015 & modalidad==17 & puntajetotal>=10.5) (lpolyci D_beca puntajetotal if year==2015 & modalidad==17 & puntajetotal<=10.5), xline (10.5)
graph twoway (lfitci D_beca puntajetotal if year==2015 & modalidad==17 & puntajetotal>=10.5 & condicionbeneficiario=="Beneficiario") (lfitci D_beca puntajetotal if year==2015 & modalidad==17 & puntajetotal<=10.5 & condicionbeneficiario=="Beneficiario"), xline (10.5)
graph twoway (lpolyci D_beca puntajetotal if year==2015 & modalidad==17 & puntajetotal>=10.5 & condicionbeneficiario=="Beneficiario") (lpolyci D_beca puntajetotal if year==2015 & modalidad==17 & puntajetotal<=10.5 & condicionbeneficiario=="Beneficiario"), xline (10.5)

		
		
*Mapa 5: mapa de universo de ingresantespor cod_mod vs universidad
******************************************************************

			use cod_mod COD_MOD matricula id_est nombre_ie sri_siagie14 using "$sri//sriSiagie_inomin1415_minedu", clear
			keep if sri_siagie14==1
			ren cod_mod universidad_n
			ren COD_MOD cod_mod
			*bys cod_mod convocatoria: egen ingresantes= count(cod_mod_n)
			
			gen year=.
			replace year=2014 if matricula== "2014-1"| matricula== "2014-2" 
			replace year=2015 if matricula == "2015-1" | matricula=="2015-2" | matricula=="2015-Anual"

			
			*IHH
			*****
			*Total
			/*preserve
				bys cod_mod universidad_n: egen x=count(id_est)
				bys cod_mod: egen z=count(id_est)
				gen s=x/z
				replace s=s^2
				bys cod_mod universidad_n: keep if _n==1
				bys cod_mod: egen ihh=total(s)
				summ ihh
				bys cod_mod: keep if _n==1
				histogram ihh
				histogram ihh, percent
			restore*/
			*Sin duplicados
			***************
			preserve
				sort id_est matricula
				bysort id_est: keep if _n==1
				bys cod_mod universidad_n: egen x=count(id_est)
				bys cod_mod: egen z=count(id_est)
				gen s=x/z
				replace s=s^2
				*bys cod_mod universidad_n: keep if _n==1
				bys cod_mod: egen ihh=total(s)
				
			encode nombre_ie, gen(universidad)
			bysort cod_mod: egen uni=mode(universidad), maxmode
			collapse (max)uni , by(cod_mod ihh)
			label values uni universidad
					
			drop if cod_mod==.
				
				summ ihh
				bys cod_mod: keep if _n==1
				histogram ihh, percent scheme(s1color) width(.05) fcolor(red) lcolor(white) ytitle(Porcentaje) xtitle("IHH - Indice Herfindahl Hirschman, (n>0)") 
				
				*graph export "$outputs//ihh_GLOBAL.eps", replace
				graph export "$outputs//ihh_GLOBAL.png", replace
				histogram ihh if x>4, percent scheme(s1color) width(.05) fcolor(white) lcolor(red) ytitle(Porcentaje) xtitle("IHH - Indice Herfindahl Hirschman, (n>4)") 
				*graph export "$outputs//ihh_GLOBALa5.eps", replace
				graph export "$outputs//ihh_GLOBALa5.png", replace
			restore
			
			replace nombre_ie=subinstr(nombre_ie,"UNIVERSIDAD ", "U.",.)
			replace nombre_ie=subinstr(nombre_ie,"NACIONAL ","N.",.)
			replace nombre_ie=subinstr(nombre_ie,"PRIVADA ","PRIV.",.)
			replace nombre_ie=subinstr(nombre_ie,"ASOCIACION ","ASOC.",.)
			replace nombre_ie=subinstr(nombre_ie,"PERUANA","PER.",.)
			replace nombre_ie=subinstr(nombre_ie,"CIENTIFICA","CIENT.",.)
			replace nombre_ie=subinstr(nombre_ie,"CATOLICA","CAT.",.)
			replace nombre_ie=subinstr(nombre_ie,"AMERICA LATINA","A.L.",.)
			replace nombre_ie=subinstr(nombre_ie,"PONTIFICIA","PONT.",.)
			
			encode nombre_ie, gen(universidad)
			bysort cod_mod: egen uni=mode(universidad), maxmode
			collapse (max)uni , by(cod_mod)
			label values uni universidad
					
			drop if cod_mod==.
			merge 1:1 cod_mod using "$admin//02_base escuelas peru codmod anexo", keep(match) keepusing(nomiiee ubigeo dpto prov dist latitud longitud area) nogen
			
			recode uni (.=0)
			drop if uni==0
			drop ubigeo
			
			bysort uni: egen n=count(cod_mod)
			
			preserve
				tempfile rankN
				collapse (max) n , by(uni)
				gsort +n uni
				gen position=_n
				gen hola=string(position)
				replace hola="0"+hola if position<10
				replace hola="00"+hola if position<100
				decode uni, gen(uni_n)
				replace uni_n=hola + " " +uni_n
				encode uni_n, gen(uni_real)
				*Cálculos importantes
				*gen hola=sum(n)
				*gen hola2=hola/r(sum)
				gen D_50=(position >= 98)
				save `rankN'
			restore
						
			merge m:1 uni using `rankN', nogen
			
			gen mapa=uni_real if D_50==1
			replace mapa=0 if mapa==.
			
			label define uni_real 0 "Otras", add
			label values mapa uni_real
			
			save "escuelas_universidades.dta", replace
		
		use auxi_per_dep_shp.dta, clear
	
		spmap using auxi_per_dep_xy.dta, id(id_dist) point(data("escuelas_universidades") xcoord(longitud) ycoord(latitud) ///
		shape (x O ..) size (small) fcolor(Rainbow) by(mapa) legenda(on) legcount)legend(title("Leyenda") size(*1) pos(7))
		

*Generar porcentajes importantes
********************************
	*Tabla por escuela # de ingresantes y #de becarios 
	***************************************************
			use ccoleanio5 coleanio5 tipo5 anio56 nro_documento using "$beca18//Variables 2012-2015 Dic_COLE", clear
			rename ccoleanio5 cod_mod 
			destring cod_mod, gen (cod_mod_n)
			bys cod_mod anio56: egen postulantes= count(cod_mod_n)
			*tostring nro_documento, gen(dni)
			ren nro_documento dni
				
			merge 1:m dni using "$beca18//Variables 2012-2015 Dic_POST", keepusing(convocatoria condicionbeca condicionbeneficiario institucin tipodegestin region_destino tipo) keep(match) nogen
			
			gen year=.
			replace year=2012 if convocatoria== 1 | convocatoria==2 | convocatoria==3 
			replace year=2013 if convocatoria == 4 | convocatoria==5
			replace year=2014 if convocatoria == 6 | convocatoria==7 |convocatoria==8  
			replace year=2015 if convocatoria == 9 
			gen D_becario =(condicionbeca=="Becario" | condicionbeca=="Ex-Becario")
			
			keep if D_becario==1	
			keep if tipo=="Universidad"
			keep if region_destino!="CUBA" & region_destino!="FRANCIA" & region_destino!="HONDURAS"
			keep if year== 2014 | year==2015
			
			bysort cod_mod: egen n_becados=count(dni)
			collapse (max)n_becados , by(cod_mod)
			
			drop if cod_mod==""
						
			*Merge : base sri
			*****************
			preserve
				use cod_mod COD_MOD matricula id_est nombre_ie sri_siagie14 using "$sri//sriSiagie_inomin1415_minedu", clear //dataset with all HE-HS matches up to 2015.
				keep if sri_siagie14==1
				ren cod_mod universidad_n
				ren COD_MOD cod_mod
				*bys cod_mod convocatoria: egen ingresantes= count(cod_mod_n)
				
				gen year=.
				replace year=2014 if matricula== "2014-1"| matricula== "2014-2" 
				replace year=2015 if matricula == "2015-1" | matricula=="2015-2" | matricula=="2015-Anual"
				
				bysort cod_mod: egen n_matriculados=count(id_est) 
				tempfile sri
				collapse (max) n_matriculados, by(cod_mod)
				*count if n_matriculados==0 //adds up to zero
				save `sri' //dataset with all schools with some presence in SRI
			restore 
			
			destring cod_mod, replace
			merge 1:1 cod_mod using `sri' //merging b18 scholars dataset with all schools in SRI	
			// 2612 codmods hacen merge, 1324 tienen becarios sin escuela en SRI
			replace n_becados=0 if n_becados==.
			replace n_matriculados=0 if n_matriculados==.
			
			
			*keep if n_matriculados !=0

			// merge with dataset of all schools, keep matched and using. (onlymasters must be very old schools, or atypical cases).
			merge 1:1 cod_mod using "$admin//02_base escuelas peru codmod anexo", keep(using match) keepusing(nomiiee ubigeo dpto prov dist latitud longitud area) nogen
			
			gen D_algun_B =(n_becado>0 & n_becado!=.)
			gen D_algun_M =(n_matriculado>0 & n_matriculado!=.)
			gen nob18= n_matriculados - n_becados //marker for "even w/o B18 this school who'd still sent kids to college"
			replace nob18=0 if nob18==.
			replace nob18=0 if nob18<=0
			gen D_sin_B18 =(nob18!=0)	
			
			tab D_sin_B18 D_algun_B // 4705/6524 = 71% check. This is the share of beneficiary schools that would have not send schools to college otherwise.
			tab D_algun_M D_sin_B18 // 790/7314 = 10.8%
			
				
 

















