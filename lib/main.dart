import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Monedas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Conversor de Monedas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Valores iniciales de los dropdown
  String _fromCurrency = 'USD';
  String _toCurrency = 'COP';

  // Controlador para el text input
  final TextEditingController _inputController = TextEditingController();

  // Tasas de conversión
  final Map<String, double> conversionRates = {
    'USD_COP': 4100.0,
    'USD_EUR': 0.85,
    'COP_USD': 0.00024,
    'COP_EUR': 0.00021,
    'EUR_USD': 1.18,
    'EUR_COP': 4800.0,
  };

  // Resultado de la conversión
  double? _convertedValue;

  // Método que realiza la conversión
  // Toma el inputValue del input text, lo multiplica por la tasa correspondiente
  // La tasa se encuentra con el mapa llamado conversionRates a través de la clave
  // La clave se forma tomando los valores de los dropdown
  void _convertCurrency() {
    setState(() {
      // Si el text input es nulo, por defecto toma el valor de 0
      double inputValue = double.tryParse(_inputController.text) ?? 0; 
      String key = '${_fromCurrency}_$_toCurrency';
      double rate = conversionRates[key] ?? 1.0;
      _convertedValue = inputValue * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Monedas'),
      ),
      body: Container(
        color: Colors.lightGreen,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // para que la columna ocupe todo el ancho disponible del widget padre
            children: [
              // TextField entrada para la cantidad
              TextField(
                controller: _inputController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Ingrese la cantidad a convertir',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _convertCurrency(); // Conversión instantánea al copiar texto
                },
              ),
              const SizedBox(height: 20),
        
              // Dropdown para seleccionar la moneda de partida
              DropdownButton<String>(
                value: _fromCurrency,
                items: ['USD', 'COP', 'EUR'].map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _fromCurrency = newValue!;
                  });
                  _convertCurrency();
                },
                isExpanded: true,
                hint: const Text('Desde'),
              ),
              const SizedBox(height: 20),
        
              // Dropdown para seleccionar la moneda objetivo
              DropdownButton<String>(
                value: _toCurrency,
                items: ['USD', 'COP', 'EUR'].map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _toCurrency = newValue!;
                  });
                  _convertCurrency();
                },
                isExpanded: true,
                hint: const Text('Hacia'),
              ),
              const SizedBox(height: 30),
        
              // Mostrar valor convertido si no es nulo
              if (_convertedValue != null)
                Text(
                  'Valor convertido: ${_convertedValue?.toStringAsFixed(2)} $_toCurrency',
                  style: style,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
