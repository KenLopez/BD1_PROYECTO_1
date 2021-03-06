/*DROP TABLES*/
DROP TABLE TITULO CASCADE CONSTRAINTS;
DROP TABLE SINTOMA CASCADE CONSTRAINTS;
DROP TABLE DIAGNOSTICO CASCADE CONSTRAINTS;
DROP TABLE TRATAMIENTO CASCADE CONSTRAINTS;
DROP TABLE EMPLEADO CASCADE CONSTRAINTS;
DROP TABLE PACIENTE CASCADE CONSTRAINTS;
DROP TABLE EVALUACION CASCADE CONSTRAINTS;
DROP TABLE TRATAMIENTO_PACIENTE;
DROP TABLE RESULTADO_EVALUACION;

DROP TABLE TEMP_DATA;

/*CREATE TABLES*/
CREATE TABLE TITULO (
    id_titulo INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(50) NOT NULL,
    PRIMARY KEY(id_titulo)
);

CREATE TABLE SINTOMA (
    id_sintoma INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(50) NOT NULL,
    PRIMARY KEY(id_sintoma)
);

CREATE TABLE DIAGNOSTICO (
    id_diagnostico INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(50) NOT NULL,
    PRIMARY KEY(id_diagnostico)
);

CREATE TABLE TRATAMIENTO (
    id_tratamiento INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(50) NOT NULL,
    PRIMARY KEY(id_tratamiento)
);

CREATE TABLE EMPLEADO (
    id_empleado INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    nombres VARCHAR2(50) NOT NULL,
    apellidos VARCHAR2(50) NOT NULL,
    direccion VARCHAR2(50) NOT NULL,
    telefono INTEGER NOT NULL,
    fecha_nac DATE NOT NULL,
    genero CHAR(1) NOT NULL,
    id_titulo INTEGER NOT NULL,
    PRIMARY KEY(id_empleado),
    FOREIGN KEY(id_titulo) REFERENCES TITULO(id_titulo),
    CONSTRAINT check_genero_empleado CHECK (genero = 'M' OR genero = 'F')
);

CREATE TABLE PACIENTE (
    id_paciente INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    nombres VARCHAR2(50) NOT NULL,
    apellidos VARCHAR2(50) NOT NULL,
    direccion VARCHAR2(50) NOT NULL,
    telefono INTEGER NOT NULL,
    fecha_nac DATE NOT NULL,
    genero CHAR(1) NOT NULL,
    altura FLOAT NOT NULL, 
    peso FLOAT NOT NULL,
    PRIMARY KEY(id_paciente),
    CONSTRAINT check_genero_paciente CHECK (genero = 'M' OR genero = 'F')
);

CREATE TABLE EVALUACION (
    id_evaluacion INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    fecha DATE NOT NULL,
    id_empleado INTEGER NOT NULL,
    id_paciente INTEGER NOT NULL,
    PRIMARY KEY(id_evaluacion),
    FOREIGN KEY(id_empleado) REFERENCES EMPLEADO(id_empleado),
    FOREIGN KEY(id_paciente) REFERENCES PACIENTE(id_paciente)
);

CREATE TABLE TRATAMIENTO_PACIENTE (
    id_tratamiento_paciente INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    id_paciente INTEGER NOT NULL,
    id_tratamiento INTEGER NOT NULL,
    fecha DATE NOT NULL,
    PRIMARY KEY(id_tratamiento_paciente),
    FOREIGN KEY(id_paciente) REFERENCES PACIENTE(id_paciente),
    FOREIGN KEY(id_tratamiento) REFERENCES TRATAMIENTO(id_tratamiento)
);

CREATE TABLE RESULTADO_EVALUACION (
    id_resultado INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    id_sintoma INTEGER NOT NULL,
    id_diagnostico INTEGER NOT NULL,
    id_evaluacion INTEGER NOT NULL,
    rango INTEGER NOT NULL,
    PRIMARY KEY(id_resultado),
    FOREIGN KEY(id_sintoma) REFERENCES SINTOMA(id_sintoma),
    FOREIGN KEY(id_diagnostico) REFERENCES DIAGNOSTICO(id_diagnostico),
    FOREIGN KEY(id_evaluacion) REFERENCES EVALUACION(id_evaluacion),
    CONSTRAINT check_rango CHECK (rango BETWEEN 1 AND 10)
);

/*TEMP TABLE*/
CREATE TABLE TEMP_DATA (
    NOMBRE_EMPLEADO VARCHAR2(50),
    APELLIDO_EMPLEADO VARCHAR2(50),
    DIRECCION_EMPLEADO VARCHAR2(50),
    TELEFONO_EMPLEADO VARCHAR2(20),
    GENERO_EMPLEADO VARCHAR2(1),
    FECHA_NACIMIENTO_EMPLEADO VARCHAR2(10),
    TITULO_DEL_EMPLEADO VARCHAR2(50),
    NOMBRE_PACIENTE VARCHAR2(50),
    APELLIDO_PACIENTE VARCHAR2(50),
    DIRECCION_PACIENTE VARCHAR2(50),
    TELEFONO_PACIENTE VARCHAR2(20),
    GENERO_PACIENTE VARCHAR2(1),
    FECHA_NACIMIENTO_PACIENTE VARCHAR2(10),
    ALTURA VARCHAR2(10),
    PESO VARCHAR2(10),
    FECHA_EVALUACION VARCHAR2(10),
    SINTOMA_DEL_PACIENTE VARCHAR2(50),
    DIAGNOSTICO_DEL_SINTOMA VARCHAR2(50),
    RANGO_DEL_DIAGNOSTICO VARCHAR2(50),
    FECHA_TRATAMIENTO VARCHAR2(10),
    TRATAMIENTO_APLICADO VARCHAR2(50)
);