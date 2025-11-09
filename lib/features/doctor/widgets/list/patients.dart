final List<Map<String, dynamic>> Patients = [
  {
    "name": "Roberto Antonio Chávez Delgado",
    "initials": "RC",
    "correo": "roberto.chavez@ejemplo.com",
    "telefono": "7000-0000",
    "numero_DUI": "00000000-0",
    "historial": [
      {
        "fecha_episodio": "2022-07-01",
        "descripcion_general": "Accidente en motocicleta con fractura en el antebrazo izquierdo.",
        "resultados_examenes_fisicos": {
          "detalle": "Deformidad y dolor intenso en antebrazo izquierdo. Pulso radial presente. Radiografía confirma fractura diafisaria de cúbito y radio.",
        },
        "diagnosticos": {
          "detalle": "Fractura cerrada de cúbito y radio (S52.5).",
        },
        "tratamientos": {
          "detalle": "Inmovilización temporal y posterior reducción abierta con fijación interna (RAFI) con placa y tornillos. Analgésicos (Tramadol).",
        },
        "evolucion_enfermedad": {
          "detalle": "Cirugía exitosa. Inicio de rehabilitación post-operatoria a las 4 semanas. Pronóstico de recuperación total en 6 meses."
        }
      },
      {
        "fecha_episodio": "2023-04-12",
        "descripcion_general": "Control de ortopedia y remoción de material de osteosíntesis.",
        "resultados_examenes_fisicos": {
          "detalle": "Movilidad completa del antebrazo y muñeca. Leve atrofia muscular residual. Radiografía muestra consolidación completa de la fractura.",
        },
        "diagnosticos": {
          "detalle": "Secuela de fractura de antebrazo. Estado post-retiro de material de osteosíntesis (Z47.0).",
        },
        "tratamientos": {
          "detalle": "Procedimiento de retiro de placa y tornillos. Continuar con ejercicios de fortalecimiento en casa. Suspender fisioterapia formal.",
        },
        "evolucion_enfermedad": {
          "detalle": "Recuperación completa de la fuerza y función a los 2 meses post-retiro. Dado de alta por el servicio de ortopedia."
        }
      }
    ]
  },
  {
    "name": "Juan Carlos Pérez Gómez",
    "initials": "JP",
    "correo": "juan.perez@ejemplo.com",
    "telefono": "7000-0001",
    "numero_DUI": "00000001-1",
    "historial": [
      {
        "fecha_episodio": "2023-01-15",
        "descripcion_general": "Diagnóstico inicial de Hipertensión Arterial (HTA).",
        "resultados_examenes_fisicos": {
          "detalle": "Presión arterial 160/100 mmHg. No hay otros hallazgos. Exámenes de laboratorio basales normales.",
        },
        "diagnosticos": {
          "detalle": "Hipertensión Arterial Esencial Etapa 2 (I10).",
        },
        "tratamientos": {
          "detalle": "Inicio de Losartán 50mg/día. Dieta baja en sodio y ejercicio moderado.",
        },
        "evolucion_enfermedad": {
          "detalle": "Respuesta adecuada al tratamiento en 4 semanas. PA objetivo alcanzada (130/85 mmHg)."
        }
      },
      {
        "fecha_episodio": "2024-05-20",
        "descripcion_general": "Consulta por síntomas de gastroenteritis aguda.",
        "resultados_examenes_fisicos": {
          "detalle": "PA 128/82 mmHg (controlada). Deshidratación leve, abdomen blando con ruidos hiperactivos.",
        },
        "diagnosticos": {
          "detalle": "Gastroenteritis Viral (A08.3). HTA controlada.",
        },
        "tratamientos": {
          "detalle": "Sueroterapia oral y dieta blanda. No se suspende Losartán. Reposo.",
        },
        "evolucion_enfermedad": {
          "detalle": "Síntomas gastrointestinales resueltos en 72 horas. Se recomienda control de electrolitos post-recuperación."
        }
      },
    ]
  },
  {
    "name": "María Fernanda Gómez López",
    "initials": "MG",
    "correo": "maria.gomez@ejemplo.com",
    "telefono": "7000-0002",
    "numero_DUI": "00000002-2",
    "historial": [
      {
        "fecha_episodio": "2020-11-01",
        "descripcion_general": "Primer episodio de Migraña con aura. Consulta en emergencia.",
        "resultados_examenes_fisicos": {
          "detalle": "Examen neurológico completo sin déficits focales. Presión arterial y fondo de ojo normal. Dolor severo (EVA 9/10).",
        },
        "diagnosticos": {
          "detalle": "Migraña con aura (G43.1).",
        },
        "tratamientos": {
          "detalle": "Sumatriptán subcutáneo en sala de emergencia. Profilaxis con Propranolol iniciada.",
        },
        "evolucion_enfermedad": {
          "detalle": "El Sumatriptán abortó el dolor. La profilaxis ha reducido la frecuencia de las crisis de 4 a 1 por mes."
        }
      },
      {
        "fecha_episodio": "2024-04-10",
        "descripcion_general": "Cefalea tensional por estrés laboral.",
        "resultados_examenes_fisicos": {
          "detalle": "Tensión palpable en músculos trapecios y cervicales. No hay signos de aura. Sensibilidad a la luz leve.",
        },
        "diagnosticos": {
          "detalle": "Cefalea Tensional Episódica (G44.2).",
        },
        "tratamientos": {
          "detalle": "Analgésicos simples (Ibuprofeno). Recomendación de manejo de estrés y ejercicios de estiramiento.",
        },
        "evolucion_enfermedad": {
          "detalle": "El manejo de las crisis de tensión es efectivo. Se mantiene el Propranolol para la migraña."
        }
      },
    ]
  },
  {
    "name": "Carlos Alberto López Hernández",
    "initials": "CL",
    "correo": "carlos.lopez@ejemplo.com",
    "telefono": "7000-0003",
    "numero_DUI": "00000003-3",
    "historial": [
      {
        "fecha_episodio": "2021-08-20",
        "descripcion_general": "Diagnóstico y manejo inicial de Asma del adulto.",
        "resultados_examenes_fisicos": {
          "detalle": "Sibilancias audibles al final de la espiración. Espirometría: FEV1/FVC 65% (obstrucción leve).",
        },
        "diagnosticos": {
          "detalle": "Asma persistente leve (J45.901).",
        },
        "tratamientos": {
          "detalle": "Salbutamol (a demanda). Budesonida inhalada de mantenimiento. Consejería para dejar de fumar.",
        },
        "evolucion_enfermedad": {
          "detalle": "Buen control inicial. Uso de rescate (Salbutamol) 2 veces/semana. Abandona el tabaquismo por 3 meses."
        }
      },
      {
        "fecha_episodio": "2024-06-15",
        "descripcion_general": "Exacerbación de asma por infección viral.",
        "resultados_examenes_fisicos": {
          "detalle": "Saturación de oxígeno 94%. Tos productiva con sibilancias marcadas en ambos campos pulmonares.",
        },
        "diagnosticos": {
          "detalle": "Exacerbación de Asma e Infección Respiratoria Alta (J45.901, J06.9).",
        },
        "tratamientos": {
          "detalle": "Prednisona oral por 5 días. Salbutamol MDI c/4h. Aumentar dosis de Budesonida temporalmente.",
        },
        "evolucion_enfermedad": {
          "detalle": "Resolución de la crisis. La función pulmonar regresó a valores basales en 10 días. Se reitera el plan de acción asmática."
        }
      },
    ]
  },
  {
    "name": "Ana Sofía Rodríguez Martínez",
    "initials": "AR",
    "correo": "ana.rodriguez@ejemplo.com",
    "telefono": "7000-0004",
    "numero_DUI": "00000004-4",
    "historial": [
      {
        "fecha_episodio": "2018-03-10",
        "descripcion_general": "Diagnóstico de Hipotiroidismo Primario.",
        "resultados_examenes_fisicos": {
          "detalle": "Aumento de peso, fatiga y piel áspera. TSH: 15.2 mUI/L (elevada). T4 libre baja.",
        },
        "diagnosticos": {
          "detalle": "Hipotiroidismo primario (E03.9).",
        },
        "tratamientos": {
          "detalle": "Inicio de Levotiroxina 75 mcg/día.",
        },
        "evolucion_enfermedad": {
          "detalle": "TSH en rango normal (2.5 mUI/L) a los 3 meses. Los síntomas sistémicos han desaparecido completamente."
        }
      },
      {
        "fecha_episodio": "2024-07-01",
        "descripcion_general": "Control de rutina y evaluación de Dermatitis de Contacto.",
        "resultados_examenes_fisicos": {
          "detalle": "TSH y T4 libre normales. Parche eritematoso y pruriginoso en mano derecha, compatible con dermatitis.",
        },
        "diagnosticos": {
          "detalle": "Hipotiroidismo estable. Dermatitis de contacto alérgica (L23.9).",
        },
        "tratamientos": {
          "detalle": "Continuar con Levotiroxina. Crema de Propionato de Clobetasol tópica y evitar joyas de níquel.",
        },
        "evolucion_enfermedad": {
          "detalle": "La dermatitis se resolvió en 10 días. Se mantiene bajo control endocrinológico anual."
        }
      },
    ]
  },
  {
    "name": "Luis Enrique Hernández Torres",
    "initials": "LH",
    "correo": "luis.hernandez@ejemplo.com",
    "telefono": "7000-0005",
    "numero_DUI": "00000005-5",
    "historial": [
      {
        "fecha_episodio": "2022-05-01",
        "descripcion_general": "Fractura traumática de Tibia y Peroné en accidente.",
        "resultados_examenes_fisicos": {
          "detalle": "Deformidad evidente en pierna derecha. Incapacidad para el apoyo. Radiografía confirma fractura de trazo oblicuo.",
        },
        "diagnosticos": {
          "detalle": "Fractura diafisaria de tibia y peroné (S82.20).",
        },
        "tratamientos": {
          "detalle": "Reducción abierta y fijación interna con placa y tornillos (osteosíntesis).",
        },
        "evolucion_enfermedad": {
          "detalle": "Consolidación ósea completa a los 6 meses. Fisioterapia intensiva. Retorno total a la actividad deportiva en 1 año."
        }
      },
      {
        "fecha_episodio": "2024-08-05",
        "descripcion_general": "Dolor de rodilla izquierda, no relacionada con la fractura previa.",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor con la rotación y flexión de la rodilla. Bloqueo intermitente. Resonancia Magnética: Lesión en 'asa de balde'.",
        },
        "diagnosticos": {
          "detalle": "Rotura de menisco medial (M23.2).",
        },
        "tratamientos": {
          "detalle": "Artroscopia para menisectomía parcial. Analgésicos post-operatorios.",
        },
        "evolucion_enfermedad": {
          "detalle": "Cirugía exitosa. Inicio de rehabilitación temprana. Pronóstico excelente para recuperación funcional total."
        }
      },
    ]
  },
  {
    "name": "Sofía Alejandra Martínez Ramírez",
    "initials": "SM",
    "correo": "sofia.martinez@ejemplo.com",
    "telefono": "7000-0006",
    "numero_DUI": "00000006-6",
    "historial": [
      {
        "fecha_episodio": "2023-10-01",
        "descripcion_general": "Diagnóstico y manejo de Diabetes Mellitus Tipo 2 (DM2).",
        "resultados_examenes_fisicos": {
          "detalle": "Poliuria y polidipsia. Hemoglobina Glicosilada (HbA1c): 8.5%. Examen físico normal.",
        },
        "diagnosticos": {
          "detalle": "Diabetes Mellitus Tipo 2 (E11.9).",
        },
        "tratamientos": {
          "detalle": "Dieta y ejercicio. Inicio de Metformina 850mg dos veces al día.",
        },
        "evolucion_enfermedad": {
          "detalle": "HbA1c bajó a 7.2% en 3 meses. La paciente reporta cumplimiento del tratamiento dietético."
        }
      },
      {
        "fecha_episodio": "2024-09-10",
        "descripcion_general": "Fiebre y dolor lumbar (posible Infección Urinaria).",
        "resultados_examenes_fisicos": {
          "detalle": "Fiebre (38.9°C), escalofríos. Dolor a la puñopercusión en fosa renal derecha. Glucemia en ayunas 180 mg/dL.",
        },
        "diagnosticos": {
          "detalle": "Pielonefritis aguda (N10). Descompensación diabética.",
        },
        "tratamientos": {
          "detalle": "Ingreso hospitalario. Ciprofloxacino IV por 7 días. Ajuste temporal de Metformina por Insulina de acción rápida.",
        },
        "evolucion_enfermedad": {
          "detalle": "Infección resuelta. La glucemia se controló con insulina. Se dio de alta con un plan de seguimiento nutricional más estricto."
        }
      },
    ]
  },
  {
    "name": "Miguel Ángel Torres Rivera",
    "initials": "MT",
    "correo": "miguel.torres@ejemplo.com",
    "telefono": "7000-0007",
    "numero_DUI": "00000007-7",
    "historial": [
      {
        "fecha_episodio": "2015-06-01",
        "descripcion_general": "Colecistitis aguda y Colecistectomía.",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor en hipocondrio derecho, Murphy positivo. Ultrasonido: Múltiples cálculos en la vesícula biliar. Leucocitosis.",
        },
        "diagnosticos": {
          "detalle": "Colecistitis litiásica aguda (K81.0).",
        },
        "tratamientos": {
          "detalle": "Colecistectomía laparoscópica de urgencia.",
        },
        "evolucion_enfermedad": {
          "detalle": "Recuperación post-operatoria sin incidentes. Cicatrización limpia. Dieta sin grasas por 4 semanas."
        }
      },
      {
        "fecha_episodio": "2024-03-20",
        "descripcion_general": "Síntomas de Dispepsia y dolor epigástrico.",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor ardoroso en la boca del estómago, asociado a las comidas. Prueba de aliento positiva para H. Pylori.",
        },
        "diagnosticos": {
          "detalle": "Gastritis Crónica por Helicobacter Pylori (K29.50).",
        },
        "tratamientos": {
          "detalle": "Esquema de erradicación cuádruple (Omeprazol + 3 antibióticos) por 14 días.",
        },
        "evolucion_enfermedad": {
          "detalle": "Resolución de los síntomas gástricos tras finalizar el tratamiento. Control con prueba de H. Pylori negativa en 6 semanas."
        }
      },
    ]
  },
  {
    "name": "Laura Beatriz Ramírez Castillo",
    "initials": "LR",
    "correo": "laura.ramirez@ejemplo.com",
    "telefono": "7000-0008",
    "numero_DUI": "00000008-8",
    "historial": [
      {
        "fecha_episodio": "2022-07-10",
        "descripcion_general": "Diagnóstico de Depresión Mayor.",
        "resultados_examenes_fisicos": {
          "detalle": "Anhedonia, tristeza profunda, llanto fácil. Puntuación en escala PHQ-9: 22 (Depresión severa).",
        },
        "diagnosticos": {
          "detalle": "Trastorno Depresivo Mayor, episodio único, severo (F32.2).",
        },
        "tratamientos": {
          "detalle": "Sertralina 50mg/día. Inicio de Terapia Cognitivo-Conductual (TCC) semanal.",
        },
        "evolucion_enfermedad": {
          "detalle": "Mejoría lenta. El estado de ánimo mejora, pero la anergia persiste. TCC bien tolerada."
        }
      },
      {
        "fecha_episodio": "2024-05-01",
        "descripcion_general": "Recaída de síntomas depresivos y crisis de insomnio.",
        "resultados_examenes_fisicos": {
          "detalle": "Insomnio de conciliación y mantenimiento. Puntuación PHQ-9: 17 (Depresión moderada).",
        },
        "diagnosticos": {
          "detalle": "Trastorno Depresivo Recurrente, episodio moderado (F33.1). Insomnio.",
        },
        "tratamientos": {
          "detalle": "Aumento de Sertralina a 100mg/día. Adición de Trazodona para el insomnio. Control quincenal.",
        },
        "evolucion_enfermedad": {
          "detalle": "El insomnio mejoró con la Trazodona. Se siente más estable emocionalmente, pero se recomienda continuar con TCC intensiva."
        }
      },
    ]
  },
  {
    "name": "Andrés Felipe Morales Cabrera",
    "initials": "AM",
    "correo": "andres.morales@ejemplo.com",
    "telefono": "7000-0009",
    "numero_DUI": "00000009-9",
    "historial": [
      {
        "fecha_episodio": "2019-02-01",
        "descripcion_general": "Consulta inicial por dolor lumbar crónico.",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor a la palpación de paravertebrales lumbares. Movilidad reducida. Rx de columna: cambios degenerativos leves.",
        },
        "diagnosticos": {
          "detalle": "Lumbago mecánico crónico (M54.5).",
        },
        "tratamientos": {
          "detalle": "Diclofenaco a demanda. Recomendación de estiramiento y pérdida de peso.",
        },
        "evolucion_enfermedad": {
          "detalle": "El dolor se manejó con AINEs, pero el paciente abusó de ellos, causando molestias gástricas."
        }
      },
      {
        "fecha_episodio": "2024-02-28",
        "descripcion_general": "Reevaluación del dolor lumbar por pobre respuesta a AINEs.",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor irradiado a glúteo. Lasegue negativo. Refiere sensación de 'quemazón'.",
        },
        "diagnosticos": {
          "detalle": "Lumbago crónico con componente neuropático.",
        },
        "tratamientos": {
          "detalle": "Suspender AINEs. Inicio de Gabapentina. Fisioterapia para fortalecer el CORE.",
        },
        "evolucion_enfermedad": {
          "detalle": "El dolor neuropático se controla con Gabapentina. La fisioterapia mejora la postura y reduce la intensidad de los episodios de dolor."
        }
      },
    ]
  },
  {
    "name": "Claudia Patricia Méndez Rivas",
    "initials": "CM",
    "correo": "claudia.mendez@ejemplo.com",
    "telefono": "7000-0010",
    "numero_DUI": "00000010-0",
    "historial": [
      {
        "fecha_episodio": "2017-04-01",
        "descripcion_general": "Diagnóstico y tratamiento de Cáncer de Mama.",
        "resultados_examenes_fisicos": {
          "detalle": "Masa palpable en cuadrante superior externo de mama derecha. Biopsia positiva para Carcinoma Ductal Invasivo.",
        },
        "diagnosticos": {
          "detalle": "Neoplasia maligna de mama, estadio IIB (C50.4).",
        },
        "tratamientos": {
          "detalle": "Mastectomía parcial. Quimioterapia adyuvante por 6 ciclos. Radioterapia. Inicio de Tamoxifeno (Hormonoterapia).",
        },
        "evolucion_enfermedad": {
          "detalle": "Remisión completa de la enfermedad. Mantiene controles oncológicos semestrales con Tamoxifeno."
        }
      },
      {
        "fecha_episodio": "2024-01-12",
        "descripcion_general": "Control oncológico anual y hallazgo de Hipotiroidismo subclínico.",
        "resultados_examenes_fisicos": {
          "detalle": "Mamografía negativa. TSH: 5.8 mUI/L (ligeramente elevada). No hay síntomas de hipotiroidismo.",
        },
        "diagnosticos": {
          "detalle": "Seguimiento post-tratamiento de neoplasia mamaria (Z08.0). Hipotiroidismo subclínico (E03.9).",
        },
        "tratamientos": {
          "detalle": "Continuar con Tamoxifeno. Inicio de Levotiroxina 50 mcg/día para normalizar TSH.",
        },
        "evolucion_enfermedad": {
          "detalle": "La TSH ha vuelto a la normalidad. La paciente continúa en remisión oncológica sin evidencia de recidiva."
        }
      },
    ]
  },
  {
    "name": "José Antonio Castillo Vargas",
    "initials": "JC",
    "correo": "jose.castillo@ejemplo.com",
    "telefono": "7000-0011",
    "numero_DUI": "00000011-1",
    "historial": [
      {
        "fecha_episodio": "2023-09-05",
        "descripcion_general": "Vacunación de rutina y control general de salud.",
        "resultados_examenes_fisicos": {
          "detalle": "Examen físico normal. Peso y talla en rango normal. Sin antecedentes patológicos.",
        },
        "diagnosticos": {
          "detalle": "Paciente sano (Z00.0).",
        },
        "tratamientos": {
          "detalle": "Vacuna contra la influenza y el tétanos.",
        },
        "evolucion_enfermedad": {
          "detalle": "Completó esquema de vacunación anual. Se recomienda mantener el ejercicio regular."
        }
      },
      {
        "fecha_episodio": "2024-07-20",
        "descripcion_general": "Cuadro febril tras viaje al exterior.",
        "resultados_examenes_fisicos": {
          "detalle": "Fiebre (39.5°C), mialgias intensas. Prueba rápida de Dengue (NS1) positiva. Plaquetas 80,000.",
        },
        "diagnosticos": {
          "detalle": "Dengue con signos de alarma (A90).",
        },
        "tratamientos": {
          "detalle": "Manejo intrahospitalario por 48h. Hidratación intravenosa estricta. Control de hematocrito y plaquetas cada 6 horas.",
        },
        "evolucion_enfermedad": {
          "detalle": "Plaquetas en ascenso. El paciente afebril tras 72h. Dado de alta con reposo absoluto y vigilancia domiciliaria."
        }
      },
    ]
  },
  {
    "name": "Gabriela Marcela Pineda Cruz",
    "initials": "GP",
    "correo": "gabriela.pineda@ejemplo.com",
    "telefono": "7000-0012",
    "numero_DUI": "00000012-2",
    "historial": [
      {
        "fecha_episodio": "2020-03-15",
        "descripcion_general": "Diagnóstico de Endometriosis y manejo inicial.",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor pélvico crónico e intenso durante la menstruación (dismenorrea). Laparoscopia: implantes endometriósicos leves.",
        },
        "diagnosticos": {
          "detalle": "Endometriosis pélvica (N80.9).",
        },
        "tratamientos": {
          "detalle": "Anticonceptivos orales combinados en pauta continua para suprimir la menstruación.",
        },
        "evolucion_enfermedad": {
          "detalle": "La dismenorrea se reduce significativamente. Continúa con terapia hormonal."
        }
      },
      {
        "fecha_episodio": "2024-06-08",
        "descripcion_general": "Dolor pélvico agudo intercurrente.",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor agudo en fosa ilíaca izquierda. Ecografía: quiste ovárico funcional de 3 cm. Terapia hormonal al día.",
        },
        "diagnosticos": {
          "detalle": "Quiste Ovárico Funcional (N83.2). Endometriosis estable.",
        },
        "tratamientos": {
          "detalle": "Analgésicos y reposo. Control ecográfico en 8 semanas para evaluar la involución del quiste.",
        },
        "evolucion_enfermedad": {
          "detalle": "El dolor se resolvió en 5 días. El quiste se reabsorbió espontáneamente en el control de seguimiento."
        }
      },
    ]
  },
  {
    "name": "Fernando Augusto Delgado Reyes",
    "initials": "FD",
    "correo": "fernando.delgado@ejemplo.com",
    "telefono": "7000-0013",
    "numero_DUI": "00000013-3",
    "historial": [
      {
        "fecha_episodio": "2023-11-20",
        "descripcion_general": "Consulta de control y hallazgo de Dislipidemia.",
        "resultados_examenes_fisicos": {
          "detalle": "IMC 31. Circunferencia abdominal elevada. Perfil lipídico: Colesterol total: 280 mg/dL, Triglicéridos: 450 mg/dL.",
        },
        "diagnosticos": {
          "detalle": "Dislipidemia mixta severa (E78.2). Obesidad Clase I (E66.9).",
        },
        "tratamientos": {
          "detalle": "Dieta hipocalórica y ejercicio. Inicio de Atorvastatina 40 mg/noche y Fenofibrato 160 mg/día.",
        },
        "evolucion_enfermedad": {
          "detalle": "Pérdida de 3 kg en 3 meses. Colesterol mejoró a 240 mg/dL. Los triglicéridos bajaron a 350 mg/dL."
        }
      },
      {
        "fecha_episodio": "2024-05-15",
        "descripcion_general": "Control de seguimiento y ajuste de tratamiento.",
        "resultados_examenes_fisicos": {
          "detalle": "Peso estable. PA 135/85 mmHg. Nuevo perfil lipídico: Colesterol total: 220 mg/dL, Triglicéridos: 280 mg/dL.",
        },
        "diagnosticos": {
          "detalle": "Dislipidemia en mejoría. Obesidad persistente.",
        },
        "tratamientos": {
          "detalle": "Suspender Fenofibrato. Continuar Atorvastatina. Referencia a nutricionista para manejo agresivo de peso.",
        },
        "evolucion_enfermedad": {
          "detalle": "Mejoría notable en los lípidos. Necesita enfocarse en la pérdida de peso para reducir el riesgo cardiovascular."
        }
      },
    ]
  },
  {
    "name": "Patricia Elena Soto Méndez",
    "initials": "PS",
    "correo": "patricia.soto@ejemplo.com",
    "telefono": "7000-0014",
    "numero_DUI": "00000014-4",
    "historial": [
      {
        "fecha_episodio": "2022-01-01",
        "descripcion_general": "Diagnóstico de Artritis Reumatoide (AR).",
        "resultados_examenes_fisicos": {
          "detalle": "Rigidez matutina >1 hora. Hinchazón dolorosa en articulaciones metacarpofalángicas. Factor Reumatoide positivo.",
        },
        "diagnosticos": {
          "detalle": "Artritis Reumatoide Seropositiva (M05.9).",
        },
        "tratamientos": {
          "detalle": "Metotrexato oral semanal. Ácido fólico. Prednisona en dosis bajas (5mg/día).",
        },
        "evolucion_enfermedad": {
          "detalle": "El dolor y la rigidez articular disminuyeron. La actividad de la enfermedad se considera moderada."
        }
      },
      {
        "fecha_episodio": "2024-04-25",
        "descripcion_general": "Reagudización de AR por estrés.",
        "resultados_examenes_fisicos": {
          "detalle": "Inflamación de rodilla derecha y muñecas. VSG y PCR elevados. Rigidez matutina de 2 horas.",
        },
        "diagnosticos": {
          "detalle": "Exacerbación de Artritis Reumatoide (M05.9).",
        },
        "tratamientos": {
          "detalle": "Aumento temporal de la dosis de Prednisona. Infiltración de corticoides en rodilla. Fisioterapia.",
        },
        "evolucion_enfermedad": {
          "detalle": "La inflamación de la rodilla remitió. La paciente debe iniciar terapia con biológicos si persiste la actividad de la enfermedad."
        }
      },
    ]
  },
  {
    "name": "Ricardo Daniel Fuentes López",
    "initials": "RF",
    "correo": "ricardo.fuentes@ejemplo.com",
    "telefono": "7000-0015",
    "numero_DUI": "00000015-5",
    "historial": [
      {
        "fecha_episodio": "2023-02-10",
        "descripcion_general": "Primer episodio severo de alergia primaveral.",
        "resultados_examenes_fisicos": {
          "detalle": "Edema palpebral, rinorrea acuosa y estornudos. Pruebas cutáneas positivas para polen de gramíneas.",
        },
        "diagnosticos": {
          "detalle": "Rinoconjuntivitis alérgica estacional (J30.1).",
        },
        "tratamientos": {
          "detalle": "Antihistamínico (Fexofenadina) y corticoide nasal (Fluticasona) durante la estación.",
        },
        "evolucion_enfermedad": {
          "detalle": "El tratamiento controló los síntomas. Se recomienda evitar la exposición al polen en las mañanas."
        }
      },
      {
        "fecha_episodio": "2024-03-05",
        "descripcion_general": "Prevención y manejo de la temporada alérgica.",
        "resultados_examenes_fisicos": {
          "detalle": "Congestión nasal leve al inicio de la primavera. No hay conjuntivitis.",
        },
        "diagnosticos": {
          "detalle": "Rinitis alérgica estacional (J30.1), profilaxis.",
        },
        "tratamientos": {
          "detalle": "Reiniciar Fexofenadina y Fluticasona de manera preventiva.",
        },
        "evolucion_enfermedad": {
          "detalle": "Control total de los síntomas alérgicos en esta temporada. Se siente mucho mejor que el año anterior."
        }
      },
    ]
  },
  {
    "name": "Valeria Isabel Campos Herrera",
    "initials": "VC",
    "correo": "valeria.campos@ejemplo.com",
    "telefono": "7000-0016",
    "numero_DUI": "00000016-6",
    "historial": [
      {
        "fecha_episodio": "2022-09-01",
        "descripcion_general": "Consulta post-parto por dolor en la muñeca (Muñeca de la madre).",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor en la base del pulgar derecho, exacerbado al levantar a los bebés. Prueba de Finkelstein positiva.",
        },
        "diagnosticos": {
          "detalle": "Tenosinovitis de De Quervain (M65.4).",
        },
        "tratamientos": {
          "detalle": "Inmovilización con férula de pulgar. AINEs (naproxeno) y terapia física.",
        },
        "evolucion_enfermedad": {
          "detalle": "El dolor mejoró parcialmente. Se remite para posible infiltración."
        }
      },
      {
        "fecha_episodio": "2024-07-05",
        "descripcion_general": "Control de muñeca y nueva queja por dolor en el codo.",
        "resultados_examenes_fisicos": {
          "detalle": "Muñeca estable. Dolor en el epicóndilo lateral del codo derecho. Dolor al agarrar objetos.",
        },
        "diagnosticos": {
          "detalle": "Epicondilitis lateral ('Codo de tenista') (M77.1).",
        },
        "tratamientos": {
          "detalle": "Brazalete de contrafuerza. Terapia física enfocada. Evitar movimientos repetitivos de agarre.",
        },
        "evolucion_enfermedad": {
          "detalle": "El dolor del codo disminuyó en 5 semanas. Continúa con ejercicios de fortalecimiento en casa."
        }
      },
    ]
  },
  {
    "name": "Héctor Manuel Ramírez Ortiz",
    "initials": "HR",
    "correo": "hector.ramirez@ejemplo.com",
    "telefono": "7000-0017",
    "numero_DUI": "00000017-7",
    "historial": [
      {
        "fecha_episodio": "2010-01-01",
        "descripcion_general": "Primer episodio de Cólico Nefrítico.",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor lumbar intenso que irradia a ingle. Vómitos. Examen de orina con hematuria. TAC: Cálculo de 7 mm en pelvis renal.",
        },
        "diagnosticos": {
          "detalle": "Litiasis renal (N20.0).",
        },
        "tratamientos": {
          "detalle": "Litotricia extracorpórea por ondas de choque (LEOC). Aumento de ingesta de líquidos.",
        },
        "evolucion_enfermedad": {
          "detalle": "El cálculo se fragmentó y expulsó. Se inicia terapia dietética preventiva para oxalato de calcio."
        }
      },
      {
        "fecha_episodio": "2024-01-20",
        "descripcion_general": "Recurrencia de Cólico Nefrítico.",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor lumbar izquierdo. Uro-TAC: cálculo de 5 mm en uréter proximal. Sin fiebre.",
        },
        "diagnosticos": {
          "detalle": "Litiasis ureteral (N20.1).",
        },
        "tratamientos": {
          "detalle": "Analgésicos (Ketorolaco). Bloqueador alfa (Tamsulosina) para facilitar el paso del cálculo.",
        },
        "evolucion_enfermedad": {
          "detalle": "El cálculo fue expulsado a las 3 semanas. Se le recuerda la importancia de la hidratación y se programa visita con nefrólogo."
        }
      },
    ]
  },
  {
    "name": "Natalia Andrea Jiménez Flores",
    "initials": "NJ",
    "correo": "natalia.jimenez@ejemplo.com",
    "telefono": "7000-0018",
    "numero_DUI": "00000018-8",
    "historial": [
      {
        "fecha_episodio": "2023-05-15",
        "descripcion_general": "Neumonía por COVID-19.",
        "resultados_examenes_fisicos": {
          "detalle": "Fiebre, tos seca, disnea. Oximetría 88% aire ambiente. Rx tórax: Infiltrados bilaterales periféricos.",
        },
        "diagnosticos": {
          "detalle": "Neumonía por COVID-19, severa (U07.1).",
        },
        "tratamientos": {
          "detalle": "Hospitalización, oxígeno suplementario. Remdesivir y Dexametasona.",
        },
        "evolucion_enfermedad": {
          "detalle": "Supera la fase aguda en 10 días. Se da de alta con disnea residual leve."
        }
      },
      {
        "fecha_episodio": "2024-03-22",
        "descripcion_general": "Seguimiento por Disnea persistente (Long COVID).",
        "resultados_examenes_fisicos": {
          "detalle": "Disnea de esfuerzo. Espirometría con patrón restrictivo leve. Capacidad de difusión reducida.",
        },
        "diagnosticos": {
          "detalle": "Secuelas Post-COVID / Síndrome de Long COVID (U09.9). Fibrosis leve.",
        },
        "tratamientos": {
          "detalle": "Programa de rehabilitación pulmonar. Inhalador de acción prolongada.",
        },
        "evolucion_enfermedad": {
          "detalle": "La tolerancia al ejercicio ha mejorado. La paciente todavía necesita el inhalador en días de actividad física intensa."
        }
      },
    ]
  },
  {
    "name": "Diego Alejandro Cruz Molina",
    "initials": "DC",
    "correo": "diego.cruz@ejemplo.com",
    "telefono": "7000-0019",
    "numero_DUI": "00000019-9",
    "historial": [
      {
        "fecha_episodio": "2020-10-01",
        "descripcion_general": "Inicio de síntomas de Reflujo Gastroesofágico (ERGE).",
        "resultados_examenes_fisicos": {
          "detalle": "Pirosis (acidez) que empeora en la noche. Endoscopia: Esofagitis de Los Angeles Grado A.",
        },
        "diagnosticos": {
          "detalle": "Enfermedad por Reflujo Gastroesofágico con Esofagitis (K21.0).",
        },
        "tratamientos": {
          "detalle": "Omeprazol 20 mg/día. Medidas higiénico-dietéticas (evitar café, chocolate, grasas).",
        },
        "evolucion_enfermedad": {
          "detalle": "Control aceptable, pero tiende a suspender el tratamiento cuando se siente bien, resultando en recurrencias."
        }
      },
      {
        "fecha_episodio": "2024-08-18",
        "descripcion_general": "Recurrencia de Pirosis y dolor retroesternal.",
        "resultados_examenes_fisicos": {
          "detalle": "Pirosis diaria, regurgitación ácida. Endoscopia: Esofagitis Grado B.",
        },
        "diagnosticos": {
          "detalle": "ERGE con esofagitis recurrente (K21.0).",
        },
        "tratamientos": {
          "detalle": "Omeprazol 40 mg/día por 8 semanas. Reeducación dietética estricta y elevación de la cabecera de la cama.",
        },
        "evolucion_enfermedad": {
          "detalle": "Mejoría sintomática total. Se recomienda mantener Omeprazol a dosis bajas y vigilancia por posible Esófago de Barrett."
        }
      },
    ]
  },
  {
    "name": "Paola Cristina Vargas Estrada",
    "initials": "PV",
    "correo": "paola.vargas@ejemplo.com",
    "telefono": "7000-0020",
    "numero_DUI": "00000020-0",
    "historial": [
      {
        "fecha_episodio": "2022-03-01",
        "descripcion_general": "Diagnóstico de Fibromialgia.",
        "resultados_examenes_fisicos": {
          "detalle": "Dolor generalizado crónico. Dolor a la palpación en 14 de 18 puntos gatillo. Excluidas otras causas reumatológicas.",
        },
        "diagnosticos": {
          "detalle": "Fibromialgia (M79.7).",
        },
        "tratamientos": {
          "detalle": "Amitriptilina 25mg/noche. Ejercicio aeróbico de bajo impacto (caminata). Terapia psicológica.",
        },
        "evolucion_enfermedad": {
          "detalle": "La calidad del sueño mejoró. El dolor persistía con actividad intensa. Se mantuvo en un nivel de dolor 6/10."
        }
      },
      {
        "fecha_episodio": "2024-05-11",
        "descripcion_general": "Aumento del dolor y fatiga.",
        "resultados_examenes_fisicos": {
          "detalle": "Fatiga extrema y empeoramiento del dolor. Se descarta hipotiroidismo y otras causas.",
        },
        "diagnosticos": {
          "detalle": "Fibromialgia, reagudización (M79.7).",
        },
        "tratamientos": {
          "detalle": "Adición de Pregabalina para el dolor neuropático. Terapia con un especialista en dolor crónico.",
        },
        "evolucion_enfermedad": {
          "detalle": "La combinación de medicamentos ha reducido la intensidad del dolor. La fatiga sigue siendo el síntoma más limitante."
        }
      },
    ]
  },
];
