import SwiftUI
import Vision
import CoreML


struct Recognizer: View {
    var uiImage: UIImage

    // TODO: Agregar un objeto observador para manejar clasificación (modelo CoreML)
    @StateObject var imageClassifier = ImageClassifier()
    
    
    @State private var showRetryLink = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                // TODO: Mostrar imagen seleccionada
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(14)
                    .padding()

                // TODO: Mostrar texto de análisis o resultado según estado
                if imageClassifier.isAnalyzing {
                    Text("Analizando imagen...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // TODO: Mostrar resultado del modelo
                    Text("Resultado: \(imageClassifier.result)")
                        .font(.headline)
                        .padding()
                }

                // TODO: Botón para intentar otra imagen (aparece tras delay)
                if showRetryLink {
                    Button("Intentar otra foto") {
                        dismiss() // Regresar a la vista anterior
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Reconocimiento")
            .onAppear {
                analyzeImage() // TODO: Llamar análisis al cargar vista
            }
        }
    }

    // TODO: Función que lanza la clasificación y espera antes de mostrar botón
    private func analyzeImage() {
        imageClassifier.classify(image: uiImage)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showRetryLink = true
        }
    }
}

// TODO: Vista previa para desarrollo
#Preview {
    let sampleImage = UIImage(named: "photo") ?? UIImage()
    Recognizer(uiImage: sampleImage)
}
