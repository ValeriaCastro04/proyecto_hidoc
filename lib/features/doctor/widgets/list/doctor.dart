import 'package:proyecto_hidoc/features/doctor/widgets/list/patients_comments.dart';

final List<Map<String, dynamic>> Doctor = [
  {
    "doctor_id": "DR-001235",
    "name": "Dra. Elena Martínez",
    "specialty": "Medicina General",
    "email": "elena.martinez@hidoc.com",
    "phone": "2234-5678",
    "location": "San Salvador, El Salvador",
    "biography": "Médico general con más de 12 años de experiencia en atención primaria. Especializada en medicina preventiva y cuidados familiares.",
    "years_experience": 12,
    "license": "MD-001235",
    "profile_tabs": {
      "diplomas": [
        {
          "title": "Especialidad en Medicina Familiar",
          "institution": "Universidad Nacional de El Salvador",
          "year": 2015
        },
        {
          "title": "Certificación en Soporte Vital Avanzado",
          "institution": "Asociación Médica Salvadoreña",
          "year": 2020
        }
      ],
      "reviews": patientComments,
      "schedule": {
        "monday": "8:00 AM - 12:00 PM \n2:00 PM - 5:00 PM",
        "tuesday": "8:00 AM - 12:00 PM",
        "wednesday": "8:00 AM - 12:00 PM \n2:00 PM - 5:00 PM",
        "thursday": "8:00 AM - 12:00 PM",
        "friday": "8:00 AM - 12:00 PM \n2:00 PM - 4:00 PM",
        "saturday": "Cerrado",
        "sunday": "Cerrado"
      }
    }
  },
];
