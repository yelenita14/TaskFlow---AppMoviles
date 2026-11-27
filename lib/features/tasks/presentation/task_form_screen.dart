import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class TaskDraft {
  const TaskDraft(this.title, this.description, this.priority, {this.dueDate});

  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _description = TextEditingController();

  String? _priority;
  DateTime? _dueDate;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  // Seleccionar una fecha opcional
  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      helpText: 'Selecciona la fecha de entrega',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (selectedDate != null && mounted) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  // Validar y preparar la tarea
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final draft = TaskDraft(
      _title.text.trim(),
      _description.text.trim(),
      _priority!,
      dueDate: _dueDate,
    );

    context.pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Título
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej. Realizar trabajo de programación',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final title = value?.trim() ?? '';

                if (title.isEmpty) {
                  return 'El título es obligatorio.';
                }

                if (title.length < 3) {
                  return 'El título debe tener al menos 3 caracteres.';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            // Descripción
            TextFormField(
              controller: _description,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Describe las actividades que debes realizar',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                final description = value?.trim() ?? '';

                if (description.isEmpty) {
                  return 'La descripción es obligatoria.';
                }

                if (description.length < 5) {
                  return 'Escribe una descripción más detallada.';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            // Prioridad
            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(
                labelText: 'Prioridad',
                prefixIcon: Icon(Icons.flag),
                border: OutlineInputBorder(),
              ),
              items: ['Alta', 'Media', 'Baja']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecciona una prioridad.';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Fecha opcional
            const Text(
              'Fecha de entrega (opcional)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: _selectDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                _dueDate == null
                    ? 'Seleccionar fecha'
                    : MaterialLocalizations.of(context)
                          .formatMediumDate(_dueDate!),
              ),
            ),

            if (_dueDate != null)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _dueDate = null;
                  });
                },
                icon: const Icon(Icons.close),
                label: const Text('Quitar fecha'),
              ),

            const SizedBox(height: 28),

            // Guardar
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text('Guardar tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
