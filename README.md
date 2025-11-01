# 🧹 Domy
**Domy** es una aplicación móvil desarrollada con **Flutter** que busca formalizar y modernizar la contratación de servicios de aseo doméstico, reemplazando el modelo tradicional de recomendación “boca a boca” por una plataforma confiable, accesible y fácil de usar.

## 🧭 Propósito
El propósito principal de **Domy** es dignificar y profesionalizar el trabajo doméstico mediante una plataforma digital que conecte a **clientes** y **operarias** de forma directa, segura y eficiente.

## 🎯 Objetivo del proyecto
Desarrollar una aplicación móvil que facilite la **contratación, gestión y seguimiento de servicios de aseo doméstico**, contribuyendo a la **formalización del sector** y ofreciendo una experiencia digital completa tanto para el cliente como para la operaria.  
🏫 Proyecto académico desarrollado como parte del proceso de aprendizaje en tecnologías móviles y arquitectura de software.

## 💡 Motivación
La creación de **Domy** surge con el objetivo de **aprender e implementar tecnologías modernas** en el desarrollo de aplicaciones móviles, mientras se aborda un **problema real**: la falta de plataformas que conecten formalmente la oferta y demanda de servicios domésticos.

## 👥 Roles y funcionalidades principales
### 👤 Rol: Cliente
- Registro e inicio de sesión.  
- Edición de su perfil y datos personales.  
- Visualización del listado de operarias disponibles.  
- Solicitud y reserva de servicios de aseo.  

### 🧽 Rol: Operaria
- Registro e inicio de sesión.  
- Edición de información personal y disponibilidad.  
- Visualización de solicitudes de servicios.  
- Aceptar o rechazar solicitudes según disponibilidad.  

## 🧱 Arquitectura y tecnología
| Componente | Descripción |
|-------------|-------------|
| **Lenguaje principal** | Dart |
| **Framework** | Flutter |
| **Arquitectura** | Estructura modular basada en separación por pantallas (UI), lógica y modelos de datos. |
| **Base de datos** | En desarrollo (actualmente los datos se almacenan en memoria local del dispositivo). |
| **Estado actual** | 🚧 Desarrollo del MVP (Mínimo Producto Viable). |

En futuras iteraciones se planea la integración con **Firebase** o una base de datos remota, así como la adopción de una arquitectura **Clean Architecture** o **MVVM** para escalar el proyecto de manera sostenible.

## ⚙️ Instalación y ejecución
1. Clonar el repositorio: `git clone https://github.com/usuario/domy.git`  
2. Entrar al directorio del proyecto: `cd domy`  
3. Instalar las dependencias: `flutter pub get`  
4. Ejecutar la aplicación: `flutter run`  
Requisitos: Tener instalado Flutter SDK y un emulador o dispositivo físico configurado.

## 🧩 Estructura del proyecto (resumen)
```
lib/
├── main.dart
├── pages/
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── home_page.dart
│   ├── profile_page.dart
│   ├── client/
│   └── operaria/
├── models/
│   ├── user_model.dart
│   ├── service_model.dart
├── widgets/
│   └── custom_widgets.dart
└── utils/
    └── constants.dart
```

## 🖼️ Capturas de pantalla (placeholders)
| Pantalla | Descripción |
|-----------|--------------|
| ![login_placeholder](assets/screenshots/login_placeholder.png) | Pantalla de inicio de sesión |
| ![home_placeholder](assets/screenshots/home_placeholder.png) | Pantalla principal (Home) |
| ![profile_placeholder](assets/screenshots/profile_placeholder.png) | Pantalla de perfil del usuario |

## 🚀 Próximas versiones
- [ ] Integración con **Firebase** para autenticación y base de datos.  
- [ ] Sistema de **calificación y reseñas**.  
- [ ] **Chat en tiempo real** entre cliente y operaria.  
- [ ] Integración con **Google Maps** para geolocalización.  
- [ ] Implementación de **notificaciones push**.  

## 👨‍💻 Autores
| Nombre | Rol |
|---------|-----|
| **Santiago Pérez Sarabia** | Desarrollador principal |
| **Jorge Andrés Grisales** | Colaborador |

## 🪪 Licencia
Este proyecto se distribuye bajo la licencia **MIT**.  
Consulta el archivo [LICENSE](LICENSE) para más información.

## 📚 Agradecimientos
A los docentes y mentores que guiaron el desarrollo de este proyecto, y a la comunidad de desarrolladores Flutter por su documentación y recursos abiertos.
