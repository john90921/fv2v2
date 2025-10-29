class DiseaseModel {
  final String diseaseName;
  final String affectedCrop;
  final String diagnosisConfidence;
  final List<Symptom> symptoms;
  final TreatmentRecommendations treatmentRecommendations;

  DiseaseModel({
    required this.diseaseName,
    required this.affectedCrop,
    required this.diagnosisConfidence,
    required this.symptoms,
    required this.treatmentRecommendations,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      diseaseName: json['disease_name'],
      affectedCrop: json['affected_crop'],
      diagnosisConfidence: json['diagnosis_confidence'],
      symptoms: (json['symptoms'] as List)
          .map((item) => Symptom.fromJson(item))
          .toList(),
      treatmentRecommendations:
          TreatmentRecommendations.fromJson(json['treatment_recommendations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease_name': diseaseName,
      'affected_crop': affectedCrop,
      'diagnosis_confidence': diagnosisConfidence,
      'symptoms': symptoms.map((e) => e.toJson()).toList(),
      'treatment_recommendations': treatmentRecommendations.toJson(),
    };
  }
}

class Symptom {
  final String symptomName;
  final String explanation;

  Symptom({
    required this.symptomName,
    required this.explanation,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      symptomName: json['symptom_name'],
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symptom_name': symptomName,
      'explanation': explanation,
    };
  }
}

class TreatmentRecommendations {
  final List<Treatment> organicBiological;
  final List<Treatment> chemical;
  final List<Treatment> culturalControl;

  TreatmentRecommendations({
    required this.organicBiological,
    required this.chemical,
    required this.culturalControl,
  });

  factory TreatmentRecommendations.fromJson(Map<String, dynamic> json) {
    return TreatmentRecommendations(
      organicBiological: (json['organic_biological'] as List)
          .map((item) => Treatment.fromJson(item))
          .toList(),
      chemical: (json['chemical'] as List)
          .map((item) => Treatment.fromJson(item))
          .toList(),
      culturalControl: (json['cultural_control'] as List)
          .map((item) => Treatment.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organic_biological': organicBiological.map((e) => e.toJson()).toList(),
      'chemical': chemical.map((e) => e.toJson()).toList(),
      'cultural_control': culturalControl.map((e) => e.toJson()).toList(),
    };
  }
}

class Treatment {
  final String treatmentName;
  final String explanation;

  Treatment({
    required this.treatmentName,
    required this.explanation,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      treatmentName: json['treatment_name'],
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatment_name': treatmentName,
      'explanation': explanation,
    };
  }
}
