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

Las rutas anteriores representan el contrato de API previsto para futuras funcionalidades de TaskFlow. Actualmente, la aplicación utiliza JSONPlaceholder para consultar tareas mediante GET /todos.

## API de tareas

### Conexión con la API
TaskFlow utiliza la API JSONPlaceholder para consultar tareas de forma remota mediante el paquete Dio.
- URL: https://jsonplaceholder.typicode.com
- Recurso: /todos
- Método HTTP: GET
- Parámetro: userId=2
- URL completa de consulta: https://jsonplaceholder.typicode.com/todos?userId=2

### Parámetro de consulta
Se utiliza el parámetro userId para obtener las tareas correspondientes a un usuario específico. Para esta adaptación del proyecto se seleccionó el usuario 2.

### Campos recibidos
La API proporciona los siguientes campos:
- userId: identificador del usuario.
- id: identificador de la tarea.
- title: título de la tarea.
- completed: estado de finalización.

### Valores predeterminados
El modelo Task, mediante el método Task.fromJson, transforma los datos recibidos y completa los campos que no proporciona la API:
- description: "Sin descripción (API)".
- priority: "Sin prioridad (API)".
El campo completed se adapta al atributo isCompleted del modelo Task.

### Arquitectura de consulta
La aplicación utiliza la siguiente cadena de responsabilidades:
Service → Repository → ViewModel
- Service: realiza la petición HTTP mediante Dio.
- Repository: administra la fuente de datos y entrega las tareas.
- ViewModel: gestiona la información que utiliza la interfaz.
La consulta utiliza Future, async y await para trabajar de forma asíncrona.

### Actualización del estado de las tareas
Actualmente, marcar una tarea como completada modifica únicamente la copia de la tarea en memoria mediante copyWith. Este cambio no se envía al servidor ni se conserva después de reiniciar la aplicación.

### Comprobación
Se verifica la conexión mediante el código HTTP 200, que indica que la consulta se realizó correctamente.
El usuario seleccionado para esta adaptación es el usuario 2.

## Semana 4 Sesión 8

### Objetivo
Implementar el manejo de estados asíncronos en TaskFlow para diferenciar la carga de información, la disponibilidad de tareas, las respuestas vacías y los errores de conexión, incorporando la opción de reintentar la consulta sin reiniciar la aplicación.

### Gestión de estados
Se actualizaron los archivos tasks_view_model.dart y task_list_screen.dart para controlar los diferentes estados de la aplicación.
Se implementaron los siguientes estados:
- Carga: muestra un indicador CircularProgressIndicator mientras se realiza la petición al servidor.
- Éxito: muestra la lista de tareas obtenidas desde JSONPlaceholder.
- Vacío: muestra el mensaje "Todavía no hay tareas para mostrar" cuando la consulta devuelve una lista sin elementos.
- Error: muestra el mensaje "No se pudieron cargar las tareas" cuando ocurre un problema durante la consulta y presenta el botón Reintentar.

### Herramientas y funcionalidades utilizadas
- ChangeNotifier: notifica los cambios de estado del ViewModel.
- context.watch: permite observar los cambios del ViewModel y actualizar la interfaz.
- context.read: permite ejecutar acciones desde los botones.
- Future y async/await: permiten realizar consultas asíncronas.
- try/catch/finally: permiten controlar los errores y finalizar el estado de carga.
- RefreshIndicator: permite actualizar la lista deslizando hacia abajo.
- Botón Actualizar: permite realizar una nueva consulta al servidor.
- Botón Reintentar: permite repetir la consulta después de un error.

### Pruebas realizadas
1. Estado de éxito
Se realizó una consulta a JSONPlaceholder utilizando el usuario 2. Se verificó que las tareas se mostraran correctamente en la pantalla principal y que fuera posible acceder al detalle de cada tarea.
2. Estado de carga
Se verificó el indicador de carga mientras la aplicación realizaba la petición de información al servidor.
3. Estado vacío
Se cambió temporalmente el valor de userId de 2 a 9999 en task_api_service.dart. Al realizar la consulta, la aplicación mostró el mensaje "Todavía no hay tareas para mostrar" y el botón Actualizar.
Después de la prueba se restauró el valor original userId = 2.
4. Estado de error
Se desactivó la conexión a internet del emulador y se solicitó actualizar la lista. La aplicación mostró el mensaje "No se pudieron cargar las tareas" y el botón Reintentar.
5. Prueba de reintento
Se restableció la conexión a internet y se pulsó el botón Reintentar. La aplicación volvió a consultar el servidor y recuperó la lista de tareas sin necesidad de reiniciarla.

### Resultado obtenido

TaskFlow diferencia correctamente los estados de carga, éxito, vacío y error. Además, permite actualizar y recuperar la información mediante los botones correspondientes, conservando la navegación entre la lista y el detalle de las tareas.


## Semana 5 Sesión 9

### Objetivo
Implementar un formulario para registrar nuevas tareas en TaskFlow, incorporando campos de texto, validaciones y selección de prioridad.

### Funcionalidades implementadas
- Formulario de creación de tareas utilizando Form.
- Validación del título: campo obligatorio y mínimo 3 caracteres.
- Validación de la descripción: campo obligatorio y mínimo 5 caracteres.
- Controladores TextEditingController para obtener los datos ingresados.
- Selector de prioridad mediante DropdownButtonFormField.
- Selector de fecha de entrega utilizando showDatePicker.
- Fecha de entrega opcional, no obligatoria para guardar.
- Mensajes personalizados para los errores de validación.
- Botón Guardar para validar y preparar los datos de la tarea.
- Botón Cancelar para regresar a la lista sin enviar información.
- Retorno de los datos mediante TaskDraft y context.pop(draft).

### Validaciones realizadas
Se realizaron pruebas para comprobar el funcionamiento del formulario:
1. Título vacío: muestra un mensaje de error.
2. Título de dos caracteres: muestra un mensaje indicando que se requieren al menos tres caracteres.
3. Título válido: permite continuar cuando los demás campos son correctos.
4. Fecha opcional: permite preparar una tarea sin seleccionar una fecha.
5. Cancelar: regresa a la pantalla de tareas sin mostrar el mensaje de formulario válido.
6. Mensaje de retorno: muestra el título de la tarea después de guardar el borrador.

### Resultado
Se implementó un formulario funcional con validaciones, controladores, selector de prioridad y fecha de entrega opcional. Los datos se preparan como un borrador temporal y se devuelven a la pantalla anterior.