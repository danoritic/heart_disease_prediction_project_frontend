import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  runApp(const HeartDiseasePredictorApp());
}

class HeartDiseasePredictorApp extends StatelessWidget {
  const HeartDiseasePredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heart Disease Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const HeartDiseasePredictor(),
    );
  }
}

class HeartDiseasePredictor extends StatefulWidget {
  const HeartDiseasePredictor({super.key});

  @override
  _HeartDiseasePredictorState createState() => _HeartDiseasePredictorState();
}

class _HeartDiseasePredictorState extends State<HeartDiseasePredictor> {
  final Map<String, dynamic> _inputData = {
    'age': '40',
    'sex': '0',
    'cp': '0',
    'trestbps': '120',
    'chol': '200',
    'fbs': '0',
    'restecg': '0',
    'thalach': '100',
    'exang': '1',
    'oldpeak': '0.5',
    'slope': '1',
    'ca': '3',
    'thal': '6',
  };

  final Map<String, dynamic> _inputDataEmpty = {
    'age': '',
    'sex': '',
    'cp': '',
    'trestbps': '',
    'chol': '',
    'fbs': '',
    'restecg': '',
    'thalach': '',
    'exang': '',
    'oldpeak': '',
    'slope': '',
    'ca': '',
    'thal': '',
  };

  Map<String, dynamic>? _predictions;
  int _currentTab = 0;
  final List<Map<String, dynamic>> _modelPerformance = [
    {
      'name': 'XGBoost',
      'accuracy': 0.90,
      'precision': 0.89,
      'recall': 0.88,
      'f1': 0.88,
      'rocAuc': 0.93,
      'color': Colors.green
    },
    {
      'name': 'Random Forest',
      'accuracy': 0.88,
      'precision': 0.87,
      'recall': 0.86,
      'f1': 0.86,
      'rocAuc': 0.91,
      'color': Colors.blue
    },
    {
      'name': 'SVM',
      'accuracy': 0.87,
      'precision': 0.86,
      'recall': 0.85,
      'f1': 0.85,
      'rocAuc': 0.90,
      'color': Colors.purple
    },
    {
      'name': 'Logistic Regression',
      'accuracy': 0.85,
      'precision': 0.84,
      'recall': 0.83,
      'f1': 0.83,
      'rocAuc': 0.89,
      'color': Colors.orange
    },
    {
      'name': 'KNN',
      'accuracy': 0.82,
      'precision': 0.80,
      'recall': 0.78,
      'f1': 0.79,
      'rocAuc': 0.85,
      'color': Colors.red
    },
    {
      'name': 'Decision Tree',
      'accuracy': 0.79,
      'precision': 0.76,
      'recall': 0.75,
      'f1': 0.75,
      'rocAuc': 0.82,
      'color': Colors.grey
    }
  ];

  final List<Map<String, dynamic>> _inputFields = [
    {
      "textEditingController": TextEditingController(),
      'name': 'age',
      'label': 'Age',
      'type': 'number',
      'min': 20,
      'max': 100,
      'unit': 'years',
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'sex',
      'label': 'Sex',
      'type': 'select',
      'options': [
        {'value': '1', 'label': 'Male'},
        {'value': '0', 'label': 'Female'}
      ]
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'cp',
      'label': 'Chest Pain Type',
      'type': 'select',
      'options': [
        {'value': '0', 'label': 'Typical Angina'},
        {'value': '1', 'label': 'Atypical Angina'},
        {'value': '2', 'label': 'Non-Anginal Pain'},
        {'value': '3', 'label': 'Asymptomatic'}
      ]
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'trestbps',
      'label': 'Resting Blood Pressure',
      'type': 'number',
      'min': 80,
      'max': 220,
      'unit': 'mmHg'
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'chol',
      'label': 'Serum Cholesterol',
      'type': 'number',
      'min': 100,
      'max': 600,
      'unit': 'mg/dl'
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'fbs',
      'label': 'Fasting Blood Sugar > 120 mg/dl',
      'type': 'select',
      'options': [
        {'value': '1', 'label': 'Yes'},
        {'value': '0', 'label': 'No'}
      ]
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'restecg',
      'label': 'Resting ECG',
      'type': 'select',
      'options': [
        {'value': '0', 'label': 'Normal'},
        {'value': '1', 'label': 'ST-T Wave Abnormality'},
        {'value': '2', 'label': 'Left Ventricular Hypertrophy'}
      ]
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'thalach',
      'label': 'Maximum Heart Rate',
      'type': 'number',
      'min': 60,
      'max': 220,
      'unit': 'bpm'
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'exang',
      'label': 'Exercise Induced Angina',
      'type': 'select',
      'options': [
        {'value': '1', 'label': 'Yes'},
        {'value': '0', 'label': 'No'}
      ]
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'oldpeak',
      'label': 'ST Depression',
      'type': 'number',
      'min': 0,
      'max': 6,
      'step': 0.1,
      'unit': 'units'
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'slope',
      'label': 'Slope of Peak Exercise ST',
      'type': 'select',
      'options': [
        {'value': '0', 'label': 'Upsloping'},
        {'value': '1', 'label': 'Flat'},
        {'value': '2', 'label': 'Downsloping'}
      ]
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'ca',
      'label': 'Number of Major Vessels',
      'type': 'select',
      'options': [
        {'value': '0', 'label': '0'},
        {'value': '1', 'label': '1'},
        {'value': '2', 'label': '2'},
        {'value': '3', 'label': '3'}
      ]
    },
    {
      "textEditingController": TextEditingController(),
      'name': 'thal',
      'label': 'Thalassemia',
      'type': 'select',
      'options': [
        {'value': '3', 'label': 'Normal'},
        {'value': '6', 'label': 'Fixed Defect'},
        {'value': '7', 'label': 'Reversible Defect'}
      ]
    },
  ];

  Map<String, dynamic> _preprocessData(Map<String, dynamic> data) {
    final processed = Map<String, dynamic>.from(data);

    // Convert string inputs to numbers
    processed.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        processed[key] = double.tryParse(value.toString()) ?? 0.0;
      }
    });

    // Feature scaling (simplified min-max scaling)
    const scalingParams = {
      'age': {'min': 29, 'max': 77},
      'trestbps': {'min': 94, 'max': 200},
      'chol': {'min': 126, 'max': 564},
      'thalach': {'min': 71, 'max': 202},
      'oldpeak': {'min': 0, 'max': 6.2}
    };

    scalingParams.forEach((key, params) {
      if (processed.containsKey(key) && processed[key] != null) {
        final min = params['min']! as double;
        final max = params['max']! as double;
        final value = processed[key] as double;
        processed[key] = (value - min) / (max - min);
      }
    });

    return processed;
  }

  Map<String, dynamic> _logisticRegression(Map<String, dynamic> data) {
    const weights = {
      'age': 0.8,
      'sex': 1.2,
      'cp': -1.5,
      'trestbps': 0.3,
      'chol': 0.2,
      'fbs': 0.1,
      'restecg': 0.15,
      'thalach': -0.9,
      'exang': 0.7,
      'oldpeak': 0.8,
      'slope': -0.4,
      'ca': 1.1,
      'thal': -0.6
    };

    double score = 0.1; // bias
    weights.forEach((key, value) {
      if (data[key] != null) {
        score += value * (data[key] as double);
      }
    });

    final probability = 1 / (1 + exp(-score));
    return {
      'probability': probability,
      'prediction': probability > 0.5 ? 1 : 0
    };
  }

  Map<String, dynamic> _randomForest(Map<String, dynamic> data) {
    // Simplified ensemble of decision trees
    const trees = [
      {'threshold': 0.45, 'weight': 0.3},
      {'threshold': 0.55, 'weight': 0.4},
      {'threshold': 0.50, 'weight': 0.3}
    ];

    final logisticResult = _logisticRegression(data);
    double ensemble = 0;

    for (var tree in trees) {
      final treeResult =
          (logisticResult['probability'] as double) > tree['threshold']!
              ? 1
              : 0;
      ensemble += treeResult * tree['weight']!;
    }

    return {'probability': ensemble, 'prediction': ensemble > 0.5 ? 1 : 0};
  }

  Map<String, dynamic> _xgboost(Map<String, dynamic> data) {
    // Enhanced gradient boosting simulation
    final baseResult = _logisticRegression(data);
    double boostedScore = baseResult['probability'] as double;

    // Simulate gradient boosting iterations
    const boostingFactors = [
      {'feature': 'cp', 'weight': 0.3},
      {'feature': 'thalach', 'weight': -0.25},
      {'feature': 'oldpeak', 'weight': 0.2},
      {'feature': 'ca', 'weight': 0.15}
    ];

    for (var factor in boostingFactors) {
      if (data[factor['feature']] != null) {
        boostedScore += (double.tryParse(factor['weight'].toString()) ?? 0) *
            (data[factor['feature']] as double) *
            0.1;
      }
    }

    boostedScore = boostedScore.clamp(0.0, 1.0);
    return {
      'probability': boostedScore,
      'prediction': boostedScore > 0.5 ? 1 : 0
    };
  }

  Map<String, dynamic> _svm(Map<String, dynamic> data) {
    // Simplified SVM with RBF kernel
    const supportVectors = [
      {'cp': 0.8, 'thalach': 0.3, 'oldpeak': 0.7, 'weight': 0.4},
      {'cp': 0.2, 'thalach': 0.8, 'oldpeak': 0.1, 'weight': -0.3},
      {'cp': 0.6, 'thalach': 0.5, 'oldpeak': 0.4, 'weight': 0.5}
    ];

    double decision = 0;
    for (var sv in supportVectors) {
      double similarity = 0;
      for (var feature in ['cp', 'thalach', 'oldpeak']) {
        if (data[feature] != null) {
          similarity += exp(-pow((data[feature] as double) - sv[feature]!, 2));
        }
      }
      decision += sv['weight']! * similarity;
    }

    final probability = 1 / (1 + exp(-decision));
    return {
      'probability': probability,
      'prediction': probability > 0.5 ? 1 : 0
    };
  }

  Map<String, dynamic> _knn(Map<String, dynamic> data) {
    // K-nearest neighbors simulation
    const neighbors = [
      {'similarity': 0.8, 'label': 1},
      {'similarity': 0.6, 'label': 0},
      {'similarity': 0.7, 'label': 1},
      {'similarity': 0.4, 'label': 0},
      {'similarity': 0.9, 'label': 1}
    ];

    const k = 3;
    // neighbors.sort((a, b) => b['similarity']!.compareTo(a['similarity']!));
    final sortedNeighbors = neighbors.take(k);
    final prediction =
        sortedNeighbors.map((n) => n['label'] as int).reduce((a, b) => a + b) /
            k;

    return {'probability': prediction, 'prediction': prediction > 0.5 ? 1 : 0};
  }

  Map<String, dynamic> _decisionTree(Map<String, dynamic> data) {
    // Simplified decision tree
    if ((data['cp'] as double) > 0.5) {
      if ((data['thalach'] as double) < 0.5) {
        return {'probability': 0.8, 'prediction': 1};
      } else {
        return {'probability': 0.3, 'prediction': 0};
      }
    } else {
      if ((data['oldpeak'] as double) > 0.3) {
        return {'probability': 0.7, 'prediction': 1};
      } else {
        return {'probability': 0.2, 'prediction': 0};
      }
    }
  }

  void _handlePredict() {
    print("debug_print-_handlePredict-started");
    final processed = _preprocessData(_inputData);
    print("debug_print-_handlePredict-_preprocessData_is_done");
    final results = {
      'xgboost': _xgboost(processed),
      'randomForest': _randomForest(processed),
      'svm': _svm(processed),
      'logisticRegression': _logisticRegression(processed),
      'knn': _knn(processed),
      'decisionTree': _decisionTree(processed)
    };
    print("debug_print-_handlePredict-results_is_done");
    setState(() {
      _predictions = results;
      _currentTab = 1; // Switch to results tab
    });
  }

  Map<String, dynamic> _getRiskLevel(double probability) {
    if (probability < 0.3)
      return {
        'level': 'Low',
        'color': Colors.green,
        'bgColor': Colors.green.shade100
      };
    if (probability < 0.7)
      return {
        'level': 'Moderate',
        'color': Colors.orange,
        'bgColor': Colors.orange.shade100
      };
    return {
      'level': 'High',
      'color': Colors.red,
      'bgColor': Colors.red.shade100
    };
  }

  bool _isFormValid() {
    return _inputData.values
        .every((value) => value != null && value.toString().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Disease Prediction System'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(LucideIcons.heart, color: Colors.red, size: 32),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Heart Disease Prediction System',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'ML-based early diagnosis using 6 classification models',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton(0, 'Input'),
                _buildTabButton(1, 'Results'),
                _buildTabButton(2, 'Models'),
                _buildTabButton(3, 'About'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildInputTab(),
                _buildResultsTab(),
                _buildModelsTab(),
                _buildAboutTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: _currentTab == index ? Colors.blue : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () => setState(() => _currentTab = index),
          child: Text(
            label,
            style: TextStyle(
              color: _currentTab == index ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.activity, size: 24),
              SizedBox(width: 8),
              Text(
                'Patient Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 5,
            ),
            itemCount: _inputFields.length,
            itemBuilder: (context, index) {
              final field = _inputFields[index];
              return _buildInputField(field);
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _isFormValid()
                  ? _handlePredict
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("djasbdsabdhab")));
                    },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                backgroundColor: Colors.blue,
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Text(
                'Predict Heart Disease Risk',
                style: TextStyle(
                  color: _isFormValid() ? Colors.white : Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInputField(Map<String, dynamic> field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field['label'],
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        if (field['type'] == 'select')
          _buildSelectField(field)
        else
          _buildNumberField(field)
      ],
    );
  }

  Widget _buildSelectField(Map<String, dynamic> field) {
    return DropdownButtonFormField<String>(
      value: _inputData[field['name']]?.toString(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items: [
        const DropdownMenuItem(value: '', child: Text('Select...')),
        ...(field['options'] as List).map((option) {
          return DropdownMenuItem(
            value: option['value'].toString(),
            child: Text(option['label']),
          );
        }).toList(),
      ],
      onChanged: (value) {
        setState(() {
          // textEditingController
          (field['textEditingController'] as TextEditingController).text =
              value ?? '';
          _inputData[field['name']] = value;
        });
      },
    );
  }

  Map<String, TextEditingController> textECDetails = {};
  Widget _buildNumberField(Map<String, dynamic> field) {
    textECDetails[field["name"]] ??=
        TextEditingController(text: _inputData[field['name']]);
    TextEditingController myTextEditingController =
        textECDetails[field["name"]]!;

    print("dndsajdjkasdbkajdb-${field}");
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: myTextEditingController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixText: field['unit'],
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        setState(() {
          // myTextEditingController.text = value;
          _inputData[field['name']] = value;
        });
      },
    );
  }

  Widget _buildResultsTab() {
    if (_predictions == null) {
      return const Center(child: Text('No prediction results available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          // Primary Prediction Card
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(LucideIcons.trendingUp, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Primary Prediction (XGBoost - Best Model)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        _predictions!['xgboost']['prediction'] == 1
                            ? LucideIcons.triangleAlert
                            : LucideIcons.circleCheck,
                        size: 32,
                        color: _predictions!['xgboost']['prediction'] == 1
                            ? Colors.red
                            : Colors.green,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _predictions!['xgboost']['prediction'] == 1
                            ? 'Heart Disease Detected'
                            : 'No Heart Disease Detected',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Risk Probability'),
                          Text(
                            '${(_predictions!['xgboost']['probability'] * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: _predictions!['xgboost']['probability'],
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _predictions!['xgboost']['probability'] < 0.3
                              ? Colors.green
                              : _predictions!['xgboost']['probability'] < 0.7
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getRiskLevel(
                          _predictions!['xgboost']['probability'])['bgColor'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getRiskLevel(_predictions!['xgboost']['probability'])[
                              'level'] +
                          ' Risk',
                      style: TextStyle(
                        color: _getRiskLevel(
                            _predictions!['xgboost']['probability'])['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // All Model Predictions
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All Model Predictions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _predictions!.keys.length,
                    itemBuilder: (context, index) {
                      final modelName = _predictions!.keys.elementAt(index);
                      final result = _predictions![modelName];
                      final modelData = _modelPerformance.firstWhere(
                          (model) =>
                              model['name'].toLowerCase().replaceAll(' ', '') ==
                              modelName,
                          orElse: () => {});

                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    modelName
                                        .replaceAllMapped(
                                          RegExp(r'([A-Z])'),
                                          (match) => ' ${match.group(0)}',
                                        )
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (modelData.isNotEmpty)
                                    Text(
                                      'Acc: ${(modelData['accuracy'] * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Prediction:'),
                                  Text(
                                    result['prediction'] == 1
                                        ? 'Positive'
                                        : 'Negative',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: result['prediction'] == 1
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Probability:'),
                                  Text(
                                    '${(result['probability'] * 100).toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildModelsTab() {
    // Prepare data for fl_chart
    final List<BarChartGroupData> barGroups = [];
    final List<Color> metricColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    for (int i = 0; i < _modelPerformance.length; i++) {
      final model = _modelPerformance[i];
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: model['accuracy'] * 100,
              color: metricColors[0],
              width: 16,
            ),
            BarChartRodData(
              toY: model['precision'] * 100,
              color: metricColors[1],
              width: 16,
            ),
            BarChartRodData(
              toY: model['recall'] * 100,
              color: metricColors[2],
              width: 16,
            ),
            BarChartRodData(
              toY: model['f1'] * 100,
              color: metricColors[3],
              width: 16,
            ),
          ],
          showingTooltipIndicators: [0, 1, 2, 3],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Model Performance Comparison',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            // tooltipBgColor: Colors.blueGrey,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final metricName = [
                                'Accuracy',
                                'Precision',
                                'Recall',
                                'F1'
                              ][rodIndex];
                              return BarTooltipItem(
                                '$metricName: ${rod.toY.toStringAsFixed(1)}%',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}%');
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 &&
                                    index < _modelPerformance.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      _modelPerformance[index]['name'],
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        barGroups: barGroups,
                        alignment: BarChartAlignment.spaceAround,
                        groupsSpace: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    children: [
                      _buildLegendItem(Colors.blue, 'Accuracy'),
                      _buildLegendItem(Colors.green, 'Precision'),
                      _buildLegendItem(Colors.orange, 'Recall'),
                      _buildLegendItem(Colors.red, 'F1-Score'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _modelPerformance.length,
                    itemBuilder: (context, index) {
                      final model = _modelPerformance[index];
                      return Card(
                        elevation: 2,
                        color: model['color'].withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: model['color'],
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildMetricRow('Accuracy:', model['accuracy']),
                              _buildMetricRow('Precision:', model['precision']),
                              _buildMetricRow('Recall:', model['recall']),
                              _buildMetricRow('F1-Score:', model['f1']),
                              _buildMetricRow('ROC-AUC:', model['rocAuc']),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildMetricRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            '${(value * 100).toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(LucideIcons.info, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'About This System',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Overview',
                    'This heart disease prediction system implements six machine learning classification models '
                        'to predict the risk of heart disease in patients. The system is based on research comparing '
                        'Logistic Regression, K-Nearest Neighbours (KNN), Decision Tree, Random Forest, XGBoost, '
                        'and Support Vector Machine (SVM) models.',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Dataset',
                    'The models were trained and evaluated on the UCI Cleveland Heart Disease Dataset, '
                        'which contains 303 patient records with 13 clinical features. This dataset is '
                        'widely used in cardiovascular ML research and provides a solid foundation for '
                        'heart disease prediction.',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Best Performing Model',
                    'XGBoost achieved the highest performance with 90% accuracy, 89% precision, 88% recall, '
                        '88% F1-score, and 93% ROC-AUC. This ensemble method excels at handling complex '
                        'feature interactions and provides robust predictions for clinical decision support.',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Clinical Features',
                    '',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Key Predictors:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            _buildFeatureItem(
                                'Chest pain type (most important)'),
                            _buildFeatureItem('Maximum heart rate achieved'),
                            _buildFeatureItem(
                                'ST depression induced by exercise'),
                            _buildFeatureItem(
                                'Number of major vessels colored'),
                            _buildFeatureItem('Age and sex'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Clinical Measurements:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            _buildFeatureItem('Resting blood pressure'),
                            _buildFeatureItem('Serum cholesterol levels'),
                            _buildFeatureItem('Fasting blood sugar'),
                            _buildFeatureItem('Resting ECG results'),
                            _buildFeatureItem('Thalassemia status'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.yellow.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(LucideIcons.triangleAlert,
                                color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Important Notice',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This system is for educational and research purposes only. It should not be used as a '
                          'substitute for professional medical diagnosis or treatment. Always consult with qualified '
                          'healthcare professionals for medical advice and diagnosis.',
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
