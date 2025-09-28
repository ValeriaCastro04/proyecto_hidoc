import 'package:flutter/material.dart';

/// Citas simuladas organizadas por fecha
final Map<DateTime, List<Map<String, dynamic>>> mockAppointmentsByDate = {
  // Lunes 27 Sept
  DateTime(2025, 9, 27): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientId": 0, 
      "reason": "Revisión general",
      "color": Colors.blue,
    },
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientId": 1,
      "reason": "Consulta dental",
      "color": Colors.green,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientId": 2,
      "reason": "Vacunación",
      "color": Colors.purple,
    },
  ],

  // Martes 28 Sept
  DateTime(2025, 9, 28): [
    {
      "timeStart": 12,
      "timeEnd": 13,
      "patientId": 3,
      "reason": "Control de presión",
      "color": Colors.orange,
    },
    {
      "timeStart": 16,
      "timeEnd": 17,
      "patientId": 4,
      "reason": "Chequeo cardiológico",
      "color": Colors.indigo,
    },
  ],

  // Miércoles 29 Sept
  DateTime(2025, 9, 29): [
    {
      "timeStart": 8,
      "timeEnd": 9,
      "patientId": 5,
      "reason": "Consulta general",
      "color": Colors.teal,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientId": 6,
      "reason": "Revisión de laboratorio",
      "color": Colors.cyan,
    },
    {
      "timeStart": 15,
      "timeEnd": 16,
      "patientId": 7,
      "reason": "Control de diabetes",
      "color": Colors.pink,
    },
  ],

  // Jueves 30 Sept
  DateTime(2025, 9, 30): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientId": 8,
      "reason": "Consulta dermatológica",
      "color": Colors.amber,
    },
    {
      "timeStart": 13,
      "timeEnd": 14,
      "patientId": 9,
      "reason": "Control postoperatorio",
      "color": Colors.lime,
    },
    {
      "timeStart": 17,
      "timeEnd": 18,
      "patientId": 10,
      "reason": "Revisión oftalmológica",
      "color": Colors.deepOrange,
    },
  ],

  // Viernes 1 Oct
  DateTime(2025, 10, 1): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientId": 11,
      "reason": "Chequeo general",
      "color": Colors.lightBlue,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientId": 12,
      "reason": "Consulta fisioterapia",
      "color": Colors.indigoAccent,
    },
  ],

  // Sábado 2 Oct
  DateTime(2025, 10, 2): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientId": 13,
      "reason": "Control prenatal",
      "color": Colors.greenAccent,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientId": 14,
      "reason": "Consulta nutricional",
      "color": Colors.deepPurple,
    },
  ],

  // Domingo 3 Oct
  DateTime(2025, 10, 3): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientId": 15,
      "reason": "Revisión general",
      "color": Colors.redAccent,
    },
  ],

  // Lunes 4 Oct
  DateTime(2025, 10, 4): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientId": 16,
      "reason": "Consulta general",
      "color": Colors.blue,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientId": 17,
      "reason": "Control hipertensión",
      "color": Colors.green,
    },
    {
      "timeStart": 15,
      "timeEnd": 16,
      "patientId": 18,
      "reason": "Revisión oftalmológica",
      "color": Colors.purple,
    },
  ],

  // Martes 5 Oct
  DateTime(2025, 10, 5): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientId": 19,
      "reason": "Consulta nutricional",
      "color": Colors.orange,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientId": 20,
      "reason": "Vacunación",
      "color": Colors.indigo,
    },
  ],

  //Miércoles 6 Oct
  DateTime(2025, 10, 6): [
    {
      "timeStart": 8,
      "timeEnd": 9,
      "patientId": 21,
      "reason": "Chequeo general",
      "color": Colors.teal,
    },
    {
      "timeStart": 13,
      "timeEnd": 14,
      "patientId": 22,
      "reason": "Control diabetes",
      "color": Colors.cyan,
    },
    {
      "timeStart": 16,
      "timeEnd": 17,
      "patientId": 23,
      "reason": "Consulta fisioterapia",
      "color": Colors.pink,
    },
  ],

  //Jueves 7 Oct
  DateTime(2025, 10, 7): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientId": 24,
      "reason": "Consulta dental",
      "color": Colors.amber,
    },
    {
      "timeStart": 12,
      "timeEnd": 13,
      "patientId": 25,
      "reason": "Revisión postoperatoria",
      "color": Colors.lime,
    },
    {
      "timeStart": 15,
      "timeEnd": 16,
      "patientId": 26,
      "reason": "Control presión",
      "color": Colors.deepOrange,
    },
  ],

  //Viernes 8 Oct
  DateTime(2025, 10, 8): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientId": 27,
      "reason": "Chequeo general",
      "color": Colors.lightBlue,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientId": 28,
      "reason": "Consulta cardiológica",
      "color": Colors.indigoAccent,
    },
  ],

  //Sabado 9 Oct
  DateTime(2025, 10, 9): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientId": 29,
      "reason": "Control prenatal",
      "color": Colors.greenAccent,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientId": 30,
      "reason": "Consulta nutricional",
      "color": Colors.deepPurple,
    },
  ],

  //Domingo 10 Oct
  DateTime(2025, 10, 10): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientId": 31,
      "reason": "Revisión general",
      "color": Colors.redAccent,
    },
  ],

  //Lunes 11 Oct
  DateTime(2025, 10, 11): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientId": 32,
      "reason": "Consulta general",
      "color": Colors.blue,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientId": 33,
      "reason": "Chequeo cardiológico",
      "color": Colors.green,
    },
    {
      "timeStart": 15,
      "timeEnd": 16,
      "patientId": 34,
      "reason": "Control de diabetes",
      "color": Colors.purple,
    },
  ],

  //Martes 12 Oct
  DateTime(2025, 10, 12): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientId": 35,
      "reason": "Consulta dental",
      "color": Colors.orange,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientId": 36,
      "reason": "Vacunación",
      "color": Colors.indigo,
    },
  ],

  //Miércoles 13 Oct
  DateTime(2025, 10, 13): [
    {
      "timeStart": 8,
      "timeEnd": 9,
      "patientId": 37,
      "reason": "Chequeo general",
      "color": Colors.teal,
    },
    {
      "timeStart": 13,
      "timeEnd": 14,
      "patientId": 38,
      "reason": "Control presión",
      "color": Colors.cyan,
    },
    {
      "timeStart": 16,
      "timeEnd": 17,
      "patientId": 39,
      "reason": "Consulta fisioterapia",
      "color": Colors.pink,
    },
  ],

  //Jueves 14 Oct
  DateTime(2025, 10, 14): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientId": 40,
      "reason": "Consulta dermatológica",
      "color": Colors.amber,
    },
    {
      "timeStart": 12,
      "timeEnd": 13,
      "patientId": 41,
      "reason": "Revisión oftalmológica",
      "color": Colors.lime,
    },
    {
      "timeStart": 15,
      "timeEnd": 16,
      "patientId": 42,
      "reason": "Control postoperatorio",
      "color": Colors.deepOrange,
    },
  ],

  //Viernes 15 Oct
  DateTime(2025, 10, 15): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientId": 43,
      "reason": "Chequeo general",
      "color": Colors.lightBlue,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientId": 44,
      "reason": "Consulta cardiológica",
      "color": Colors.indigoAccent,
    },
  ],

  //Sabado 16 Oct
  DateTime(2025, 10, 16): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientId": 45,
      "reason": "Control prenatal",
      "color": Colors.greenAccent,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientId": 46,
      "reason": "Consulta nutricional",
      "color": Colors.deepPurple,
    },
  ],

  //Domingo 17 Oct
  DateTime(2025, 10, 17): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientId": 47,
      "reason": "Revisión general",
      "color": Colors.redAccent,
    },
  ],
};
