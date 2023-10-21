-- Cap3. Trabajar con varias tablas

select *
from ventas


select*
from vendedor


-- P1. Ventas por cliente

select
v.id_venta,
c.nombre as nombre_cliente,
v.venta
from ventas v
join clientes c on v.id_cliente=c.id_cliente

-- P2. Ventas por vendedor y zona

select
v.id_venta,
ven.nombre+' '+ven.apellido as nombre_vendedor,
c.nombre as nombre_cliente,
v.venta
from ventas v 
join vendedor ven on v.id_vendedor=ven.id_vendedor
join clientes c on v.id_cliente=c.id_cliente

-- P3.Vendedor que no ha vendido nada


select
*
from ventas v
full join vendedor ven on v.id_vendedor=ven.id_vendedor
where id_venta is null


-- P4. Cross join nombre productos  y clientes

select
p.producto,
c.nombre
from producto p 
cross join clientes c 

-- P5. Union clientes calificacion "A" y "B"

select
nombre,
clasificacion_credito
from clientes
where clasificacion_credito='A'
union
select
nombre,
clasificacion_credito
from
clientes
where clasificacion_credito='B'

-- Cap4. Trabajar con datos

truncate table producto

insert into producto
values ('Terreno'),('Oficina'),('Local'),('Nave'),('Isla'),('Consultorio')

insert into producto
values ('Remates')


update producto
set producto = 'Casa'
where producto = 'producto1'

update producto
set producto = 'Departamento'
where producto = 'Departament'

delete from producto
where producto = 'Departamento'

-- Cap6. Subqueries

select
id_vendedor,
nombre+apellido as nombre_vendedor
from vendedor
where id_vendedor not in 
(select
distinct(id_vendedor)
from ventas
where year(fecha_venta)=2018)


select
id_vendedor,
nombre+apellido as nombre_vendedor
from vendedor ven
where not exists
(select
id_vendedor
from ventas v 
where v.id_vendedor=ven.id_vendedor)



select
producto
from producto
where id_producto not in
(select
distinct(id_producto)
from ventas
where YEAR(fecha_venta)=2017 and MONTH(fecha_venta)=3)


select
id_venta,
id_cliente,
venta,
(select SUM(venta) from ventas
	where id_cliente=v.id_cliente) [venta_cliente],
100*venta/(select SUM(venta) from ventas
	where id_cliente=v.id_cliente) as porcentaje_venta
from ventas v


-- Cap8. Vistas





use [SQL A2]

select*
from ventas

create view clientes_morosos as 
select
morosos.id_cliente,
c.nombre,
SUM(total_deuda) as deuda
from
(select
v.id_venta,
id_cliente,
venta,
sUM(p.pago) as total_pago,
v.venta-sum(p.pago) as total_deuda
from ventas v
join pagos p on p.id_venta=v.id_venta
group by v.id_venta,venta,id_cliente) as morosos
join clientes c on morosos.id_cliente=c.id_cliente
group by morosos.id_cliente,c.nombre 

drop view clientes_morosos

select*
from clientes_morosos

-- Cap9. Procesos almacenados

select*
from producto

create procedure sp_venta_producto 
@producto varchar(20)
as 
select
*
from ventas v
join producto p on v.id_producto=p.id_producto
where p.producto=@producto


execute sp_venta_producto 'oficina'

select*
from ventas

select*
from clientes


create procedure sp_venta_cliente_año
@cliente int = 1,
@año int = 2018,
@venta float output
as
set @venta=
(
select
sum(v.venta) as venta_total
from ventas v
where v.id_cliente=@cliente and YEAR(v.fecha_venta)=@año
)
	
declare @total int
set @total = 0
select @total

execute sp_venta_cliente_año 1,2018, @total output

select @total

drop procedure sp_venta_cliente_año


execute sp_venta_cliente_año 


-- if/case/when

select*,
case 
when venta> 1000000 then 'A'
else 'B' end as bono
from ventas


-- Trigger
select * into clientes_deuda from clientes_morosos

select*
from clientes_deuda


create trigger pago_cliente
 on  pagos
 after insert
 as
 update clientes_deuda
 set deuda=deuda-
 where id_cliente = 1 and 


 select*
from pagos

insert into pagos
values(3337,getdate(),20000)

 -- funciones de ventana

 select*,
 rank() over(order by deuda) as ranking
 from clientes_deuda

 select
 nombre,
 deuda,
sum(case when deuda>0 then 1 else 0 end ) as clientes_morosos
 from clientes_deuda
 group by nombre,deuda

