import SwiftUI
import Vision
import CoreML


struct Recognizer: View {
    var uiImage: UIImage

    
    @StateObject var imageClassifier = ImageClassifier()
    
    
    @State private var showRetryLink = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                // TODO: Mostrar imagen seleccionada
                
                
                // TODO: Mostrar texto de análisis o resultado según estado
              
                
                // TODO: Mostrar resultado del modelo
                    
                
                // TODO: Botón para intentar otra imagen (aparece tras delay)
                
                
            }
            .padding()
            .navigationTitle("Reconocimiento")
            .onAppear {
                // TODO: Llamar análisis al cargar vista
            }
        }
    }

    // TODO: Función que lanza la clasificación y espera antes de mostrar botón
    
}


#Preview {
    let sampleImage = UIImage(named: "photo") ?? UIImage()
    Recognizer(uiImage: sampleImage)
}
