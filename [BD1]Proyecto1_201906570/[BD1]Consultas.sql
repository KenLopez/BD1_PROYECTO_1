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
ORDER BY pacientes_atendidos DESC
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


/* 4 (NO VERIFICADA)*/
SELECT max(nombres) nombre, max(apellidos) apellido, count(tp.id_tratamiento_paciente) cantidad
FROM paciente p, tratamiento_paciente tp, tratamiento t
WHERE
    p.id_paciente = tp.id_paciente
    AND tp.id_tratamiento = t.id_tratamiento
    AND t.nombre = 'Antidepresivos'
GROUP BY p.id_paciente
ORDER BY count(tp.id_tratamiento_paciente) DESC
FETCH NEXT 5 ROWS WITH TIES
;

SELECT nombres, apellidos, COUNT(fecha) cantidad
FROM (
    SELECT P.nombres, P.apellidos, B.fecha
    FROM paciente P, tratamiento T, tratamiento_paciente B
    WHERE P.id_paciente = B.id_paciente
        AND T.id_tratamiento = B.id_tratamiento
        AND T.nombre = 'Antidepresivos'
)
GROUP BY nombres, apellidos
ORDER BY cantidad DESC
FETCH FIRST 5 ROWS ONLY;


/* 5 */

/* 6 */
SELECT max(d.nombre), count(re.id_sintoma) cantidad
FROM resultado_evaluacion re, diagnostico d
WHERE
    re.id_diagnostico = d.id_diagnostico
    AND re.rango = 9
GROUP BY re.id_diagnostico
ORDER BY count(re.id_sintoma) DESC
;

/* 7 */
SELECT p.nombres, p.apellidos, p.direccion
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
    WHERE extract(year from e.fecha) >= 2017
)
SELECT nombre, apellido, round(atendidos / a.total*100, 2) porcentaje
FROM(
    SELECT 
        max(e.nombres) nombre, 
        max(e.apellidos) apellido, 
        count(ev.id_evaluacion) atendidos
    FROM empleado e, evaluacion ev
    WHERE e.id_empleado = ev.id_empleado
    GROUP BY e.id_empleado
), a
ORDER BY atendidos / a.total * 100 DESC
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