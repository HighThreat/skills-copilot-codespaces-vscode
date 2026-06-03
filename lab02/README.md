# Laboratorio 2 — Variables, outputs y parametrización

Guía práctica para transformar código rígido de Terraform en una configuración dinámica, reutilizable y parametrizada, desplegando infraestructura en la región **France Central**.

---

## Quick Start

Sigue estos comandos mínimos en tu terminal para ejecutar el despliegue del laboratorio en sus diferentes escenarios:

```bash
# 1. Inicializar Terraform en la carpeta lab02
cd lab02
terraform init

# --- Escenario A: Despliegue en Desarrollo (Dev) ---
# Se utiliza el archivo predeterminado terraform.tfvars
terraform plan
terraform apply

# --- Escenario B: Despliegue en Preproducción (Pre) ---
# Puedes pasar un archivo de variables personalizado (ej. pre.tfvars)
terraform plan -var-file="pre.tfvars"
terraform apply -var-file="pre.tfvars"

# 2. Eliminar los recursos creados al finalizar
terraform destroy
# (O con el archivo de variables correspondiente)
terraform destroy -var-file="pre.tfvars"
```

---

## Features

* **Refactorización Profesional:** Separación estricta de responsabilidades en archivos `provider.tf`, `main.tf`, `variables.tf`, `outputs.tf` y `terraform.tfvars`.
* **Funciones Nativas de Terraform:** Uso integrado de funciones de manipulación de cadenas (`lower()`, `join()`) y colecciones (`length()`) para dinamismo.
* **Despliegue Multi-Entorno:** Capacidad de desplegar ambientes diferentes (Desarrollo y Preproducción) alterando únicamente los valores de entrada.
* **Subredes Dinámicas:** Generación automática de direccionamiento CIDR mediante la función `cidrsubnet()` en base al número de elementos de una lista.

---

## Configuration

El proyecto se puede parametrizar completamente usando las siguientes variables declaradas en `variables.tf`:

| Variable | Descripción | Tipo | Por defecto |
|----------|-------------|------|-------------|
| `region` | Región geográfica de Azure para el despliegue. | `string` | `"francecentral"` |
| `resource_group_name` | Nombre base del Resource Group. | `string` | *Obligatorio* |
| `env_prefix` | Prefijo de entorno (ej. `dev` o `pre`). | `string` | *Obligatorio* |
| `vnet_address_space` | Espacio de direcciones CIDR para la VNET. | `list(string)` | *Obligatorio* |
| `subnet_names` | Lista con los nombres de las subredes a crear. | `list(string)` | *Obligatorio* |

---

## Documentation

### 📚 Relación con la Teoría

Este laboratorio práctico refuerza directamente los siguientes conceptos avanzados:
* **Variables:** Declaraciones de parámetros de entrada con tipos de datos estrictos (incluyendo tipos complejos como `list(string)`).
* **Archivos `.tfvars`:** Ficheros de asignación de valores para desacoplar el código de Terraform de las configuraciones específicas del entorno.
* **Outputs:** Definiciones que exponen información de los recursos creados al exterior, facilitando la integración con otras herramientas.
* **Referencias:** Relaciones lógicas entre recursos (ej. vincular subnets a la VNET y Resource Group mediante sus propiedades expuestas en lugar de cadenas fijas).
* **Estructura Profesional:** Modularización del código para cumplir con el principio DRY (*Don't Repeat Yourself*).

---

### 🎯 Objetivo del Laboratorio

El estudiante debe **refactorizar un código con valores quemados (hardcoded) en una estructura limpia y reutilizable**. El objetivo final es poder cambiar la cantidad de subredes, sus nombres, el direccionamiento de la red y el tipo de entorno modificando exclusivamente los valores del archivo `.tfvars`, sin realizar ningún cambio en los archivos `.tf` de infraestructura.

---

### 🏗️ Infraestructura a Desplegar

El laboratorio aprovisiona los siguientes componentes lógicos en **France Central** (`francecentral`):
* **Resource Group**
* **Virtual Network (VNET)**
* **Subnets:** Generadas dinámicamente según la cantidad especificada en `subnet_names`.
* **Network Security Group (NSG):** Asociado a etiquetas dinámicas.

---

### 🚀 Guía Paso a Paso Detallada

#### Parte 1 — Refactorizar el Proyecto
El alumno debe verificar que el código está correctamente estructurado en archivos separados:
* `provider.tf`: Define la conexión al backend/Azure.
* `variables.tf`: Define los contratos (entradas).
* `outputs.tf`: Declara la información útil saliente.
* `main.tf`: Declara los recursos usando funciones y variables.
* `terraform.tfvars`: Contiene los valores de variables para el entorno.

#### Parte 2 y 3 — Parametrización y Variables Complejas
En `variables.tf` se hace uso de tipos complejos como `list(string)` para administrar las subredes:
```hcl
variable "subnet_names" {
  type        = list(string)
  description = "Lista de nombres para las subnets"
}
```

#### Parte 4 — Configuración de Outputs
El archivo `outputs.tf` expone valores calculados en tiempo de ejecución:
* Nombre del Resource Group.
* ID único de la VNET.
* Lista de IDs de las subnets (se utiliza el operador splat `[*]` debido a que las subnets se crean usando `count`):
```hcl
output "subnet_ids" {
  value       = azurerm_subnet.subnets[*].id
  description = "Lista con los IDs de las subnets aprovisionadas"
}
```

#### Parte 5 — Funciones de Terraform
Se utilizan obligatoriamente tres funciones integradas de Terraform:
1. **`lower()`:** Convierte todas las letras a minúsculas, garantizando compatibilidad con Azure (que no permite mayúsculas en ciertos nombres de recursos).
2. **`join()`:** Concatena cadenas usando un delimitador común. Ejemplo: `join("-", ["vnet", var.env_prefix, "lab02"])`.
3. **`length()`:** Calcula el tamaño de una lista. Se utiliza en `count = length(var.subnet_names)` de la subred para crear tantos recursos como elementos tenga la lista.

#### Parte 6 — Escenarios de Despliegue

##### Escenario A: Despliegue en Desarrollo (Dev)
Configura tu archivo `terraform.tfvars` con los siguientes valores:
```hcl
region              = "francecentral"
resource_group_name = "rg-lab02-iniciales" # Reemplaza 'iniciales'
env_prefix          = "dev"
vnet_address_space  = ["10.0.0.0/16"]
subnet_names        = ["subnet-web", "subnet-db"]
```
Ejecuta `terraform apply` y verifica en la terminal los outputs resultantes.

##### Escenario B: Despliegue en Preproducción (Pre)
Sin alterar los archivos `main.tf` ni `variables.tf`, crea un archivo llamado `pre.tfvars` (o modifica tu `terraform.tfvars`) con esta configuración:
```hcl
region              = "francecentral"
resource_group_name = "rg-lab02-iniciales"
env_prefix          = "pre"
vnet_address_space  = ["10.1.0.0/16"]
subnet_names        = ["subnet-frontend", "subnet-backend", "subnet-cache"]
```
Ejecuta `terraform apply -var-file="pre.tfvars"` (o usando el nuevo archivo) y observa cómo se aprovisionan **tres subredes** en lugar de dos y con nombres diferentes, variando únicamente el archivo de definición de variables.

---

### 🛠️ Eliminación de Hardcoding (Problemas Comunes)

#### ⚠️ Problema: Nombres e IPs Quemados
En implementaciones no parametrizadas, es común ver recursos declarados con cadenas fijas:
```hcl
# CÓDIGO INCORRECTO (Hardcoded)
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet-web"
  address_prefixes     = ["10.0.1.0/24"]
  ...
}
```

#### ✅ Solución Implementada:
El uso de `length()`, indexación y funciones de red como `cidrsubnet()` permiten calcular dinámicamente los direccionamientos:
```hcl
# CÓDIGO REFRACTORIZADO (Reutilizable)
resource "azurerm_subnet" "subnets" {
  count                = length(var.subnet_names)
  name                 = lower(var.subnet_names[count.index])
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.lab02.address_space[0], 8, count.index)]
  ...
}
```
Esto elimina por completo el hardcoding, posibilitando despliegues ágiles y consistentes en múltiples entornos.

---

## License

MIT
