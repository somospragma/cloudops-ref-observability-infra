# AWS CloudWatch Alarms - Implementación CLI

Esta implementación crea **93 alarmas de CloudWatch** usando AWS CLI basadas en las métricas definidas en el [README principal](../README.md).

## ✨ Características

- ✅ **20 servicios AWS** completamente implementados
- ✅ **93 alarmas CloudWatch** nativas
- ✅ **Soporte AWS SSO** con perfiles configurables
- ✅ **Filtrado por nivel de severidad** (Critical/Warning/Info)
- ✅ **Manejo correcto de datos faltantes** (`TreatMissingData: missing`)
- ✅ **Scripts modulares** por servicio AWS
- ✅ **Umbrales configurables** por métrica
- ✅ **SNS topics** para notificaciones
- ✅ **Configuración centralizada** en variables
- ✅ **Validación automática** de estado de alarmas
- ✅ **Script de testing** para simular despliegues

## 🚀 Inicio Rápido

### 1. Configuración Inicial
```bash
# Navegar al directorio
cd aws-alarms

# Configurar AWS CLI con perfil específico
aws configure --profile chapter
# O usar perfil por defecto
aws configure

# Configurar variables
cp config/config.env.example config/config.env
vim config/config.env
```

### 2. Configuración Requerida
Edita `config/config.env` con tus valores:
```bash
# Configuración AWS
AWS_PROFILE="chapter"              # Tu perfil AWS (soporta AWS SSO)
AWS_REGION="us-east-1"            # Tu región

# Configuración del proyecto
PROJECT_NAME="observability-demo"
ENVIRONMENT="test"

# Control de Niveles de Severidad
DEPLOY_CRITICAL_ALARMS=true       # Desplegar alarmas Critical
DEPLOY_WARNING_ALARMS=true        # Desplegar alarmas Warning
DEPLOY_INFO_ALARMS=false          # Desplegar alarmas Info

# SNS Topics (deben existir previamente)
SNS_TOPIC_CRITICAL="arn:aws:sns:us-east-1:840021737375:cloudwatch-alarms-critical"
SNS_TOPIC_WARNING="arn:aws:sns:us-east-1:840021737375:cloudwatch-alarms-warning"
```

### 3. Crear SNS Topics
```bash
# Los SNS topics deben existir antes del despliegue
aws sns create-topic --name <sns-topic-name> --profile chapter --region us-east-1

# Actualiza los ARNs en config/config.env
```

### 4. Probar Configuración (Opcional)
```bash
# Simular qué alarmas se crearían según tu configuración
./test-alarm-levels.sh
```

### 5. Desplegar Alarmas
```bash
# Desplegar TODAS las alarmas (respeta configuración de niveles)
make deploy
# O manualmente:
./deploy-all.sh

# Desplegar por servicio específico
bash scripts/ec2/deploy-ec2-alarms.sh
bash scripts/rds/deploy-rds-alarms.sh
```

### 6. Validar Despliegue
```bash
# Validar estado de todas las alarmas
make validate-alarms
# O manualmente:
bash utils/validate-alarms.sh
```

## 📁 Estructura del Proyecto

```
aws-alarms/
├── README.md                     # Esta documentación
├── Makefile                      # Comandos automatizados
├── deploy-all.sh                 # Script principal de despliegue
├── config/
│   ├── config.env.example       # Template de configuración
│   └── config.env               # Variables personalizadas (crear)
├── scripts/                      # Scripts por servicio AWS
│   ├── ec2/deploy-ec2-alarms.sh
│   ├── rds/deploy-rds-alarms.sh
│   ├── lambda/deploy-lambda-alarms.sh
│   ├── s3/deploy-s3-alarms.sh
│   ├── dynamodb/deploy-dynamodb-alarms.sh
│   ├── cloudfront/deploy-cloudfront-alarms.sh
│   ├── alb/deploy-alb-alarms.sh
│   ├── api-gateway/deploy-api-gateway-alarms.sh
│   ├── elasticache/deploy-elasticache-alarms.sh
│   ├── ecs/deploy-ecs-alarms.sh
│   ├── aurora/deploy-aurora-alarms.sh
│   ├── aurora-serverless/deploy-aurora-serverless-alarms.sh
│   ├── ebs/deploy-ebs-alarms.sh
│   ├── efs/deploy-efs-alarms.sh
│   ├── eks/deploy-eks-alarms.sh
│   ├── fargate/deploy-fargate-alarms.sh
│   ├── fsx/deploy-fsx-alarms.sh
│   ├── glue/deploy-glue-alarms.sh
│   ├── redshift/deploy-redshift-alarms.sh
│   └── waf/deploy-waf-alarms.sh
└── utils/
    ├── common-functions.sh       # Funciones comunes
    └── validate-alarms.sh        # Validación de alarmas
```

## ⚙️ Configuración Detallada

### Variables de Entorno (config/config.env)
```bash
# ========================================
# CONFIGURACIÓN AWS
# ========================================
AWS_PROFILE="chapter"                    # Perfil AWS CLI (soporta AWS SSO)
AWS_REGION="us-east-1"                  # Región AWS

# ========================================
# CONFIGURACIÓN DEL PROYECTO
# ========================================
PROJECT_NAME="observability-demo"       # Nombre del proyecto
ENVIRONMENT="test"                      # Ambiente (dev/test/prod)
ALARM_PREFIX="${PROJECT_NAME}-${ENVIRONMENT}"  # Prefijo de alarmas

# ========================================
# CONTROL DE NIVELES DE SEVERIDAD
# ========================================
DEPLOY_CRITICAL_ALARMS=true             # Desplegar alarmas Critical
DEPLOY_WARNING_ALARMS=true              # Desplegar alarmas Warning
DEPLOY_INFO_ALARMS=false                # Desplegar alarmas Info

# ========================================
# SNS TOPICS PARA NOTIFICACIONES
# ========================================
SNS_TOPIC_CRITICAL="arn:aws:sns:us-east-1:840021737375:cloudwatch-alarms-critical"
SNS_TOPIC_WARNING="arn:aws:sns:us-east-1:840021737375:cloudwatch-alarms-warning"

# ========================================
# CONFIGURACIÓN DE ALARMAS
# ========================================
EVALUATION_PERIODS=2                    # Períodos de evaluación
DATAPOINTS_TO_ALARM=2                   # Puntos de datos para alarma
TREAT_MISSING_DATA="missing"            # Manejo de datos faltantes

# ========================================
# UMBRALES ESPECÍFICOS
# ========================================
# RDS/Aurora/Redshift - Conexiones de BD
DB_CONNECTIONS_THRESHOLD=40             # Conexiones críticas

# ========================================
# SERVICIOS HABILITADOS
# ========================================
ENABLE_EC2_ALARMS=true
ENABLE_RDS_ALARMS=true
ENABLE_LAMBDA_ALARMS=true
# ... (todos los servicios habilitados por defecto)
```

## 🎯 Filtrado por Nivel de Severidad

Controla qué alarmas desplegar según su nivel de severidad en `config/config.env`:

```bash
# Desplegar solo alarmas críticas
DEPLOY_CRITICAL_ALARMS=true
DEPLOY_WARNING_ALARMS=false
DEPLOY_INFO_ALARMS=false

# Desplegar críticas y warnings (recomendado)
DEPLOY_CRITICAL_ALARMS=true
DEPLOY_WARNING_ALARMS=true
DEPLOY_INFO_ALARMS=false
```

### Probar Configuración
```bash
# Ver qué alarmas se crearían con tu configuración actual
./test-alarm-levels.sh

# Salida esperada:
# ✅ WOULD CREATE: demo-EC2-CPU-Critical
# ⏭️  WOULD SKIP: demo-EC2-CPU-Warning
```

### Configuración de SNS Topics
```bash
# Crear topics (REQUERIDO antes del despliegue)
aws sns create-topic --name cloudwatch-alarms-critical --profile chapter --region us-east-1
aws sns create-topic --name cloudwatch-alarms-warning --profile chapter --region us-east-1

# Suscribir email
aws sns subscribe \
  --topic-arn "arn:aws:sns:us-east-1:840021737375:cloudwatch-alarms-critical" \
  --protocol email \
  --notification-endpoint admin@company.com \
  --profile chapter \
  --region us-east-1
```

## 🔧 Servicios Implementados (93 Alarmas Total)

### ✅ Todos los 20 Servicios AWS Implementados

| Servicio | Alarmas | Métricas Principales | Estado |
|----------|---------|---------------------|--------|
| **EC2** | 9 | CPU, StatusCheck, Network, Disk I/O | ✅ |
| **RDS** | 8 | CPU, Conexiones, Memoria, Storage, Latencia | ✅ |
| **Lambda** | 7 | Errores, Throttles, Duración, Concurrencia | ✅ |
| **S3** | 8 | Errores 4xx/5xx, Latencia, Requests | ✅ |
| **DynamoDB** | 6 | Throttles, Errores, Capacidad, Latencia | ✅ |
| **CloudFront** | 5 | Errores, Latencia, Cache Hit Rate | ✅ |
| **ALB** | 5 | Errores, Healthy Hosts, Latencia | ✅ |
| **API Gateway** | 4 | Errores 4xx/5xx, Latencia | ✅ |
| **ElastiCache** | 5 | CPU, Memoria, Evictions, Conexiones | ✅ |
| **ECS** | 4 | CPU, Memoria, Tasks | ✅ |
| **Aurora** | 5 | CPU, Conexiones, Latencia, Replica Lag | ✅ |
| **Aurora Serverless** | 3 | Capacidad, ACU, Conexiones | ✅ |
| **EBS** | 3 | I/O, Throughput, Burst Balance | ✅ |
| **EFS** | 3 | I/O Limit, Burst Credits, Conexiones | ✅ |
| **EKS** | 4 | CPU/Memoria Nodos y Pods | ✅ |
| **Fargate** | 3 | CPU, Memoria, Tasks | ✅ |
| **FSx** | 1 | Storage Utilization | ✅ |
| **Glue** | 4 | Failed Tasks, Elapsed Time, Heap | ✅ |
| **Redshift** | 5 | CPU, Conexiones, Disk Space, Latencia | ✅ |
| **WAF** | 1 | Blocked Requests Rate | ✅ |

### 🎯 Manejo de Datos Faltantes

**Configuración Correcta**: `TreatMissingData: missing`

- **Servicios Activos** → Estado `OK` o `ALARM` según métricas reales
- **Servicios Inactivos** → Estado `INSUFFICIENT_DATA` (comportamiento esperado)
- **Servicios sin Configurar** → Estado `INSUFFICIENT_DATA` hasta que se activen

**Servicios que Requieren Configuración Especial**:
- **EKS/Fargate**: Requieren Container Insights habilitado
- **Aurora**: Requiere clusters activos para métricas
- **API Gateway**: Requiere tráfico activo para generar métricas
- **WAF**: Requiere configuración y tráfico web

## 📊 Comandos de Uso

### Comandos Make (Recomendado)
```bash
# Ver todos los comandos disponibles
make help

# Configurar proyecto inicial
make setup

# Desplegar todas las alarmas
make deploy

# Validar estado de alarmas
make validate-alarms

# Limpiar todas las alarmas
make clean
```

### Comandos Manuales
```bash
# Desplegar todas las alarmas
./deploy-all.sh

# Desplegar servicio específico
bash scripts/ec2/deploy-ec2-alarms.sh
bash scripts/rds/deploy-rds-alarms.sh

# Validar alarmas
bash utils/validate-alarms.sh
```

### Gestión de Alarmas
```bash
# Listar alarmas del proyecto
aws cloudwatch describe-alarms \
  --alarm-name-prefix "observability-demo-test" \
  --profile chapter

# Ver alarmas en estado ALARM
aws cloudwatch describe-alarms \
  --state-value ALARM \
  --profile chapter

# Ver alarmas con datos insuficientes
aws cloudwatch describe-alarms \
  --state-value INSUFFICIENT_DATA \
  --profile chapter
```

### Crear Alarma Individual (Ejemplo)
```bash
# Cargar configuración
source config/config.env

# Crear alarma usando función común
create_alarm "${ALARM_PREFIX}-EC2-CPU-Critical" \
  "EC2 CPU utilization is critically high" \
  "CPUUtilization" \
  "AWS/EC2" \
  "90" \
  "GreaterThanThreshold" \
  "${SNS_TOPIC_CRITICAL}"
```

## 🚨 Configuración de Notificaciones

### Crear SNS Topics
```bash
# Topics para alertas
aws sns create-topic --name cloudwatch-alarms-critical --profile chapter
aws sns create-topic --name cloudwatch-alarms-warning --profile chapter

# Obtener ARNs (actualizar en config.env)
aws sns list-topics --profile chapter
```

### Suscribir Notificaciones
```bash
# Email para alertas críticas
aws sns subscribe \
  --topic-arn "arn:aws:sns:us-east-1:840021737375:cloudwatch-alarms-critical" \
  --protocol email \
  --notification-endpoint admin@company.com \
  --profile chapter

# Slack webhook (opcional)
aws sns subscribe \
  --topic-arn "arn:aws:sns:us-east-1:840021737375:cloudwatch-alarms-critical" \
  --protocol https \
  --notification-endpoint "https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK" \
  --profile chapter

# SMS (opcional)
aws sns subscribe \
  --topic-arn "arn:aws:sns:us-east-1:840021737375:cloudwatch-alarms-critical" \
  --protocol sms \
  --notification-endpoint "+1234567890" \
  --profile chapter
```

### Probar Notificaciones
```bash
# Enviar notificación de prueba
aws sns publish \
  --topic-arn "arn:aws:sns:us-east-1:840021737375:cloudwatch-alarms-critical" \
  --message "Prueba de notificación CloudWatch" \
  --subject "Test Alert" \
  --profile chapter
```

## 🔍 Monitoreo y Validación

### Validación Automática
```bash
# Script de validación completo
bash utils/validate-alarms.sh

# Salida esperada:
# ✅ Total alarms: 93
# ✅ Working alarms: 57 (61%)
# ⚠️  Insufficient data: 36 (39% - servicios inactivos)
```

### Estados de Alarmas Esperados

**🟢 OK/ALARM (Servicios Activos)**:
- EC2, Lambda, S3, ECS (si tienes recursos)
- RDS, Aurora (si tienes bases de datos)
- DynamoDB (si tienes tablas)

**🟡 INSUFFICIENT_DATA (Normal para Servicios Inactivos)**:
- EKS, Fargate (sin Container Insights)
- ElastiCache, Redshift (sin clusters)
- API Gateway, CloudFront (sin tráfico)
- Aurora Serverless, EFS, FSx (sin recursos)
- Glue, WAF (sin jobs/configuración)

### Troubleshooting

**Problema**: Alarmas en estado `OK` cuando deberían estar en `INSUFFICIENT_DATA`
```bash
# Verificar configuración de datos faltantes
aws cloudwatch describe-alarms \
  --query 'MetricAlarms[?TreatMissingData==`notBreaching`].{Name:AlarmName,TreatMissingData:TreatMissingData}' \
  --profile chapter

# Re-desplegar servicio con configuración incorrecta
bash scripts/redshift/deploy-redshift-alarms.sh
```

**Problema**: SNS topics no accesibles
```bash
# Verificar que existen los topics
aws sns list-topics --profile chapter

# Verificar permisos
aws sns get-topic-attributes \
  --topic-arn "arn:aws:sns:us-east-1:840021737375:cloudwatch-alarms-critical" \
  --profile chapter
```

### Comandos de Diagnóstico
```bash
# Ver historial de alarma específica
aws cloudwatch describe-alarm-history \
  --alarm-name "observability-demo-test-EC2-CPU-Critical" \
  --profile chapter

# Ver métricas disponibles por servicio
aws cloudwatch list-metrics --namespace AWS/EC2 --profile chapter
aws cloudwatch list-metrics --namespace AWS/Lambda --profile chapter

# Ver datos recientes de métrica
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average \
  --profile chapter
```

## 📝 Personalización y Extensión

### Modificar Umbrales Globales
Edita `config/config.env`:
```bash
# Umbrales específicos
DB_CONNECTIONS_THRESHOLD=40        # Conexiones de BD
EVALUATION_PERIODS=2              # Períodos de evaluación
DATAPOINTS_TO_ALARM=2             # Puntos para alarma
TREAT_MISSING_DATA="missing"      # Manejo de datos faltantes
```

### Modificar Umbrales por Servicio
Edita directamente en cada script:
```bash
# Ejemplo: scripts/ec2/deploy-ec2-alarms.sh
create_alarm "${ALARM_PREFIX}-EC2-CPU-Critical" \
  "EC2 CPU utilization is high" \
  "CPUUtilization" \
  "AWS/EC2" \
  "85" \                          # Cambiar de 90 a 85
  "GreaterThanThreshold" \
  "$SNS_TOPIC_CRITICAL"
```

### Agregar Nuevas Alarmas
1. **Crear script de servicio**:
```bash
# Crear nuevo servicio
mkdir -p scripts/mi-servicio
cp scripts/ec2/deploy-ec2-alarms.sh scripts/mi-servicio/deploy-mi-servicio-alarms.sh
```

2. **Modificar parámetros**:
```bash
# En el nuevo script
create_alarm "${ALARM_PREFIX}-MiServicio-Metrica-Critical" \
  "Descripción de la alarma" \
  "NombreMetrica" \
  "AWS/MiServicio" \
  "100" \
  "GreaterThanThreshold" \
  "$SNS_TOPIC_CRITICAL"
```

3. **Actualizar deploy-all.sh**:
```bash
# Agregar a la lista de servicios
services=(
    "ec2:EC2"
    "rds:RDS"
    # ...
    "mi-servicio:Mi Servicio"  # Agregar aquí
)
```

### Habilitar/Deshabilitar Servicios
En `config/config.env`:
```bash
# Deshabilitar servicios no utilizados
ENABLE_REDSHIFT_ALARMS=false
ENABLE_EKS_ALARMS=false
ENABLE_GLUE_ALARMS=false
```

## 🎯 Resultados Esperados

### Después del Despliegue Exitoso
```bash
# Ejecutar validación
make validate-alarms

# Resultado esperado:
✅ Total alarms: 93
✅ Working alarms: 57-82 (dependiendo de servicios activos)
⚠️  Insufficient data: 11-36 (servicios inactivos - normal)
✅ Success rate: 61-88%
```

### Estados por Tipo de Servicio

**🟢 Servicios Básicos (Siempre Activos)**:
- EC2, Lambda, S3 → `OK` o `ALARM`
- ECS, EBS → `OK` o `ALARM`

**🟡 Servicios de Base de Datos**:
- RDS, Aurora → `OK`/`ALARM` si tienes DBs, `INSUFFICIENT_DATA` si no
- DynamoDB → `OK`/`ALARM` si tienes tablas, `INSUFFICIENT_DATA` si no

**🔴 Servicios Especializados**:
- EKS, Fargate → `INSUFFICIENT_DATA` (requiere Container Insights)
- ElastiCache, Redshift → `INSUFFICIENT_DATA` (requiere clusters)
- API Gateway, CloudFront → `INSUFFICIENT_DATA` (requiere tráfico)

## 🚀 Próximos Pasos

1. **Verificar Notificaciones**: Confirmar suscripciones SNS por email
2. **Monitorear Alarmas**: Revisar AWS Console regularmente
3. **Ajustar Umbrales**: Personalizar según patrones de uso
4. **Documentar Cambios**: Mantener registro de modificaciones

## 🔗 Referencias y Documentación

### Documentación AWS
- [AWS CloudWatch CLI Reference](https://docs.aws.amazon.com/cli/latest/reference/cloudwatch/)
- [CloudWatch Metrics and Dimensions](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html)
- [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)

### Documentación del Proyecto
- 📖 **[README Principal - Métricas](../README.md)**: Definiciones completas de métricas
- 🏗️ **[Implementación Datadog](../datadog-monitors/)**: Alternativa con Terraform
- ⚙️ **[Configuración](./config/config.env.example)**: Variables de configuración

### Herramientas Relacionadas
- [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [AWS CLI Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- [SNS Topics Management](https://docs.aws.amazon.com/sns/latest/dg/sns-create-topic.html)

---

## 📋 Checklist de Implementación

### ✅ Pre-requisitos
- [ ] AWS CLI instalado y configurado
- [ ] Perfil AWS con permisos CloudWatch y SNS
- [ ] SNS Topics creados y configurados
- [ ] Archivo `config/config.env` configurado

### ✅ Despliegue
- [ ] Ejecutar `make setup` o configurar manualmente
- [ ] Ejecutar `make deploy` o `./deploy-all.sh`
- [ ] Verificar que se crearon 93 alarmas
- [ ] Ejecutar `make validate-alarms`

### ✅ Validación
- [ ] Confirmar suscripciones SNS por email
- [ ] Probar notificaciones con `aws sns publish`
- [ ] Verificar alarmas en AWS Console
- [ ] Documentar umbrales personalizados

### ✅ Mantenimiento
- [ ] Revisar alarmas semanalmente
- [ ] Ajustar umbrales según patrones de uso
- [ ] Actualizar configuración cuando agregues servicios
- [ ] Mantener documentación actualizada