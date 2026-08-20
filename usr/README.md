# ASTRA - Asistente Personal de Inteligencia Artificial

ASTRA es una aplicación móvil diseñada como un asistente de inteligencia artificial personal con un enfoque visual futurista y moderno, inspirado en asistentes de ciencia ficción. ASTRA puede escuchar tus comandos de voz, procesar las preguntas simulando razonamiento de IA y responder de forma hablada con una interfaz inmersiva y de alto contraste (tonos oscuros, negros y azules brillantes).

## Características Principales

*   **Reconocimiento de Voz Integrado:** Un botón central de micrófono permite al usuario dictar comandos.
*   **Síntesis de Voz (TTS):** ASTRA lee sus respuestas en voz alta, ofreciendo una experiencia manos libres e interactiva.
*   **Animaciones Dinámicas:** Una interfaz viva que indica claramente si ASTRA está "ESCUCHANDO", "PROCESANDO" o "HABLANDO", con un orbe pulsante que reacciona a los estados.
*   **Diseño Futurista:** Interfaz de alto contraste en tonos azul y cian sobre fondos oscuros, tipografías monoespaciadas y elementos con estilo holográfico.
*   **Historial de Conversaciones:** Registro de todas las interacciones (preguntas del usuario y respuestas de ASTRA) visibles en la pantalla principal, diseñados como burbujas de chat de alta tecnología.
*   **Configuración y Preparación Futura:** Estructura lista para expandirse con comandos nativos del dispositivo (alarmas, aplicaciones, domótica).

## Flujos de Usuario

1.  **Inicio Rápido:** Al abrir la aplicación, ASTRA te saluda y está lista para escuchar.
2.  **Interacción de Voz:** 
    *   Mantén presionado el botón (o tócalo, según la configuración) para empezar a hablar.
    *   ASTRA transcribe tu voz a texto en tiempo real.
3.  **Procesamiento:** ASTRA evalúa tu comando y genera una respuesta (simulada por un motor lógico integrado).
4.  **Respuesta Auditiva y Visual:** La respuesta se muestra en el historial mientras el orbe central pulsa y ASTRA lee el texto en voz alta.

## Tecnologías Utilizadas

*   **Flutter:** Framework principal para la interfaz multiplataforma.
*   **Dart:** Lenguaje de programación.
*   **speech_to_text:** Dependencia para el reconocimiento de voz (STT).
*   **flutter_tts:** Dependencia para la síntesis de texto a voz (TTS).
*   **permission_handler:** Gestión de los permisos de grabación de audio en Android.
*   **provider:** Manejo del estado centralizado para la IA y la UI.

## Requisitos Previos

*   Flutter SDK (^3.7.2)
*   Dispositivo físico Android o emulador con micrófono configurado.
*   (Opcional) Conexión a internet si el motor de reconocimiento de voz del dispositivo lo requiere para ciertos idiomas.

## Ejecución de la Aplicación

1.  Clona este repositorio o descarga el código fuente.
2.  Abre una terminal en el directorio del proyecto y descarga las dependencias:
    ```bash
    flutter pub get
    ```
3.  Conecta tu dispositivo Android o inicia un emulador.
4.  Ejecuta la aplicación:
    ```bash
    flutter run
    ```
5.  La primera vez que uses el micrófono, la aplicación solicitará permisos de grabación de audio. Debes concederlos para que ASTRA pueda escucharte.

---

## Acerca de CouldAI

Esta aplicación fue generada y estructurada por **CouldAI**, un constructor de aplicaciones de inteligencia artificial diseñado para crear aplicaciones multiplataforma (iOS, Android, Web, Desktop) listas para producción. 

Con **CouldAI**, puedes convertir ideas escritas (prompts) en productos reales, impulsados por agentes autónomos de IA que arquitectan, construyen, prueban e iteran código nativo en Flutter.

Descubre más en [CouldAI](https://could.ai).