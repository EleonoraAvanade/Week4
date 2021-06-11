--create database NegozioDiDischi

create table Brano(
Titolo varchar(50),
durata bigint,
id smallint primary key identity(1,1)
)

create table band(
nome varchar(30),
numerodicomponenti smallint,
id smallint primary key identity(1,1)
)

create table Album(
id smallint primary key identity(1,1),
Titolo varchar(50) not null,
AnnoDiUscita int not null,
CasaDIscografica varchar(50) not null,
Genere varchar(15) not null
check (genere='Classico' OR genere='Jazz' OR genere='Pop' OR genere='ROck' OR genere='Metal'),
SupportoDiDistribuzione varchar(30) not null
check (SupportoDiDIstribuzione='CD' OR SupportoDiDIstribuzione='Vinile' OR SupportoDiDIstribuzione='Streaming'), 
unique(Titolo, AnnoDiUscita, CasaDIscografica, Genere, SupportoDiDistribuzione)
)
create table Brano_Band(
IDBrano smallint FOREIGN KEY REFERENCES Brano(ID),
IDBand smallint foreign key references Band(ID),
IDAlbum smallint foreign key references Album(ID)
)
--______CHECK WHAT'S IN_____
select * from Brano
select * from Brano_Band
select * from Album
select * from Band
--_________INSERT DATI______
insert into Album values ('Nonna', 2018, 'CasaMia', 'Classico', 'Vinile')
insert into Band values ('883', 3)
insert into Brano values ('MyLove', 180)
insert into Brano_Band values (1,1, 1)
--Per il primo test, passed. Then let's go through the second!
insert into Album values ('GioiaMIa', 2021, 'Records', 'Classico', 'Vinile')
--Second one, passed! It's the third's time
insert into Brano values ('Je ne sais pas', 180)
insert into Brano values ('Je suis en train de...', 180)
insert into Band values ('Maneskin', 20)
insert into Album values ('Piediskin', 2018, 'Records', 'Pop', 'CD')
insert into Brano_Band values (2,2, 3)
insert into Brano_Band values (3, 2,3)
--Third one passed too! SO happy to hear that :3
insert into Brano values ('Imagine', 200)
insert into Brano_Band values (5,1, 3)
insert into Brano_Band values (5,1, 2)
insert into Brano_Band values (5,2, 3)
--Fourth passed
insert into Band values ('The giornalisti', 3)
insert into Brano values ('Newspaper', 280)
insert into Brano values ('Articoli', 80)
insert into Brano values ('Di Riccione', 380)
insert into Album values ('Gammon', 2010, 'Moi', 'Pop', 'CD')
insert into Brano_Band values (6,3, 4)
insert into Brano_Band values (7,3, 4)
insert into Brano_Band values (8,3, 4)
--Everything passed, finish. Well done!
-- _____________________QUERY_________________
select ALbum.Titolo
from (album join Brano_Band on album.ID=Brano_Band.IDAlbum) join band on IDBand=band.id
where band.nome='883'

select album.Titolo, Album.CasaDIscografica, album.AnnoDiUscita
from album
where CasaDIscografica='Records' AND AnnoDiUscita=2021

select Brano.Titolo
from Brano
where id = ANY (
select Brano_Band.IDBrano
from (Brano_Band join Album on Brano_Band.IDAlbum=Album.id) join band on Brano_Band.IDBand=band.id
where Band.nome='Maneskin' AND Album.AnnoDiUscita<=2019
)

select DISTINCT Album.Titolo
from (Brano_Band join Album on Brano_Band.IDAlbum=Album.id) join brano on Brano_Band.IDBrano=Brano.id
where Brano.Titolo='Imagine'

select count(*) as NumeroCanzoni
from (Brano_Band join Brano on Brano_Band.IDBrano=Brano.id) join band on Brano_Band.IDBand=band.id
where Band.nome='The giornalisti'

select sum(Brano.durata) as MinutiTotali
from (Brano_Band join Album on Brano_Band.IDAlbum=Album.id) join brano on Brano_Band.IDBrano=Brano.id
group by Album.id

--______view_____
create view show
as
select *
from ((Brano_Band join Album on Brano_Band.IDAlbum=Album.id) join brano on Brano_Band.IDBrano=Brano.id) join Band on Brano_Band.IDBand=band.id;

CREATE FUNCTION NumeroAlbum (@Genere VARCHAR(15))
RETURNS INT
AS
BEGIN
	RETURN (select count(*)
	from Album
	where Album.Genere=@Genere
	)
END