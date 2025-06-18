//
//  ImageClassifierTests.swift
//  ObjectrecognitionBase
//
//  Created by Joel Vargas on 24/02/25.
//

import Foundation
import UIKit
import Vision
import CoreML

// Clase de pruebas para verificar el funcionamiento del ImageClassifier
class ImageClassifierTests {
    
    static func runTests() {
        print("🧪 Iniciando pruebas del ImageClassifier...")
        
        // Test 1: Verificar que el modelo se carga correctamente
        testModelLoading()
        
        // Test 2: Verificar que el clasificador se inicializa correctamente
        testClassifierInitialization()
        
        // Test 3: Verificar manejo de imágenes vacías
        testEmptyImageHandling()
        
        print("✅ Pruebas completadas")
    }
    
    private static func testModelLoading() {
        print("📦 Probando carga del modelo...")
        
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .all
            
            // Verificar que el modelo existe en el bundle
            guard let modelURL = Bundle.main.url(forResource: "MobileNetV2", withExtension: "mlmodel") else {
                print("❌ Test falló: No se encontró MobileNetV2.mlmodel en el bundle")
                return
            }
            
            print("✅ Test pasado: Modelo encontrado en \(modelURL)")
            
            // Intentar cargar el modelo
            let coreMLModel = try MobileNetV2(configuration: config).model
            let visionModel = try VNCoreMLModel(for: coreMLModel)
            
            print("✅ Test pasado: Modelo cargado exitosamente")
            
        } catch {
            print("❌ Test falló: Error cargando modelo - \(error)")
        }
    }
    
    private static func testClassifierInitialization() {
        print("🔧 Probando inicialización del clasificador...")
        
        let classifier = ImageClassifier()
        
        // Verificar que las propiedades iniciales son correctas
        if classifier.result == "Esperando imagen..." {
            print("✅ Test pasado: Estado inicial correcto")
        } else {
            print("❌ Test falló: Estado inicial incorrecto")
        }
        
        if classifier.predictions.isEmpty {
            print("✅ Test pasado: Lista de predicciones vacía inicialmente")
        } else {
            print("❌ Test falló: Lista de predicciones no está vacía inicialmente")
        }
    }
    
    private static func testEmptyImageHandling() {
        print("🖼️ Probando manejo de imagen vacía...")
        
        let classifier = ImageClassifier()
        
        // Crear una imagen vacía
        let emptyImage = UIImage()
        
        // Llamar al método de clasificación
        classifier.classify(image: emptyImage)
        
        // Verificar que se maneja correctamente el error
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if classifier.errorMessage != nil {
                print("✅ Test pasado: Error manejado correctamente para imagen vacía")
            } else {
                print("❌ Test falló: No se manejó el error de imagen vacía")
            }
        }
    }
}

// Extensión para facilitar las pruebas
extension ImageClassifier {
    func testWithSampleImage() {
        print("🧪 Probando con imagen de muestra...")
        
        // Crear una imagen de prueba simple
        let size = CGSize(width: 224, height: 224)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // Dibujar un rectángulo azul simple
        UIColor.blue.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        let testImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = testImage {
            print("✅ Imagen de prueba creada: \(image.size)")
            classify(image: image)
        } else {
            print("❌ No se pudo crear imagen de prueba")
        }
    }
} 