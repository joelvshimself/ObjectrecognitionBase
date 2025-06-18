//
//  ObjectrecognitionBaseApp.swift
//  ObjectrecognitionBase
//
//  Created by Joel Vargas on 17/06/25.
//

import SwiftUI

@main
struct ObjectrecognitionBaseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    #if DEBUG
                    // Ejecutar pruebas solo en modo debug
                    print("🚀 Aplicación iniciada en modo DEBUG")
                    ImageClassifierTests.runTests()
                    #endif
                }
        }
    }
}
