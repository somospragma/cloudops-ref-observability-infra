# Monitores de Datadog - Terraform

Esta carpeta contiene los monitores de Datadog implementados con Terraform, basados en las métricas definidas en el [README principal](../README.md).

## 📁 Estructura

```
datadog-monitors/
├── README.md                    # Este archivo
├── variables.tf                 # Variables globales
├── outputs.tf                   # Outputs globales
├── main.tf                      # Configuración principal
├── ec2/                         # Monitores EC2
├── cloudfront/                  # Monitores CloudFront
├── alb/                         # Monitores Application Load Balancer
├── rds/                         # Monitores RDS
├── aurora/                      # Monitores Aurora
├── aurora-serverless/           # Monitores Aurora Serverless
├── s3/                          # Monitores S3
├── dynamodb/                    # Monitores DynamoDB
├── lambda/                      # Monitores Lambda
├── efs/                         # Monitores EFS
├── ebs/                         # Monitores EBS
├── fsx/                         # Monitores FSx
├── waf/                         # Monitores WAF
├── redshift/                    # Monitores Redshift
├── glue/                        # Monitores Glue
├── elasticache/                 # Monitores ElastiCache
├── eks/                         # Monitores EKS
├── ecs/                         # Monitores ECS
├── fargate/                     # Monitores Fargate
└── api-gateway/                 # Monitores API Gateway
```

## 🚀 Uso

### Prerrequisitos
- Terraform >= 1.0
- Provider Datadog configurado
- API Key y Application Key de Datadog

### Configuración
1. Configurar variables en `terraform.tfvars`
2. Ejecutar `terraform init`
3. Ejecutar `terraform plan`
4. Ejecutar `terraform apply`

### Variables Principales
- `datadog_api_key`: API Key de Datadog
- `datadog_app_key`: Application Key de Datadog
- `environment`: Ambiente (dev, staging, prod)
- `project_name`: Nombre del proyecto
- `notification_channels`: Canales de notificación

## 📊 Tipos de Monitores

### 🔴 Críticos
- Impacto inmediato en disponibilidad
- Notificación inmediata 24/7
- Escalamiento automático

### 🟡 Warning
- Degradación de performance
- Notificación en horario laboral
- Revisión programada

### 📊 Informativos
- Métricas de tendencia
- Reportes semanales
- Planificación de capacidad

## 🔧 Personalización

Cada servicio incluye:
- `main.tf`: Definición de monitores
- `variables.tf`: Variables específicas del servicio
- `outputs.tf`: Outputs del servicio
- `README.md`: Documentación específica

## ⚠️ Importante

Los umbrales definidos son **valores de referencia** que deben ser ajustados según:
- Patrones de uso específicos del proyecto
- SLAs requeridos
- Tolerancia al riesgo
- Recursos disponibles