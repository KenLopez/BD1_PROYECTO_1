/*Llenar tabla TITULO*/
INSERT INTO TITULO(nombre) 
    SELECT DISTINCT TITULO_DEL_EMPLEADO
    FROM TEMP_DATA
    WHERE TITULO_DEL_EMPLEADO IS NOT NULL
;

/*Llenar tabla SINTOMA*/
INSERT INTO SINTOMA(nombre) 
    SELECT DISTINCT SINTOMA_DEL_PACIENTE
    FROM TEMP_DATA
    WHERE SINTOMA_DEL_PACIENTE IS NOT NULL
;

/*Llenar tabla DIAGNOSTICO*/
INSERT INTO DIAGNOSTICO(nombre)
    SELECT DISTINCT DIAGNOSTICO_DEL_SINTOMA
    FROM TEMP_DATA
    WHERE DIAGNOSTICO_DEL_SINTOMA IS NOT NULL
;

/*Llenar tabla TRATAMIENTO*/
INSERT INTO TRATAMIENTO(nombre)
    SELECT DISTINCT TRATAMIENTO_APLICADO
    FROM TEMP_DATA
    WHERE TRATAMIENTO_APLICADO IS NOT NULL
;

/*Llenar tabla EMPLEADO*/
INSERT INTO EMPLEADO(
    nombres,
    apellidos,
    direccion,
    telefono,
    fecha_nac,
    genero,
    id_titulo
)
    SELECT DISTINCT 
        NOMBRE_EMPLEADO,
        APELLIDO_EMPLEADO,
        DIRECCION_EMPLEADO,
        TO_NUMBER(REPLACE( TELEFONO_EMPLEADO, '-', '' )),
        TO_DATE(FECHA_NACIMIENTO_EMPLEADO,'YYYY-MM-DD'),
        GENERO_EMPLEADO,
        id_titulo
    FROM TEMP_DATA, TITULO
    WHERE TITULO.nombre = TEMP_DATA.TITULO_DEL_EMPLEADO
;

/*Llenar tabla PACIENTE*/
INSERT INTO PACIENTE(
    nombres,
    apellidos,
    direccion,
    telefono,
    fecha_nac,
    genero,
    altura,
    peso
)
    SELECT DISTINCT 
        NOMBRE_PACIENTE,
        APELLIDO_PACIENTE,
        DIRECCION_PACIENTE,
        TO_NUMBER(REPLACE( TELEFONO_PACIENTE, '-', '' )),
        TO_DATE(FECHA_NACIMIENTO_PACIENTE,'YYYY-MM-DD'),
        GENERO_PACIENTE,
        TO_NUMBER(ALTURA),
        TO_NUMBER(PESO)
    FROM TEMP_DATA
    WHERE NOMBRE_PACIENTE IS NOT NULL
;

/*Llenar tabla EVALUACION*/
INSERT INTO EVALUACION(
    fecha,
    id_empleado,
    id_paciente
)
    SELECT DISTINCT 
        TO_DATE(FECHA_EVALUACION,'YYYY-MM-DD'),
        id_empleado,
        id_paciente
    FROM TEMP_DATA tmp, EMPLEADO e, PACIENTE p
    WHERE 
        CONCAT(tmp.NOMBRE_EMPLEADO, tmp.APELLIDO_EMPLEADO) 
            = CONCAT(e.nombres, e.apellidos)
        AND CONCAT(tmp.NOMBRE_PACIENTE, tmp.APELLIDO_PACIENTE) 
            = CONCAT(p.nombres, p.apellidos)
;

/*Llenar tabla TRATAMIENTO_PACIENTE*/
INSERT INTO TRATAMIENTO_PACIENTE(
    fecha,
    id_paciente,
    id_tratamiento
)
    SELECT DISTINCT 
        TO_DATE(FECHA_TRATAMIENTO,'YYYY-MM-DD'),
        id_paciente,
        id_tratamiento
    FROM TEMP_DATA tmp, PACIENTE p, TRATAMIENTO t
    WHERE 
        CONCAT(tmp.NOMBRE_PACIENTE, tmp.APELLIDO_PACIENTE) 
            = CONCAT(p.nombres, p.apellidos)
        AND tmp.TRATAMIENTO_APLICADO = t.nombre
        AND FECHA_TRATAMIENTO IS NOT NULL
;

/*Llenar tabla RESULTADO_EVALUACION*/
INSERT INTO RESULTADO_EVALUACION(
    id_sintoma,
    id_diagnostico,
    id_evaluacion,
    rango
)
    SELECT DISTINCT
        id_sintoma,
        id_diagnostico,
        id_evaluacion,
        TO_NUMBER(RANGO_DEL_DIAGNOSTICO)
    FROM 
        TEMP_DATA tmp, 
        DIAGNOSTICO d, 
        SINTOMA s, 
        EVALUACION ev, 
        PACIENTE p, 
        EMPLEADO e
    WHERE 
        tmp.RANGO_DEL_DIAGNOSTICO IS NOT NULL
        AND ev.id_empleado = e.id_empleado
        AND ev.id_paciente = p.id_paciente
        AND tmp.DIAGNOSTICO_DEL_SINTOMA = d.nombre
        AND tmp.SINTOMA_DEL_PACIENTE = s.nombre
        AND CONCAT(tmp.NOMBRE_EMPLEADO, tmp.APELLIDO_EMPLEADO) 
            = CONCAT(e.nombres, e.apellidos)
        AND CONCAT(tmp.NOMBRE_PACIENTE, tmp.APELLIDO_PACIENTE) 
            = CONCAT(p.nombres, p.apellidos) 
        AND ev.fecha = TO_DATE(tmp.FECHA_EVALUACION,'YYYY-MM-DD')
;