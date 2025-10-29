import 'package:flutter/material.dart';
import 'package:fv2/views/pages/Disease/Solution.dart';

// Assume DiseaseModel, Symptom, Treatment, and TreatmentRecommendations classes are already defined

class DiseaseDetailPage extends StatelessWidget {
  final DiseaseModel disease;

  const DiseaseDetailPage({super.key, required this.disease});

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(disease.diseaseName),
        centerTitle: true,
         leading: BackButton(
          onPressed: (){
            if (context.mounted) {
  Navigator.pop(context);
}
          },
        ),
        
         actions: [TextButton(
          child: const Text('Done', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, "/widgettree", (route) => false);
            }
          },
        ),]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧩 Basic info
            Text(
              "Affected Crop: ${disease.affectedCrop}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Confidence: ${disease.diagnosisConfidence}"),
            const SizedBox(height: 16),

            // 🌿 Symptoms Section
            const Text(
              "Symptoms",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...disease.symptoms.map((symptom) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(symptom.symptomName),
                    subtitle: Text(symptom.explanation),
                  ),
                )),

            const SizedBox(height: 16),

            // 💊 Treatment Section
            const Text(
              "Treatment Recommendations",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // Organic / Biological
            _buildTreatmentCategory(
              "Organic / Biological",
              disease.treatmentRecommendations.organicBiological,
            ),

            // Chemical
            _buildTreatmentCategory(
              "Chemical",
              disease.treatmentRecommendations.chemical,
            ),

            // Cultural Control
            _buildTreatmentCategory(
              "Cultural Control",
              disease.treatmentRecommendations.culturalControl,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to display each treatment category
  Widget _buildTreatmentCategory(String title, List<Treatment> treatments) {
    if (treatments.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...treatments.map((t) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(t.treatmentName),
                subtitle: Text(t.explanation),
              ),
            )),
      ],
    );
  }
}
