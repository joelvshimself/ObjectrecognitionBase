import SwiftUI
import Vision
import CoreML

struct Recognizer: View {
    var uiImage: UIImage
    @StateObject var imageClassifier = ImageClassifier()
    @State private var showRetryLink = false // Controla la visibilidad del link "Probar otra foto"
    @Environment(\.dismiss) private var dismiss // Para volver atrás

    var body: some View {
        NavigationStack {
            VStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(14)
                    .padding()

                if imageClassifier.isAnalyzing {
                    Text("Analizando imagen...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    Text("Resultado: \(imageClassifier.result)")
                        .font(.headline)
                        .padding()
                }

                // Link para probar otra foto (aparece después de 3 segundos)
                if showRetryLink {
                    Button("Intentar otra foto") {
                        dismiss() // Regresa a `ContentView`
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
                analyzeImage() // Lanza el análisis automáticamente
            }
        }
    }

    private func analyzeImage() {
        imageClassifier.classify(image: uiImage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showRetryLink = true
        }
    }
}

#Preview {
    // Crear una imagen de ejemplo para el preview
    let sampleImage = UIImage(systemName: "photo") ?? UIImage()
    Recognizer(uiImage: sampleImage)
}
