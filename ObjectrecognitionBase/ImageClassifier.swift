//
//  ImageClassifier.swift
//  objectrecognition
//
//  Created by Joel Vargas on 24/02/25.
//

import Foundation
import Vision
import CoreML
import UIKit

// Clase para manejar la clasificación de imágenes con Core ML
class ImageClassifier: ObservableObject {
    @Published var result: String = "Esperando imagen..."
    @Published var predictions: [String] = []
    @Published var isAnalyzing: Bool = false
    @Published var errorMessage: String?
    
    private var model: VNCoreMLModel?
    private var isModelLoaded: Bool = false

    init() {
        print("🔄 Inicializando ImageClassifier...")
        
        #if DEBUG
        // En modo debug/preview, usar un resultado simulado
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            self.result = "Modo Preview - Imagen de ejemplo"
            self.predictions = ["Preview: Objeto 1 (95%)", "Preview: Objeto 2 (85%)", "Preview: Objeto 3 (75%)"]
            return
        }
        #endif
        
        loadModel()
    }
    
    private func loadModel() {
        print("📦 Cargando modelo MobileNetV2...")
        
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .all // Usar CPU, GPU y Neural Engine si está disponible
            
            let coreMLModel = try MobileNetV2(configuration: config).model
            model = try VNCoreMLModel(for: coreMLModel)
            isModelLoaded = true
            
            print("✅ Modelo MobileNetV2 cargado exitosamente")
            
        } catch {
            print("❌ Error cargando modelo CoreML: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Error al cargar el modelo: \(error.localizedDescription)"
                self.result = "Error: Modelo no disponible"
            }
        }
    }

    func classify(image: UIImage) {
        print("🔍 Iniciando clasificación de imagen...")
        
        // Verificar que el modelo esté cargado
        guard isModelLoaded, let model = model else {
            print("❌ Modelo no está cargado")
            DispatchQueue.main.async {
                self.errorMessage = "Modelo no está disponible"
                self.result = "Error: Modelo no disponible"
                self.isAnalyzing = false
            }
            return
        }
        
        // Verificar que la imagen no esté vacía
        guard !image.size.equalTo(.zero) else {
            print("❌ Imagen está vacía o tiene tamaño cero")
            DispatchQueue.main.async {
                self.errorMessage = "La imagen seleccionada está vacía"
                self.result = "Error: Imagen inválida"
                self.isAnalyzing = false
            }
            return
        }
        
        print("📏 Tamaño de imagen: \(image.size)")
        
        // Actualizar estado de análisis
        DispatchQueue.main.async {
            self.isAnalyzing = true
            self.errorMessage = nil
            self.result = "Analizando imagen..."
            self.predictions = []
        }
        
        #if DEBUG
        // En modo debug/preview, simular el resultado
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.result = "Preview: Imagen reconocida (95%)"
                self.predictions = ["Preview: Objeto 1 (95%)", "Preview: Objeto 2 (85%)", "Preview: Objeto 3 (75%)"]
                self.isAnalyzing = false
            }
            return
        }
        #endif
        
        // Convertir UIImage a CIImage
        guard let ciImage = CIImage(image: image) else {
            print("❌ Error al convertir UIImage a CIImage")
            DispatchQueue.main.async {
                self.errorMessage = "Error al procesar la imagen"
                self.result = "Error: No se pudo procesar la imagen"
                self.isAnalyzing = false
            }
            return
        }
        
        print("✅ Imagen convertida a CIImage exitosamente")
        
        // Configurar la request de clasificación
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isAnalyzing = false
                
                if let error = error {
                    print("❌ Error en la clasificación: \(error)")
                    self.errorMessage = "Error en la clasificación: \(error.localizedDescription)"
                    self.result = "Error: Clasificación falló"
                    return
                }
                
                // Procesar resultados
                guard let results = request.results as? [VNClassificationObservation] else {
                    print("❌ No se obtuvieron resultados de clasificación")
                    self.errorMessage = "No se obtuvieron resultados"
                    self.result = "Error: Sin resultados"
                    return
                }
                
                print("📊 Resultados obtenidos: \(results.count) predicciones")
                
                // Mostrar las 3 predicciones principales
                let topResults = Array(results.prefix(3))
                var predictionsList: [String] = []
                
                for (index, observation) in topResults.enumerated() {
                    let confidence = Int(observation.confidence * 100)
                    let prediction = "\(index + 1). \(observation.identifier) (\(confidence)%)"
                    predictionsList.append(prediction)
                    print("🎯 Predicción \(index + 1): \(observation.identifier) - \(confidence)%")
                }
                
                // Actualizar UI
                self.predictions = predictionsList
                
                if let firstResult = topResults.first {
                    let confidence = Int(firstResult.confidence * 100)
                    self.result = "\(firstResult.identifier) (\(confidence)%)"
                    print("🏆 Mejor predicción: \(firstResult.identifier) con \(confidence)% de confianza")
                } else {
                    self.result = "No se pudo reconocer la imagen"
                    print("⚠️ No se encontraron predicciones válidas")
                }
            }
        }
        
        // Configurar opciones de la request
        request.imageCropAndScaleOption = .centerCrop // Centrar y recortar la imagen
        
        // Procesar la imagen en una cola de alta prioridad
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                print("🚀 Ejecutando clasificación...")
                try handler.perform([request])
                print("✅ Clasificación completada")
            } catch {
                print("❌ Error ejecutando handler: \(error)")
                DispatchQueue.main.async {
                    self.isAnalyzing = false
                    self.errorMessage = "Error en la ejecución: \(error.localizedDescription)"
                    self.result = "Error: Ejecución falló"
                }
            }
        }
    }
}

