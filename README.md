# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero visualizar mis tareas para conocer las       actividades que debo realizar.
   Criterio: la pantalla principal muestra las cinco tareas con su título, prioridad y estado.
2. Como estudiante, quiero consultar el detalle de una tarea para conocer su descripción y demás información.
   Criterio: al seleccionar una tarjeta se muestra el detalle de la tarea correspondiente.
3. Como estudiante, quiero registrar nuevas actividades para organizar el desarrollo de TaskFlow.
   Criterio: el formulario futuro permite ingresar los datos de una tarea válida y agregarla a la lista.
4. Como estudiante, quiero editar una tarea para actualizar su información cuando sea necesario.
   Criterio: los cambios guardados se reflejan en la lista y en el detalle de cada tarea.
5. Como estudiante, quiero eliminar tareas que ya no necesito para mantener organizada mi lista.
   Criterio: después de confirmar al eliminar una tarea, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: muestra las tareas mediante tarjetas con título, prioridad y estado. En futuras versiones permitirá crear tareas.
Detalle: presenta la información completa de la tarea seleccionada y permitirá incorporar acciones para editar o eliminar.
Formulario: pantalla futura para registrar o modificar tareas mediante campos de título, descripción y prioridad.

### Requisitos no funcionales
La interfaz debe presentar información clara y comprendida.
La navegación entre la lista y el detalle debe ser sencilla.
Las tareas deben tener identificadores únicos.
Si se consulta un identificador inexistente, la aplicación debe mostrar un mensaje informativo en lugar de cerrarse.

### Contrato de API que necesitaremos
GET      /tasks         Consultar todas las tareas
GET      /tasks/:id     Consultar una tarea específica
POST     /tasks         Registrar una nueva tarea
PATCH    /tasks/:id     Actualizar parcialmente una tarea
DELETE   /tasks/:id     Eliminar una tarea

La API concreta se elegirá después. Estas rutas son requisitos, no
direcciones de un servidor ya conectado.
