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
-- _____________________QUERY_________________
select ALbum.Titolo
from (album join Brano_Band on album.ID=Brano_Band.IDAlbum) join band on IDBand=band.id
where band.nome='883'

select album.Titolo, Album.CasaDIscografica, album.AnnoDiUscita
from album
where CasaDIscografica='Records' AND AnnoDiUscita='2021'

select Brano.Titolo
from Brano
where id = ANY (
select Brano_Band.IDBrano
from (Brano_Band join Album on Brano_Band.IDAlbum=Album.id) join band on Brano_Band.IDBand=band.id
where Band.nome='Maneskin' AND Album.AnnoDiUscita<=2019
)

select Album.Titolo
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