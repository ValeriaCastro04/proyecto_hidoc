import 'package:flutter/material.dart';

/// Citas simuladas organizadas por fecha
final Map<DateTime, List<Map<String, dynamic>>> mockAppointmentsByDate = {
  // Lunes 27 Sept
  DateTime(2025, 9, 27): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientName": "Juan Pérez",
      "reason": "Revisión general",
      "color": Colors.blue,
    },
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientName": "María Gómez",
      "reason": "Consulta dental",
      "color": Colors.green,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientName": "Luis Martínez",
      "reason": "Vacunación",
      "color": Colors.purple,
    },
  ],

  // Martes 28 Sept
  DateTime(2025, 9, 28): [
    {
      "timeStart": 12,
      "timeEnd": 13,
      "patientName": "Carlos López",
      "reason": "Control de presión",
      "color": Colors.orange,
    },
    {
      "timeStart": 16,
      "timeEnd": 17,
      "patientName": "Ana Rodríguez",
      "reason": "Chequeo cardiológico",
      "color": Colors.indigo,
    },
  ],

  // Miércoles 29 Sept
  DateTime(2025, 9, 29): [
    {
      "timeStart": 8,
      "timeEnd": 9,
      "patientName": "Sofía Hernández",
      "reason": "Consulta general",
      "color": Colors.teal,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientName": "Miguel Ramírez",
      "reason": "Revisión de laboratorio",
      "color": Colors.cyan,
    },
    {
      "timeStart": 15,
      "timeEnd": 16,
      "patientName": "Valentina Morales",
      "reason": "Control de diabetes",
      "color": Colors.pink,
    },
  ],

  // Jueves 30 Sept
  DateTime(2025, 9, 30): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientName": "Ricardo Castillo",
      "reason": "Consulta dermatológica",
      "color": Colors.amber,
    },
    {
      "timeStart": 13,
      "timeEnd": 14,
      "patientName": "Isabel Torres",
      "reason": "Control postoperatorio",
      "color": Colors.lime,
    },
    {
      "timeStart": 17,
      "timeEnd": 18,
      "patientName": "Fernando Díaz",
      "reason": "Revisión oftalmológica",
      "color": Colors.deepOrange,
    },
  ],

  // Viernes 1 Oct
  DateTime(2025, 10, 1): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientName": "Patricia Fuentes",
      "reason": "Chequeo general",
      "color": Colors.lightBlue,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientName": "Jorge Sánchez",
      "reason": "Consulta fisioterapia",
      "color": Colors.indigoAccent,
    },
  ],

  // Sábado 2 Oct
  DateTime(2025, 10, 2): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientName": "Gabriela Romero",
      "reason": "Control prenatal",
      "color": Colors.greenAccent,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientName": "Diego Rivera",
      "reason": "Consulta nutricional",
      "color": Colors.deepPurple,
    },
  ],

  // Domingo 3 Oct
  DateTime(2025, 10, 3): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientName": "Carla Jiménez",
      "reason": "Revisión general",
      "color": Colors.redAccent,
    },
  ],

  // Lunes 4 Oct
  DateTime(2025, 10, 4): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientName": "Elena Vargas",
      "reason": "Consulta general",
      "color": Colors.blue,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientName": "Roberto Cruz",
      "reason": "Control hipertensión",
      "color": Colors.green,
    },
    {
      "timeStart": 15,
      "timeEnd": 16,
      "patientName": "Mariana Soto",
      "reason": "Revisión oftalmológica",
      "color": Colors.purple,
    },
  ],

  // Martes 5 Oct
  DateTime(2025, 10, 5): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientName": "Alberto Jiménez",
      "reason": "Consulta nutricional",
      "color": Colors.orange,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientName": "Lucía Peña",
      "reason": "Vacunación",
      "color": Colors.indigo,
    },
  ],

  //Miércoles 6 Oct
  DateTime(2025, 10, 6): [
    {
      "timeStart": 8,
      "timeEnd": 9,
      "patientName": "Daniela Morales",
      "reason": "Chequeo general",
      "color": Colors.teal,
    },
    {
      "timeStart": 13,
      "timeEnd": 14,
      "patientName": "Mario Torres",
      "reason": "Control diabetes",
      "color": Colors.cyan,
    },
    {
      "timeStart": 16,
      "timeEnd": 17,
      "patientName": "Paola Herrera",
      "reason": "Consulta fisioterapia",
      "color": Colors.pink,
    },
  ],

  //Jueves 7 Oct
  DateTime(2025, 10, 7): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientName": "Santiago Ruiz",
      "reason": "Consulta dental",
      "color": Colors.amber,
    },
    {
      "timeStart": 12,
      "timeEnd": 13,
      "patientName": "Claudia Rojas",
      "reason": "Revisión postoperatoria",
      "color": Colors.lime,
    },
    {
      "timeStart": 15,
      "timeEnd": 16,
      "patientName": "Ricardo Flores",
      "reason": "Control presión",
      "color": Colors.deepOrange,
    },
  ],

  //Viernes 8 Oct
  DateTime(2025, 10, 8): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientName": "Valeria Moreno",
      "reason": "Chequeo general",
      "color": Colors.lightBlue,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientName": "Diego Castillo",
      "reason": "Consulta cardiológica",
      "color": Colors.indigoAccent,
    },
  ],

  //Sabado 9 Oct
  DateTime(2025, 10, 9): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientName": "Camila Reyes",
      "reason": "Control prenatal",
      "color": Colors.greenAccent,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientName": "Andrés Molina",
      "reason": "Consulta nutricional",
      "color": Colors.deepPurple,
    },
  ],

  //Domingo 10 Oct
  DateTime(2025, 10, 10): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientName": "Fernanda Salazar",
      "reason": "Revisión general",
      "color": Colors.redAccent,
    },
  ],

  //Lunes 11 Oct
  DateTime(2025, 10, 11): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientName": "Gabriel Paredes",
      "reason": "Consulta general",
      "color": Colors.blue,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientName": "Isabel Mendoza",
      "reason": "Chequeo cardiológico",
      "color": Colors.green,
    },
    {
      "timeStart": 15,
      "timeEnd": 16,
      "patientName": "Javier Soto",
      "reason": "Control de diabetes",
      "color": Colors.purple,
    },
  ],

  //Martes 12 Oct
  DateTime(2025, 10, 12): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientName": "Lorena Castro",
      "reason": "Consulta dental",
      "color": Colors.orange,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientName": "Eduardo Pineda",
      "reason": "Vacunación",
      "color": Colors.indigo,
    },
  ],

  //Miércoles 13 Oct
  DateTime(2025, 10, 13): [
    {
      "timeStart": 8,
      "timeEnd": 9,
      "patientName": "Natalia Vásquez",
      "reason": "Chequeo general",
      "color": Colors.teal,
    },
    {
      "timeStart": 13,
      "timeEnd": 14,
      "patientName": "Felipe Rivas",
      "reason": "Control presión",
      "color": Colors.cyan,
    },
    {
      "timeStart": 16,
      "timeEnd": 17,
      "patientName": "Camila Torres",
      "reason": "Consulta fisioterapia",
      "color": Colors.pink,
    },
  ],

  //Jueves 14 Oct
  DateTime(2025, 10, 14): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientName": "Esteban Vargas",
      "reason": "Consulta dermatológica",
      "color": Colors.amber,
    },
    {
      "timeStart": 12,
      "timeEnd": 13,
      "patientName": "Paula Jiménez",
      "reason": "Revisión oftalmológica",
      "color": Colors.lime,
    },
    {
      "timeStart": 15,
      "timeEnd": 16,
      "patientName": "Diego Hernández",
      "reason": "Control postoperatorio",
      "color": Colors.deepOrange,
    },
  ],

  //Viernes 15 Oct
  DateTime(2025, 10, 15): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientName": "Mariana Fuentes",
      "reason": "Chequeo general",
      "color": Colors.lightBlue,
    },
    {
      "timeStart": 14,
      "timeEnd": 15,
      "patientName": "Sergio Morales",
      "reason": "Consulta cardiológica",
      "color": Colors.indigoAccent,
    },
  ],

  //Sabado 16 Oct
  DateTime(2025, 10, 16): [
    {
      "timeStart": 9,
      "timeEnd": 10,
      "patientName": "Gabriela López",
      "reason": "Control prenatal",
      "color": Colors.greenAccent,
    },
    {
      "timeStart": 11,
      "timeEnd": 12,
      "patientName": "Mauricio Salazar",
      "reason": "Consulta nutricional",
      "color": Colors.deepPurple,
    },
  ],

  //Domingo 17 Oct
  DateTime(2025, 10, 17): [
    {
      "timeStart": 10,
      "timeEnd": 11,
      "patientName": "Ana Beltrán",
      "reason": "Revisión general",
      "color": Colors.redAccent,
    },
  ],
};
