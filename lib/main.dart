import 'package:flutter/material.dart';

void main() {
  runApp(const BemEstarApp());
}

class BemEstarApp extends StatelessWidget {
  const BemEstarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bem Estar — ODS 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    MedicationPage(),
    HabitsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bem Estar — ODS 3')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'Medicação'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Hábitos'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Bem-vindo ao app Bem Estar!', style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class Medication {
  final String name;
  final String dosage;
  final String time; // ex.: "08:00"

  Medication({required this.name, required this.dosage, required this.time});
}

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _timeController = TextEditingController();

  final List<Medication> _items = [];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _addMedication() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _items.add(Medication(
          name: _nameController.text.trim(),
          dosage: _dosageController.text.trim(),
          time: _timeController.text.trim(),
        ));
      });
      _nameController.clear();
      _dosageController.clear();
      _timeController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicação adicionada')),
      );
    }
  }

  void _removeMedication(int index) {
    final removed = _items[index];
    setState(() {
      _items.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removido: ${removed.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Formulário
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do remédio',
                    hintText: 'Ex.: Paracetamol',
                    prefixIcon: Icon(Icons.medication),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o nome do remédio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dosageController,
                  decoration: const InputDecoration(
                    labelText: 'Dosagem',
                    hintText: 'Ex.: 500 mg',
                    prefixIcon: Icon(Icons.scale),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe a dosagem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _timeController,
                  readOnly: true, // impede digitação manual
                  decoration: const InputDecoration(
                    labelText: 'Horário',
                    hintText: 'Selecione um horário',
                    prefixIcon: Icon(Icons.schedule),
                  ),
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _timeController.text = picked.format(context);
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Selecione o horário';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addMedication,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar medicação'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Lista
          Expanded(
            child: _items.isEmpty
                ? const Center(
              child: Text('Nenhuma medicação cadastrada ainda'),
            )
                : ListView.separated(
              itemBuilder: (context, index) {
                final med = _items[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.medication)),
                  title: Text(med.name),
                  subtitle: Text('${med.dosage} • ${med.time}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeMedication(index),
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: _items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Aqui você acompanhará seus hábitos saudáveis.', style: Theme.of(context).textTheme.titleLarge),
    );
  }
}