# Guía de Implementación - Monitores Datadog

Esta guía te ayudará a implementar los monitores de Datadog basados en las métricas definidas en el [README principal](../README.md).

## 🚀 Inicio Rápido

### 1. Configuración Inicial
```bash
# Clonar y navegar al directorio
cd datadog-monitors

# Configurar proyecto
make setup

# Editar variables
vim terraform.tfvars
```

### 2. Configurar Credenciales de Datadog
```bash
# En terraform.tfvars
datadog_api_key = "tu-api-key-aqui"
datadog_app_key = "tu-app-key-aqui"
```

### 3. Desplegar Monitores
```bash
# Validar y aplicar
make deploy
```

## 📋 Implementación por Servicio

### Servicios Completamente Implementados
- ✅ **EC2**: 9 monitores (CPU, Status Checks, Network, EBS)

### Servicios Pendientes de Implementación
Los siguientes servicios tienen la estructura creada pero requieren implementación:

- 🔄 **CloudFront**: 7 monitores por implementar
- 🔄 **ALB**: 10 monitores por implementar  
- 🔄 **RDS**: 9 monitores por implementar
- 🔄 **Aurora**: 11 monitores por implementar
- 🔄 **Aurora Serverless**: 5 monitores por implementar
- 🔄 **S3**: 10 monitores por implementar
- 🔄 **DynamoDB**: 8 monitores por implementar
- 🔄 **Lambda**: 8 monitores por implementar
- 🔄 **EFS**: 9 monitores por implementar
- 🔄 **EBS**: 7 monitores por implementar
- 🔄 **FSx**: 6 monitores por implementar
- 🔄 **WAF**: 6 monitores por implementar
- 🔄 **Redshift**: 9 monitores por implementar
- 🔄 **Glue**: 6 monitores por implementar
- 🔄 **ElastiCache**: 12 monitores por implementar
- 🔄 **EKS**: 7 monitores por implementar
- 🔄 **ECS**: 7 monitores por implementar
- 🔄 **Fargate**: 5 monitores por implementar
- 🔄 **API Gateway**: 7 monitores por implementar

## 🔧 Cómo Implementar un Servicio

### Paso 1: Revisar Métricas en README
Consulta las métricas definidas en [../README.md](../README.md) para el servicio específico.

### Paso 2: Implementar Variables
Edita `{servicio}/variables.tf` y agrega las variables de umbral:

```hcl
# Ejemplo para CloudFront
variable "error_4xx_critical_threshold" {
  description = "Critical threshold for 4xx error rate (%)"
  type        = number
  default     = 5
}

variable "error_4xx_warning_threshold" {
  description = "Warning threshold for 4xx error rate (%)"
  type        = number
  default     = 2
}
```

### Paso 3: Crear Monitores
Edita `{servicio}/main.tf` usando el patrón del módulo EC2:

```hcl
# CloudFront 4xx Error Rate - Critical
resource "datadog_monitor" "cloudfront_4xx_error_critical" {
  name    = "[${var.environment}] CloudFront 4xx Error Rate Critical"
  type    = "metric alert"
  message = "${var.default_message} ${join(" ", var.critical_notification_channels)}"

  query = "avg(last_5m):avg:aws.cloudfront.4xx_error_rate{environment:${var.environment}} by {distributionid} > ${var.error_4xx_critical_threshold}"

  monitor_thresholds {
    critical = var.error_4xx_critical_threshold
    warning  = var.error_4xx_warning_threshold
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60

  tags = concat(var.tags, ["service:cloudfront", "severity:critical", "metric:4xx_error_rate"])
}
```

### Paso 4: Actualizar Outputs
Edita `{servicio}/outputs.tf`:

```hcl
output "monitor_ids" {
  description = "Map of CloudFront monitor names to their IDs"
  value = {
    cloudfront_4xx_error_critical = datadog_monitor.cloudfront_4xx_error_critical.id
    # ... otros monitores
  }
}
```

### Paso 5: Documentar
Actualiza `{servicio}/README.md` con la información específica del servicio.

## 📊 Mapeo de Métricas AWS a Datadog

### Convenciones de Naming
- **AWS CloudWatch**: `aws.{service}.{metric_name}`
- **Ejemplo EC2**: `aws.ec2.cpuutilization`
- **Ejemplo RDS**: `aws.rds.database_connections`

### Métricas Comunes por Servicio

#### EC2
```
aws.ec2.cpuutilization
aws.ec2.status_check_failed
aws.ec2.status_check_failed_instance
aws.ec2.status_check_failed_system
aws.ec2.network_in
aws.ec2.network_out
```

#### RDS
```
aws.rds.cpuutilization
aws.rds.database_connections
aws.rds.freeable_memory
aws.rds.free_storage_space
aws.rds.read_latency
aws.rds.write_latency
```

#### Lambda
```
aws.lambda.errors
aws.lambda.throttles
aws.lambda.duration
aws.lambda.invocations
aws.lambda.concurrent_executions
```

## 🎯 Configuración de Umbrales

### Principios Generales
1. **Crítico**: Impacto inmediato en disponibilidad
2. **Warning**: Degradación de performance
3. **Baseline + X%**: Calcular basándose en operación normal

### Ejemplos de Umbrales por Tipo

#### CPU/Memoria
```hcl
cpu_critical_threshold = 90    # %
cpu_warning_threshold  = 80    # %
memory_critical_threshold = 90 # %
memory_warning_threshold  = 80 # %
```

#### Latencia
```hcl
latency_critical_threshold = 5000  # ms
latency_warning_threshold  = 2000  # ms
```

#### Errores
```hcl
error_rate_critical_threshold = 5   # %
error_rate_warning_threshold  = 2   # %
```

#### Capacidad
```hcl
disk_space_critical_threshold = 2000000000  # bytes (2GB)
disk_space_warning_threshold  = 5000000000  # bytes (5GB)
```

## 🔍 Queries de Datadog

### Estructura Básica
```
avg(last_Xm):metric{filters} by {group} operator threshold
```

### Ejemplos por Tipo de Monitor

#### Threshold Alert
```
avg(last_5m):avg:aws.ec2.cpuutilization{environment:prod} by {host} > 90
```

#### Anomaly Detection
```
avg(last_4h):anomalies(avg:aws.rds.database_connections{environment:prod} by {dbinstanceidentifier}, 'basic', 2, direction='above') >= 1
```

#### Forecast Alert
```
avg(next_1h):forecast(avg:aws.s3.bucket_size_bytes{environment:prod} by {bucketname}, 'linear', 1) > 1000000000000
```

#### Composite Monitor
```
a && b
```

### Filtros Comunes
```hcl
# Por ambiente
{environment:${var.environment}}

# Por región
{region:us-east-1}

# Por equipo
{team:backend}

# Por tipo de instancia
{instance-type:t3.medium}

# Combinados
{environment:${var.environment},team:backend,region:us-east-1}
```

## 🚨 Configuración de Alertas

### Canales de Notificación
```hcl
# Crítico
critical_notification_channels = [
  "@slack-critical",
  "@pagerduty-oncall", 
  "@email-oncall@company.com"
]

# Warning
warning_notification_channels = [
  "@slack-warnings",
  "@email-team@company.com"
]
```

### Configuración de Renotificación
```hcl
# Crítico: cada 30-60 minutos
renotify_interval = 60

# Warning: cada 2-4 horas  
renotify_interval = 240

# No renotificar
renotify_interval = 0
```

### No Data Alerts
```hcl
# Para métricas críticas
notify_no_data    = true
no_data_timeframe = 10  # minutos

# Para métricas de performance
notify_no_data    = false
```

## 🔄 Workflow de Desarrollo

### 1. Desarrollo Local
```bash
# Validar sintaxis
make validate

# Formatear código
make fmt

# Planificar cambios
make plan
```

### 2. Testing
```bash
# Aplicar en ambiente de desarrollo
terraform workspace select dev
make apply

# Verificar monitores
make output
```

### 3. Producción
```bash
# Cambiar a producción
terraform workspace select prod

# Aplicar cambios
make apply
```

## 📝 Checklist de Implementación

### Por Cada Servicio
- [ ] Revisar métricas en README principal
- [ ] Implementar variables de umbral
- [ ] Crear recursos de monitores
- [ ] Actualizar outputs
- [ ] Documentar en README del servicio
- [ ] Probar en ambiente de desarrollo
- [ ] Validar alertas funcionan correctamente

### Validaciones
- [ ] Todas las métricas del README están implementadas
- [ ] Umbrales son apropiados para el ambiente
- [ ] Canales de notificación están configurados
- [ ] Tags están aplicados correctamente
- [ ] Documentación está actualizada

## 🆘 Troubleshooting

### Errores Comunes

#### Error: Invalid metric name
```
Error: metric 'aws.ec2.cpu_utilization' not found
```
**Solución**: Verificar nombre correcto de métrica en Datadog

#### Error: Threshold validation
```
Error: critical threshold must be greater than warning threshold
```
**Solución**: Ajustar valores de umbrales

#### Error: No data
```
Monitor shows "No Data"
```
**Solución**: Verificar que las métricas están siendo enviadas y los filtros son correctos

### Comandos Útiles

```bash
# Ver estado de recursos
terraform state list

# Ver detalles de un recurso
terraform state show datadog_monitor.ec2_cpu_critical

# Importar monitor existente
terraform import datadog_monitor.existing_monitor 12345

# Refrescar estado
make refresh
```

## 📚 Referencias

- [Documentación Datadog Terraform Provider](https://registry.terraform.io/providers/DataDog/datadog/latest/docs)
- [Métricas AWS en Datadog](https://docs.datadoghq.com/integrations/amazon_web_services/)
- [README Principal - Métricas](../README.md)
- [Datadog Monitor API](https://docs.datadoghq.com/api/latest/monitors/)