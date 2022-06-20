USE ESCUELA
/* Consultas a resolver 

insertar 5 tuplas adicionales en curso_has_estudiante
1. Listar los alumnos con estatus de regular (considere que un alumno 
   regular puede tener no aprobada como máximo una materia)
2. Listar el porcentaje de no aprobados por materia en los semestres 
   20212 y 20221 
3. Listar los profesores que aprobaron a todos sus alumnos en todas 
   sus materias
4. Listar los profesores con el mayor porcentaje de no aprobados en 
   los semestres 20212 y 20221
5. Determinar si en la materia T302 existe un porcentaje de no aprobados 
   entre el 30% y 50% en cada uno de sus grupos.
6. Listar los alumnos que han aprobado todas las asignaturas que imparte 
   el profesor  10275287*/

/*insertar 5 tuplas adicionales en curso_has_estudiante*/

insert into estudiante values ('2019640553','Jose','Gómez', 'García');
insert into estudiante values ('2016640553','Martin','Martinez','García');
insert into estudiante values ('2017640553','Beatriz','Garcia','Medina');
insert into estudiante values ('2018640553','Ivonne','Ferreira', 'García');
insert into estudiante values ('2015640553','Marcos','Juarez','Sanchez');

insert into materia values ('T501');
insert into materia values ('T602');
insert into materia values ('T703');
insert into materia values ('T804');
insert into materia values ('T905');

insert into curso values ('20211', '2TM9','T501','98074241',30);
insert into curso values ('20211', '3TM4','T602','98074241',30);
insert into curso values ('20211', '2TV10','T703','10074288',30);
insert into curso values ('20211', '3TM3','T804','10275287',30);
insert into curso values ('20212', '2TV12','T905','10275287',30);

insert into curso_has_estudiante values ('20211', '2TM9','T501','2019640553', 7);
insert into curso_has_estudiante values ('20211', '3TM4','T602','2016640553', 8);
insert into curso_has_estudiante values ('20211', '2TV10','T703','2017640553', 9);
insert into curso_has_estudiante values ('20211', '3TM3','T804','2018640553', 10);
insert into curso_has_estudiante values ('20212', '2TV12','T905','2015640553', 5);


/*1. Listar los alumnos con estatus de regular (considere que un alumno 
regular puede tener no aprobada como máximo una materia)*/

create view listaC as select cu.idEstudiante, cu.idMateria, cu.calificacion
From curso_has_estudiante as ch inner join curso_has_estudiante as ch2 
on cu.idEstudiante = cu2.idEstudiante and cu.idMateria = cu2.idMateria 
where cu.calificacion between 6 and 10 or cu2.calificacion between 0 and 5;

create view can_reprobadas as
select C.idEstudiante ,C.idMateria,C.calificacion,count(C.calificacion) as reprobadas 
from listaC as C
group by C.idEstudiante
having C.calificacion < 6; 

select cu.idEstudiante, cu.idMateria, cu.calificacion
From curso_has_estudiante as cu inner join curso_has_estudiante as cu2 
on cu.idEstudiante = cu2.idEstudiante and cu.idMateria = cu2.idMateria 
where cu.calificacion > 5 or cu2.calificacion < 6;

create view can_aprobadas as
select C.idEstudiante ,C.idMateria,C.calificacion,count(C.calificacion) as aprobadas 
from listaC as C 
group by C.idEstudiante
having C.calificacion > 6;


/*2 listar el numero de no aprobados por materia en los semestres 20212 y 20221*/

select count(cu.idEstudiante)*100/12 as no_aprobados
From curso_has_estudiante as ch
where cu.calificacion < 6 and (cu.semestre = '20212' or cu.semestre='20221');

/*3. listar los profesores que aprobaron a todos sus alumnos en todas sus materias*/

select distinct idprofesor
from Curso as cu, curso_has_estudiante as Es
where cu.Grupo=es.grupo and calificacion >5;


/*4. Listar los profesores con el mayor porcentaje de no aprobados en los 
semestres 20212 y 20221*/

create view noaprobadosSemestres as 
select distinct c.idProfesor, cu.idmateria, cu.idEstudiante,cu.calificacion, c.semestre
from curso_has_estudiante cu inner join curso c 
on  cu.idMateria = c.idMateria and cu.semestre = c.semestre and cu.grupo = cu.grupo
where calificacion < 6 and (c.semestre = '20212' or c.semestre ="20221");

create view porcentajeReprobados as
select idProfesor, count(idProfesor)*100/5 as porcentaje_reprobados
from noaprobadosSemestres 
group by idProfesor; 

select idProfesor,Max(porcentaje_reprobados)
from porcentajeReprobados;

 
/*5. Determinar si en la materia T302 existe un porcentaje de no aprobados 
entre el 30% y 50% en cada uno de sus grupos.*/

create view noaprobadosT302 as
select distinct c.idProfesor, cu.idmateria, cu.idEstudiante,cu.calificacion, cu.grupo
from curso_has_estudiante ch inner join curso c 
on  cu.idMateria = c.idMateria and cu.semestre = c.semestre and cu.grupo = cu.grupo
where calificacion < 6 and cu.idMateria = 'T302';

create view porcentajeReprobadosT302 as
select idMateria, grupo, count(idMateria)*100/5 as porcentaje_reprobados
from noaprobadosT302 
group by idMateria; 

select * from porcentajeReprobadosT302
where porcentaje_reprobados between 30 and 50;

/*6. Listar los alumnos que han aprobado todas las asignaturas que imparte 
el profesor  10275287*/

select distinct c.idProfesor, cu.idmateria, cu.idEstudiante,cu.calificacion
from curso_has_estudiante cu inner join curso c 
on  cu.idMateria = c.idMateria and cu.semestre = c.semestre and cu.grupo = cu.grupo
where calificacion > 5 and c.idProfesor ='10275287'