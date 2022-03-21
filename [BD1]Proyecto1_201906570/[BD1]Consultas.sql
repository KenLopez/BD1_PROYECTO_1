/* 1 Mostrar el nombre, apellido y teléfono de todos los empleados y la cantidad
de pacientes atendidos por cada empleado ordenados de mayor a menor. */
SELECT 
    max(nombres) nombre, 
    max(apellidos) apellido, 
    max(telefono) telefono, 
    count(evaluacion.id_paciente) pacientes_atendidos
FROM empleado, evaluacion
WHERE empleado.id_empleado = evaluacion.id_empleado
GROUP BY evaluacion.id_empleado
ORDER BY pacientes_atendidos DESC
;

/* 2 Mostrar el nombre, apellido, dirección y título de todos los empleados de sexo
masculino que atendieron a más de 3 pacientes en el año 2016. */
SELECT 
    max(nombres) nombre, 
    max(apellidos) apellido, 
    max(direccion) direccion, 
    max(titulo.nombre) titulo_academico,
    count(evaluacion.id_paciente) pacientes_atendidos
FROM empleado, evaluacion, titulo
WHERE 
    empleado.id_empleado = evaluacion.id_empleado
    AND empleado.id_titulo = titulo.id_titulo
    AND empleado.genero = 'M'
    AND extract(year from evaluacion.fecha) = 2016
GROUP BY evaluacion.id_empleado
HAVING 
    count(evaluacion.id_paciente) > 3
;

/* 3 Mostrar el nombre y apellido de todos los pacientes que se están aplicando el
tratamiento “Tabaco en polvo” y que tuvieron el síntoma “Dolor de cabeza”. */
SELECT DISTINCT nombres, apellidos
FROM paciente p
WHERE 
    EXISTS (
        SELECT p.id_paciente from tratamiento_paciente tp, tratamiento t
        WHERE  
            tp.id_paciente = p.id_paciente
            AND tp.id_tratamiento = t.id_tratamiento
            AND t.nombre = 'Tabaco en polvo'
    )
    AND EXISTS (
        SELECT p.id_paciente from evaluacion e, resultado_evaluacion re, sintoma s 
        WHERE 
            e.id_paciente = p.id_paciente
            AND e.id_evaluacion = re.id_evaluacion
            AND re.id_sintoma = s.id_sintoma
            AND s.nombre = 'Dolor de cabeza'
    )
;


/* 4 Top 5 de pacientes que más tratamientos se han aplicado del tratamiento
“Antidepresivos”. Mostrar nombre, apellido y la cantidad de tratamientos. */
SELECT max(nombres) nombre, max(apellidos) apellido, count(tp.id_tratamiento_paciente) cantidad
FROM paciente p, tratamiento_paciente tp, tratamiento t
WHERE
    p.id_paciente = tp.id_paciente
    AND tp.id_tratamiento = t.id_tratamiento
    AND t.nombre = 'Antidepresivos'
GROUP BY p.id_paciente
ORDER BY 3 DESC
FETCH NEXT 5 ROWS ONLY
;

/* 5 Mostrar el nombre, apellido y dirección de todos los pacientes que se hayan
aplicado más de 3 tratamientos y no hayan sido atendidos por un
empleado. Debe mostrar la cantidad de tratamientos que se aplicó el
paciente. Ordenar los resultados de mayor a menor utilizando la cantidad de
tratamientos. */
SELECT 
    max(p.nombres) nombre, 
    max(p.apellidos) apellido,
    max(p.direccion) direccion,
    count(tp.id_tratamiento_paciente) cantidad_tratamientos
FROM paciente p, tratamiento_paciente tp
WHERE 
    NOT EXISTS (
        SELECT e.id_paciente
        FROM evaluacion e
        WHERE e.id_paciente = p.id_paciente
    )
    AND tp.id_paciente = p.id_paciente
GROUP BY p.id_paciente
HAVING count(tp.id_tratamiento_paciente) > 3
;

/* 6 Mostrar el nombre del diagnóstico y la cantidad de síntomas a los que ha sido
asignado donde el rango ha sido de 9. Ordene sus resultados de mayor a
menor en base a la cantidad de síntomas. */
SELECT MAX(d.nombre) descripcion, COUNT(id_sintoma) cantidad
FROM (
    SELECT DISTINCT id_diagnostico id_d, id_sintoma 
        FROM resultado_evaluacion 
    WHERE rango = 9
),
diagnostico d 
where id_d = d.id_diagnostico
GROUP BY id_d
ORDER BY 2 DESC
;

/* 7 Mostrar el nombre, apellido y dirección de todos los pacientes que
presentaron un síntoma que al que le fue asignado un diagnóstico con un
rango mayor a 5. Debe mostrar los resultados en orden alfabético tomando
en cuenta el nombre y apellido del paciente. */
SELECT DISTINCT p.nombres, p.apellidos, p.direccion
FROM paciente p
WHERE EXISTS (
    SELECT re.id_resultado
    FROM evaluacion e, resultado_evaluacion re
    WHERE
        p.id_paciente  = e.id_paciente
        AND e.id_evaluacion = re.id_evaluacion
        AND re.rango > 5
)
ORDER BY p.nombres, p.apellidos
;

/* 8 Mostrar el nombre, apellido y fecha de nacimiento de todos los empleados de
sexo femenino cuya dirección es “1475 Dryden Crossing” y hayan atendido
por lo menos a 2 pacientes. Mostrar la cantidad de pacientes atendidos por
el empleado y ordénelos de mayor a menor. */
SELECT nombre, apellido, fecha_nacimiento, atendidos 
FROM(
    SELECT 
        max(e.nombres) nombre, 
        max(e.apellidos) apellido, 
        max(e.fecha_nac) fecha_nacimiento, 
        count(ev.id_paciente) atendidos
    FROM empleado e, evaluacion ev
    WHERE 
        e.id_empleado = ev.id_empleado
        AND e.genero = 'F'
        AND e.direccion = '1475 Dryden Crossing'
    GROUP BY e.id_empleado
)
WHERE atendidos > 2
;

/* 9 Mostrar el porcentaje de pacientes que ha atendido cada empleado a partir
del año 2017 y mostrarlos de mayor a menor en base al porcentaje calculado. */
WITH a AS (
    SELECT count(e.id_evaluacion) total
    FROM evaluacion e
)
SELECT nombre, apellido, round(atendidos/a.total*100, 2) porcentaje
FROM(
    SELECT 
        max(e.nombres) nombre, 
        max(e.apellidos) apellido, 
        count(ev.id_evaluacion) atendidos
    FROM empleado e, evaluacion ev
    WHERE 
        e.id_empleado = ev.id_empleado
        AND extract(year from ev.fecha) >= 2017
    GROUP BY e.id_empleado
), a
ORDER BY 3 DESC
;

/* 10 .Mostrar el porcentaje del título de empleado más común de la siguiente
manera: nombre del título, porcentaje de empleados que tienen ese
título. Debe ordenar los resultados en base al porcentaje de mayor a menor. */
WITH conteo AS(
    SELECT count(id_empleado) total
    FROM empleado
)
SELECT titulo, round(titulos/conteo.total*100, 2) porcentaje
FROM(
    SELECT max(t.nombre) titulo, count(e.id_empleado) titulos
    FROM titulo t, empleado e
    WHERE 
        t.id_titulo = e.id_titulo
    GROUP BY t.id_titulo
), conteo
ORDER BY porcentaje DESC
;

/* 11 Mostrar el año y mes (de la fecha de evaluación) junto con el nombre y
apellido de los pacientes que más tratamientos se han aplicado y los que
menos. (Todo en una sola consulta). Nota: debe tomar como cantidad
mínima 1 tratamiento. */
SELECT anio, mes, nombre, apellido, cantidad_tratamiento FROM (
    SELECT 
        extract(year from e.fecha) anio, 
        extract(month from e.fecha) mes,
        p.nombre,
        p.apellido, 
        p.cantidad_tratamiento
    FROM evaluacion e, (
        SELECT 
                max(p.id_paciente) id_paciente,
                max(p.nombres) nombre,
                max(p.apellidos) apellido,
                count(tp.fecha) cantidad_tratamiento
            FROM tratamiento_paciente tp, paciente p
            WHERE tp.id_paciente = p.id_paciente
            GROUP BY
                p.id_paciente
            ORDER BY 4 DESC
            FETCH NEXT 1 ROW WITH TIES
    ) p
    WHERE e.id_paciente = p.id_paciente
)UNION(
    SELECT 
        extract(year from e.fecha) anio, 
        extract(month from e.fecha) mes,
        p.nombre,
        p.apellido, 
        p.cantidad_tratamiento
    FROM evaluacion e, (
        SELECT 
                max(p.id_paciente) id_paciente,
                max(p.nombres) nombre,
                max(p.apellidos) apellido,
                count(tp.fecha) cantidad_tratamiento
            FROM tratamiento_paciente tp, paciente p
            WHERE tp.id_paciente = p.id_paciente
            GROUP BY
                p.id_paciente
            ORDER BY 4 ASC
            FETCH NEXT 1 ROW WITH TIES
    ) p
    WHERE e.id_paciente = p.id_paciente
)
ORDER BY cantidad_tratamiento DESC
;