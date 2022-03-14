/* 1 */
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

/* 2 */
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

/* 3 */
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


/* 4 */
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

/* 5 */
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

/* 6 */
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

/* 7 */
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

/* 8 */
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

/* 9 */
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

/* 10 */
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

/* 11 */
SELECT año, mes, nombre, apellido, cantidad_tratamiento FROM (
    SELECT 
        extract(year from e.fecha) año, 
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
            ORDER BY count(tp.fecha) DESC
            FETCH NEXT 1 ROW WITH TIES
    ) p
    WHERE e.id_paciente = p.id_paciente
)UNION(
    SELECT 
        extract(year from e.fecha) año, 
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
            ORDER BY count(tp.fecha) ASC
            FETCH NEXT 1 ROW WITH TIES
    ) p
    WHERE e.id_paciente = p.id_paciente
)
ORDER BY cantidad_tratamiento DESC
;