# ObjectrecognitionBase

Una aplicación iOS de reconocimiento de objetos usando Core ML y MobileNetV2.

## 🚀 Características

- **Reconocimiento de objetos en tiempo real** usando MobileNetV2
- **Interfaz moderna** con SwiftUI
- **Top 3 predicciones** con porcentajes de confianza
- **Manejo robusto de errores** y logs de depuración
- **Soporte para imágenes de la galería** usando PhotosPicker

## 📱 Requisitos

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## 🛠️ Instalación

1. Clona el repositorio
2. Abre `ObjectrecognitionBase.xcodeproj` en Xcode
3. Asegúrate de que `MobileNetV2.mlmodel` esté incluido en el proyecto
4. Compila y ejecuta en un dispositivo iOS o simulador

## 🔧 Configuración del Modelo

El proyecto incluye el modelo `MobileNetV2.mlmodel` que debe estar en la raíz del proyecto. Si no está presente:

1. Descarga MobileNetV2 desde [Apple Developer](https://developer.apple.com/machine-learning/models/)
2. Arrastra el archivo `.mlmodel` al proyecto en Xcode
3. Asegúrate de que esté marcado para incluir en el target de la aplicación

## 🎯 Uso

1. **Seleccionar imagen**: Toca el botón "Importar" para seleccionar una imagen de la galería
2. **Análisis automático**: La aplicación analizará automáticamente la imagen
3. **Ver resultados**: Se mostrarán las 3 predicciones principales con porcentajes
4. **Intentar otra**: Usa "Intentar otra foto" para probar con una imagen diferente

## 🔍 Solución de Problemas

### Problema: "Modelo no disponible"
- **Causa**: El archivo `MobileNetV2.mlmodel` no está incluido en el proyecto
- **Solución**: Verifica que el modelo esté en el proyecto y marcado para incluir en el target

### Problema: "Error al procesar la imagen"
- **Causa**: La imagen seleccionada está corrupta o en formato no soportado
- **Solución**: Intenta con otra imagen en formato JPEG o PNG

### Problema: Predicciones siempre iguales
- **Causa**: Problema en el procesamiento de la imagen o configuración del modelo
- **Solución**: 
  1. Verifica los logs en la consola de Xcode
  2. Asegúrate de que la imagen tenga contenido visible
  3. Reinicia la aplicación

### Problema: Aplicación se cuelga
- **Causa**: Memoria insuficiente o modelo no cargado correctamente
- **Solución**:
  1. Cierra la aplicación completamente
  2. Reinicia el dispositivo
  3. Verifica que hay suficiente espacio libre

## 📊 Logs de Depuración

La aplicación incluye logs detallados para depuración. En Xcode, busca estos emojis en la consola:

- 🔄 Inicialización
- 📦 Carga del modelo
- 🔍 Inicio de clasificación
- 📏 Información de imagen
- 🚀 Ejecución de clasificación
- 🎯 Predicciones individuales
- 🏆 Mejor predicción
- ❌ Errores
- ✅ Éxitos

## 🧪 Pruebas

El proyecto incluye pruebas automáticas que se ejecutan en modo DEBUG:

- Verificación de carga del modelo
- Pruebas de inicialización
- Manejo de imágenes vacías
- Pruebas con imágenes de muestra

## 📁 Estructura del Proyecto

```
ObjectrecognitionBase/
├── ObjectrecognitionBase/
│   ├── ObjectrecognitionBaseApp.swift    # Punto de entrada
│   ├── ContentView.swift                 # Vista principal
│   ├── RecognizerView.swift              # Vista de reconocimiento
│   ├── ImagePicker.swift                 # Selector de imágenes
│   ├── ImageClassifier.swift             # Clasificador Core ML
│   └── ImageClassifierTests.swift        # Pruebas
├── MobileNetV2.mlmodel                   # Modelo de ML
└── README.md                             # Este archivo
```

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🙏 Agradecimientos

- [Apple Core ML](https://developer.apple.com/machine-learning/) por el framework de ML
- [MobileNetV2](https://arxiv.org/abs/1801.04381) por el modelo de reconocimiento
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) por el framework de UI 