# Proyecto de Inteligencia Artificial para Backend y Aplicación Móvil: Calories

## Objetivo

El objetivo de la aplicación es ayudar a los usuarios a predecir la cantidad de calorías quemadas durante una actividad física específica. Utiliza un modelo de aprendizaje automático alojado en un servidor backend para procesar datos como la edad, el peso, la duración del ejercicio, la frecuencia cardíaca y el género del usuario, y luego genera una predicción personalizada de las calorías quemadas.

## Creación del Modelo

En el siguiente codelab, se explicará detalladamente el proceso de creación de un modelo de Machine Learning utilizando RandomForestRegressor. Se cubrirán todos los pasos, desde la limpieza de datos y el preprocesamiento, hasta el entrenamiento y la evaluación del modelo.

- [Lab: Proyecto Final IA - Calories](https://colab.research.google.com/drive/1jqYPSJfveHjkQGqagvEw0GMUDjXBUxRO?usp=sharing)


## Pasos a seguir

### Configuración del Servidor (AWS EC2)
1. Configurar una instancia de AWS EC2 con los permisos adecuados.
2. Instalar las dependencias necesarias para el servidor Backend.
3. Implementar la API REST para recibir los datos del formulario.
4. Integrar el modelo de Machine Learning para la predicción de precios.
5. Probar la API con herramientas como Postman o Curl.

### Configuración del Frontend (Flutter)
1. Configurar un proyecto Flutter para Android.
2. Diseñar el formulario de entrada de datos.
3. Implementar la comunicación con la API Backend.
4. Manejar los estados con Riverpod.
5. Mostrar los resultados de la predicción en la UI.

---

# Configuración del Backend en AWS EC2

## Introducción

Dado que el precio de un avión depende de múltiples factores con posibles interacciones y relaciones no lineales (por ejemplo, el impacto de la edad, el tipo de motor y el mantenimiento en el precio puede no ser lineal), Random Forest es una excelente opción para la predicción de precios.

Este documento proporciona una guía paso a paso para configurar un servidor en AWS EC2 para alojar un modelo de Machine Learning utilizando Flask.

---

## Requisitos previos

Antes de comenzar, asegúrate de tener lo siguiente:
- Una cuenta de AWS activa.
- Un par de claves SSH para conectarte a la instancia EC2.
- Python 3 instalado en la instancia.
- Un modelo previamente entrenado en formato `.bin`.

---

## Instalación de bibliotecas necesarias

Para que el servidor funcione correctamente, necesitas instalar las siguientes bibliotecas:

```sh
pip install flask joblib numpy scikit-learn
```

### Explicación de las bibliotecas

- `Flask`: Microframework para Python que permite crear aplicaciones web de manera sencilla.
- `joblib`: Se utiliza para cargar modelos de Machine Learning previamente entrenados.
- `numpy`: Biblioteca para trabajar con arreglos y matrices de datos.
- `scikit-learn`: Necesario para StandardScaler, que fue usado para escalar los datos.

---

## Configuración de la instancia EC2 en AWS

1. **Lanzar una instancia EC2:**
    - Inicia sesión en la consola de AWS.
    - Ve a "EC2" y selecciona "Launch Instance".
    - Elige "Ubuntu" como sistema operativo.
    - Configura el tamaño de la instancia (recomendada: t2.medium o superior si el modelo es pesado).

![Select Ubuntu](assets/readme/ubuntu.png)

2. **Configurar reglas de seguridad:**
    - Abre el puerto 8090 (o el que usará tu API) en el grupo de seguridad.
    - Habilita SSH (puerto 22) para acceder a la instancia.

![Reglas](assets/readme/rules.png)

3. **Conectarse a la instancia EC2:**
    - Usa SSH para conectarte a la instancia:

   ```sh
   ssh -i "tu_clave.pem" ubuntu@<tu_ip_ec2>
   ```

4. **Instalar Python y virtualenv:**

   ```sh
   sudo apt update && sudo apt install -y python3-pip python3-venv
   ```

5. **Crear y activar un entorno virtual:**

   ```sh
   python3 -m venv venv
   source venv/bin/activate
   ```

---

## Carga del modelo en la instancia

Para cargar el modelo entrenado y su scaler, utiliza SCP para transferirlos a la instancia EC2:

```sh
scp -i tu_clave.pem scalercolories.bin modelo_calories.bin ubuntu@<tu_ip_ec2>:~/
```

---

## Código del servidor

Guarda el siguiente código como `app.py` en tu instancia:

```python
from flask import Flask, request, jsonify
import joblib
import numpy as np

# Cargar el modelo y el scaler
model = joblib.load('modelo_calories.bin')
scaler = joblib.load('scalercolories.bin')

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Obtener datos de la solicitud
        data = request.json
        
        # Validar datos de entrada
        required_fields = ['Gender', 'Age', 'Weight', 'Duration', 'Heart_Rate']
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'Campo requerido {field} no encontrado'}), 400
        
        # Convertir datos a numpy array
        features = np.array([data['Gender'], data['Age'], data['Weight'], data['Duration'], data['Heart_Rate']])
        
        # Escalar características
        features_scaled = scaler.transform([features])
        
        # Realizar predicción
        prediction = model.predict(features_scaled)
        
        return jsonify({'predicted_calories': prediction[0]})
    
    except ValueError as ve:
        return jsonify({'error': f'Error de valor: {str(ve)}'}), 400
    except KeyError as ke:
        return jsonify({'error': f'Error de clave: {str(ke)}'}), 400
    except Exception as e:
        return jsonify({'error': f'Error inesperado: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8090)
```

---

## Ejecutar el servidor

Para iniciar el servidor Flask, ejecuta:

```sh
python app.py
```

---

## Solución de errores

### Error de memoria insuficiente

Si al ejecutar el servidor recibes un error de memoria, intenta liberar cachés con:

```sh
sudo sync; sudo sysctl -w vm.drop_caches=3
```

---

## Prueba del API con Postman

Para probar el endpoint de predicción:

1. Abre Postman y crea una nueva solicitud `POST`.
2. Usa la siguiente URL:

   ```
   http://<tu_ip_publica>:8080/predict/
   ```

3. En la pestaña "Body", selecciona `raw` y usa el siguiente JSON:

   ```json
   {
     "Gender": 1,
     "Age": 68,
     "Weight": 94,
     "Duration": 29,
     "Heart_Rate": 105
   }
   ```

4. Envía la solicitud y verifica la respuesta JSON con la predicción del precio.

---
# Configuración del Proyecto Android

Este proyecto es un punto de partida para una aplicación Flutter.

Algunas referencias útiles para comenzar con Flutter:

- [Lab: Escribe tu primera aplicación en Flutter](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Ejemplos útiles en Flutter](https://docs.flutter.dev/cookbook)

Para obtener ayuda con el desarrollo en Flutter, visita la
[documentación en línea](https://docs.flutter.dev/), donde encontrarás tutoriales, ejemplos, guías sobre desarrollo móvil y una referencia completa de la API.

## Instalación

Para la instalación de Flutter, puedes consultar la documentación oficial:
- [Cómo instalar Flutter](https://docs.flutter.dev/get-started/install)

Para este proyecto se usaron las siguientes versiones:

- `DevTools 2.28.5`
- `Flutter 3.16.9`
- `Dart 3.2.6`

Asegúrate de tener Flutter instalado en tu sistema. Puedes verificarlo con el siguiente comando:

```sh
flutter --version
```

Para instalar las dependencias, ejecuta:

```sh
flutter pub get
```

## Versión de Java

La versión de Java utilizada en este proyecto es la **1.8.0_281**.

Para verificar la versión de Java utilizada en el proyecto, puedes revisar el archivo `build.gradle` en la sección `compileOptions`:

```groovy
android {
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

También puedes verificar la versión de Java instalada en tu sistema ejecutando el siguiente comando en la terminal:

```sh
java -version
```

## Dependencias adicionales

Este proyecto incluye las siguientes dependencias adicionales que no vienen por defecto en un nuevo proyecto de Flutter:

| Paquete         | Versión | Descripción                                   | Instalación                       |
|-----------------|---------|-----------------------------------------------|-----------------------------------|
| fluttertoast    | ^8.4.7  | Muestra notificaciones tipo toast en Flutter. | `flutter pub add fluttertoast`    |
| dio             | ^5.4.0  | Cliente HTTP avanzado para Dart.              | `flutter pub add dio`             |
| dartz           | ^0.10.1 | Programación funcional en Dart.               | `flutter pub add dartz`           |
| lottie          | ^3.1.3  | Soporte para animaciones Lottie en Flutter.   | `flutter pub add lottie`          |
| cupertino_icons | ^0.13.1 | Iconos estilo iOS.                            | `flutter pub add cupertino_icons` |

## Funcionamiento de la Aplicación

### **Pantalla de Configuración del Servidor**

En la primera pantalla, el usuario debe ingresar la IP y el puerto del servidor backend. La pantalla incluye:

- **Dos campos de entrada de texto (TextField)** para la IP y el puerto del servidor..
- **Un botón de navegación**, que se habilitará cuando ambos campos estén correctamente llenos.

📷 _Ejemplo visual:_

![InputScreen](assets/readme/configuration_server.jpg)

### **Pantalla de Predicción**

Una vez configurado el servidor, la aplicación navega a la pantalla de predicción, donde el usuario ingresa datos para hacer una predicción. La pantalla incluye:

- **Varios sliders para ingresar los datos:**
    - Edad.
    - Peso.
    - Duración del ejercicio.
    - Frecuencia cardíaca.
- **Botones de radio para seleccionar el género**
- **Un botón para enviar los datos**, que permanecerá deshabilitado hasta que todos los campos sean llenados correctamente..
- **El resultado de la predicción**, que aparecerá en un diálogo una vez que se reciba la respuesta del servidor.

📷 _Ejemplo visual:_

![PredictionScreen](assets/readme/prediction.jpg)
![PredictionScreenToastError](assets/readme/error_prediction.jpg)
![PredictionScreenFlowOk](assets/readme/good_prediction.jpg)



