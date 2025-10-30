# Guía de Métricas de Monitoreo AWS - Línea Base

## 📋 Índice
- [Introducción](#introducción)
- [EC2 - Elastic Compute Cloud](#ec2---elastic-compute-cloud)
- [CloudFront](#cloudfront)
- [ALB - Application Load Balancer](#alb---application-load-balancer)
- [RDS - Relational Database Service](#rds---relational-database-service)
- [Aurora](#aurora)
- [Aurora Serverless](#aurora-serverless)
- [S3 - Simple Storage Service](#s3---simple-storage-service)
- [DynamoDB](#dynamodb)
- [Lambda](#lambda)
- [EFS - Elastic File System](#efs---elastic-file-system)
- [EBS - Elastic Block Store](#ebs---elastic-block-store)
- [FSx](#fsx)
- [WAF - Web Application Firewall](#waf---web-application-firewall)
- [Redshift](#redshift)
- [Glue](#glue)
- [ElastiCache](#elasticache)
- [EKS - Elastic Kubernetes Service](#eks---elastic-kubernetes-service)
- [ECS - Elastic Container Service](#ecs---elastic-container-service)
- [Fargate](#fargate)
- [API Gateway](#api-gateway)
- [Umbrales Recomendados](#umbrales-recomendados)
- [Alertas Críticas](#alertas-críticas)

## Introducción

Este documento define las métricas estándar que deben monitorearse para cada servicio de AWS en nuestras cargas de trabajo. Estas métricas han sido seleccionadas como línea base para garantizar la observabilidad completa de la infraestructura.

> **⚠️ Nota Importante**: Las métricas y umbrales presentados en este documento son **valores de referencia**. Deben ser ajustados y validados según las necesidades específicas, patrones de uso y SLAs de cada proyecto.

## 🔧 Implementaciones Disponibles

Este repositorio incluye **DOS implementaciones completas** basadas en todas las métricas definidas en este documento:

### 🎯 Opción 1: Datadog + Terraform
📁 **Ubicación**: [`./datadog-monitors/`](./datadog-monitors/)

**Características:**
- ✅ **20 servicios AWS** completamente implementados
- ✅ **120+ monitores** Datadog funcionales
- ✅ **Estructura modular** por servicio AWS
- ✅ **Variables personalizables** para umbrales
- ✅ **Canales de notificación** configurables
- ✅ **Tags automáticos** para organización

**Inicio Rápido:**
```bash
cd datadog-monitors
make setup
# Editar terraform.tfvars con tus credenciales
make deploy
```

### 🎯 Opción 2: AWS CloudWatch + AWS CLI
📁 **Ubicación**: [`./aws-alarms/`](./aws-alarms/)

**Características:**
- ✅ **20 servicios AWS** completamente implementados
- ✅ **120+ alarmas CloudWatch** nativas
- ✅ **Scripts modulares** por servicio AWS
- ✅ **Umbrales configurables** por métrica
- ✅ **SNS topics** para notificaciones
- ✅ **Configuración centralizada** en variables

**Inicio Rápido:**
```bash
cd aws-alarms
make setup
# Editar config/config.env con tus configuraciones
make deploy
```

### 📊 Comparación de Implementaciones

| Característica | Datadog-Terraform | AWS CloudWatch-CLI |
|----------------|-------------------|--------------------|
| **Servicios AWS** | 20/20 ✅ | 20/20 ✅ |
| **Plataforma** | Datadog (SaaS) | AWS CloudWatch (Nativo) |
| **Infraestructura como Código** | Terraform | Bash Scripts + AWS CLI |
| **Costo** | Licencia Datadog | Solo costos AWS |
| **Dashboards** | Datadog UI | AWS Console |
| **Alertas** | Datadog Notifications | SNS Topics |
| **Umbrales** | Configurables | Configurables |
| **Mantenimiento** | `terraform apply` | `make deploy` |

### 🔗 Documentación Detallada
- 📖 **Datadog**: [IMPLEMENTATION_GUIDE.md](./datadog-monitors/IMPLEMENTATION_GUIDE.md)
- 📖 **CloudWatch**: [README.md](./aws-alarms/README.md)

---

## EC2 - Elastic Compute Cloud

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `CPUUtilization` | Porcentaje de CPU utilizada | > 90% | > 80% |
| `StatusCheckFailed` | Fallas en verificaciones de estado | > 0 | N/A |
| `StatusCheckFailed_Instance` | Fallas en verificación de instancia | > 0 | N/A |
| `StatusCheckFailed_System` | Fallas en verificación del sistema | > 0 | N/A |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `NetworkIn` | Bytes recibidos por la red | Baseline + 300% | Baseline + 200% |
| `NetworkOut` | Bytes enviados por la red | Baseline + 300% | Baseline + 200% |
| `DiskReadOps` | Operaciones de lectura de disco | Baseline + 300% | Baseline + 200% |
| `DiskWriteOps` | Operaciones de escritura de disco | Baseline + 300% | Baseline + 200% |
| `NetworkPacketsIn` | Paquetes recibidos | Baseline + 300% | Baseline + 200% |
| `NetworkPacketsOut` | Paquetes enviados | Baseline + 300% | Baseline + 200% |

### 📊 Métricas de Capacidad
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `EBSReadBytes` | Bytes leídos de EBS | Baseline + 400% | Baseline + 300% |
| `EBSWriteBytes` | Bytes escritos a EBS | Baseline + 400% | Baseline + 300% |
| `EBSIOBalance%` | Balance de créditos I/O | < 10% | < 20% |
| `EBSByteBalance%` | Balance de créditos de throughput | < 10% | < 20% |

---

## CloudFront

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `4xxErrorRate` | Tasa de errores 4xx | > 5% | > 2% |
| `5xxErrorRate` | Tasa de errores 5xx | > 1% | > 0.5% |
| `OriginLatency` | Latencia del origen | > 30s | > 10s |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `Requests` | Número total de requests | Baseline + 500% | Baseline + 300% |
| `BytesDownloaded` | Bytes descargados por usuarios | Baseline + 500% | Baseline + 300% |
| `BytesUploaded` | Bytes subidos por usuarios | Baseline + 500% | Baseline + 300% |
| `CacheHitRate` | Tasa de aciertos de caché | < 80% | < 85% |

---

## ALB - Application Load Balancer

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `HTTPCode_ELB_5XX_Count` | Errores 5xx del ELB | > 10/min | > 5/min |
| `HTTPCode_Target_5XX_Count` | Errores 5xx de targets | > 10/min | > 5/min |
| `UnHealthyHostCount` | Hosts no saludables | > 0 | N/A |
| `TargetResponseTime` | Tiempo de respuesta de targets | > 5s | > 2s |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `RequestCount` | Número de requests | Baseline + 400% | Baseline + 300% |
| `ActiveConnectionCount` | Conexiones activas | Baseline + 400% | Baseline + 300% |
| `NewConnectionCount` | Nuevas conexiones | Baseline + 400% | Baseline + 300% |
| `HTTPCode_Target_4XX_Count` | Errores 4xx de targets | > 50/min | > 25/min |
| `HTTPCode_ELB_4XX_Count` | Errores 4xx del ELB | > 50/min | > 25/min |

### 📊 Métricas de Capacidad
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `HealthyHostCount` | Hosts saludables | < 2 | < 3 |
| `ConsumedLCUs` | Load Balancer Capacity Units | > 80% del límite | > 70% del límite |

---

## RDS - Relational Database Service

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `CPUUtilization` | Utilización de CPU | > 90% | > 80% |
| `DatabaseConnections` | Conexiones activas | > 80% del máximo | > 70% del máximo |
| `FreeableMemory` | Memoria libre | < 100MB | < 500MB |
| `FreeStorageSpace` | Espacio libre en disco | < 2GB | < 5GB |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `ReadLatency` | Latencia de lectura | > 200ms | > 100ms |
| `WriteLatency` | Latencia de escritura | > 200ms | > 100ms |
| `ReadIOPS` | IOPS de lectura | Baseline + 300% | Baseline + 200% |
| `WriteIOPS` | IOPS de escritura | Baseline + 300% | Baseline + 200% |
| `SwapUsage` | Uso de swap | > 256MB | > 128MB |

### 📊 Métricas de Replicación
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `ReplicaLag` | Retraso de réplica | > 300s | > 60s |
| `BinLogDiskUsage` | Uso de disco binlog | > 80% | > 70% |

---

## Aurora

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `CPUUtilization` | Utilización de CPU | > 90% | > 80% |
| `DatabaseConnections` | Conexiones activas | > 80% del máximo | > 70% del máximo |
| `FreeableMemory` | Memoria libre | < 100MB | < 500MB |
| `AuroraReplicaLag` | Retraso de réplica Aurora | > 1000ms | > 500ms |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `SelectLatency` | Latencia de SELECT | > 100ms | > 50ms |
| `InsertLatency` | Latencia de INSERT | > 100ms | > 50ms |
| `UpdateLatency` | Latencia de UPDATE | > 100ms | > 50ms |
| `DeleteLatency` | Latencia de DELETE | > 100ms | > 50ms |
| `CommitLatency` | Latencia de COMMIT | > 100ms | > 50ms |

### 📊 Métricas Específicas de Aurora
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `AuroraVolumeBytesLeftTotal` | Espacio libre en volumen | < 10GB | < 50GB |
| `BackupRetentionPeriodStorageUsed` | Almacenamiento de backup | > 80% del límite | > 70% del límite |
| `SnapshotStorageUsed` | Almacenamiento de snapshots | > 80% del límite | > 70% del límite |

---

## Aurora Serverless

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `ServerlessDatabaseCapacity` | Capacidad actual | > 90% del máximo | > 80% del máximo |
| `ACUUtilization` | Utilización de ACU | > 90% | > 80% |
| `DatabaseConnections` | Conexiones activas | > 80% del máximo | > 70% del máximo |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `QueryDuration` | Duración de queries | > 30s | > 10s |
| `SelectLatency` | Latencia de SELECT | > 200ms | > 100ms |
| `InsertLatency` | Latencia de INSERT | > 200ms | > 100ms |

---

## S3 - Simple Storage Service

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `4xxErrors` | Errores 4xx | > 5% de requests | > 2% de requests |
| `5xxErrors` | Errores 5xx | > 1% de requests | > 0.5% de requests |
| `AllRequestsErrors` | Total de errores | > 5% de requests | > 2% de requests |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `AllRequests` | Total de requests | Baseline + 500% | Baseline + 300% |
| `GetRequests` | Requests GET | Baseline + 500% | Baseline + 300% |
| `PutRequests` | Requests PUT | Baseline + 500% | Baseline + 300% |
| `DeleteRequests` | Requests DELETE | Baseline + 500% | Baseline + 300% |
| `FirstByteLatency` | Latencia primer byte | > 1000ms | > 500ms |
| `TotalRequestLatency` | Latencia total | > 5000ms | > 2000ms |

### 📊 Métricas de Capacidad
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `BucketSizeBytes` | Tamaño del bucket | > 80% del límite | > 70% del límite |
| `NumberOfObjects` | Número de objetos | > 80% del límite | > 70% del límite |

---

## DynamoDB

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `ThrottledRequests` | Requests throttled | > 0 | N/A |
| `SystemErrors` | Errores del sistema | > 0 | N/A |
| `UserErrors` | Errores de usuario | > 5% de requests | > 2% de requests |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `ConsumedReadCapacityUnits` | RCU consumidas | > 80% provisionadas | > 70% provisionadas |
| `ConsumedWriteCapacityUnits` | WCU consumidas | > 80% provisionadas | > 70% provisionadas |
| `SuccessfulRequestLatency` | Latencia de requests exitosos | > 100ms | > 50ms |
| `ItemCount` | Número de items | Baseline + 300% | Baseline + 200% |
| `TableSize` | Tamaño de la tabla | Baseline + 300% | Baseline + 200% |

### 📊 Métricas de Capacidad
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `ProvisionedReadCapacityUnits` | RCU provisionadas | Monitoreo | Monitoreo |
| `ProvisionedWriteCapacityUnits` | WCU provisionadas | Monitoreo | Monitoreo |

---

## Lambda

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `Errors` | Número de errores | > 5% de invocaciones | > 2% de invocaciones |
| `Throttles` | Invocaciones throttled | > 0 | N/A |
| `DeadLetterErrors` | Errores en DLQ | > 0 | N/A |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `Duration` | Duración de ejecución | > 80% del timeout | > 70% del timeout |
| `Invocations` | Número de invocaciones | Baseline + 500% | Baseline + 300% |
| `ConcurrentExecutions` | Ejecuciones concurrentes | > 80% del límite | > 70% del límite |
| `IteratorAge` | Edad del iterador (streams) | > 60000ms | > 30000ms |

### 📊 Métricas de Capacidad
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `UnreservedConcurrentExecutions` | Concurrencia no reservada | < 100 | < 200 |
| `ProvisionedConcurrencyUtilization` | Utilización concurrencia provisionada | > 90% | > 80% |

---

## EFS - Elastic File System

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `PercentIOLimit` | Porcentaje del límite de I/O alcanzado | > 80% | > 70% |
| `BurstCreditBalance` | Balance de créditos de burst | < 1GB | < 5GB |
| `ClientConnections` | Conexiones de clientes activas | > 1000 | > 500 |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `TotalIOBytes` | Total de bytes de I/O | Baseline + 400% | Baseline + 300% |
| `DataReadIOBytes` | Bytes leídos | Baseline + 400% | Baseline + 300% |
| `DataWriteIOBytes` | Bytes escritos | Baseline + 400% | Baseline + 300% |
| `MetadataIOBytes` | Bytes de operaciones de metadata | Baseline + 300% | Baseline + 200% |
| `PermittedThroughput` | Throughput permitido | Baseline + 300% | Baseline + 200% |
| `MeteredIOBytes` | Bytes medidos de I/O | Baseline + 300% | Baseline + 200% |

### 📊 Métricas de Capacidad
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `StorageBytes` | Tamaño del sistema de archivos | > 80% del límite | > 70% del límite |
| `TimeSinceLastSync` | Tiempo desde última sincronización | > 3600s | > 1800s |

---

## EBS - Elastic Block Store

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `VolumeQueueLength` | Longitud de cola de I/O | > 32 | > 16 |
| `VolumeThroughputPercentage` | Porcentaje de throughput utilizado | > 90% | > 80% |
| `VolumeConsumedReadWriteOps` | Operaciones consumidas | > 90% del límite | > 80% del límite |
| `BurstBalance` | Balance de créditos de burst | < 10% | < 20% |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `VolumeReadOps` | Operaciones de lectura | Baseline + 300% | Baseline + 200% |
| `VolumeWriteOps` | Operaciones de escritura | Baseline + 300% | Baseline + 200% |
| `VolumeReadBytes` | Bytes leídos | Baseline + 300% | Baseline + 200% |
| `VolumeWriteBytes` | Bytes escritos | Baseline + 300% | Baseline + 200% |
| `VolumeTotalReadTime` | Tiempo total de lectura | > 100ms | > 50ms |
| `VolumeTotalWriteTime` | Tiempo total de escritura | > 100ms | > 50ms |
| `VolumeIdleTime` | Tiempo inactivo | < 50% | < 70% |

---

## FSx

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `DataReadBytes` | Bytes leídos del sistema de archivos | Baseline + 400% | Baseline + 300% |
| `DataWriteBytes` | Bytes escritos al sistema de archivos | Baseline + 400% | Baseline + 300% |
| `MetadataOperations` | Operaciones de metadata | Baseline + 300% | Baseline + 200% |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `DataReadOperations` | Operaciones de lectura | Baseline + 300% | Baseline + 200% |
| `DataWriteOperations` | Operaciones de escritura | Baseline + 300% | Baseline + 200% |
| `TotalRequestTime` | Tiempo total de requests | > 100ms | > 50ms |

### 📊 Métricas de Capacidad
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `StorageCapacity` | Capacidad de almacenamiento utilizada | > 90% | > 80% |
| `StorageUtilization` | Utilización de almacenamiento | > 90% | > 80% |

---

## WAF - Web Application Firewall

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `BlockedRequests` | Requests bloqueados | > 50% de total | > 30% de total |
| `AllowedRequests` | Requests permitidos | Baseline + 500% | Baseline + 300% |
| `CountedRequests` | Requests contados | Baseline + 500% | Baseline + 300% |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `SampledRequests` | Requests muestreados | Baseline + 400% | Baseline + 300% |
| `CaptchaRequests` | Requests con CAPTCHA | Baseline + 300% | Baseline + 200% |
| `ChallengeRequests` | Requests con challenge | Baseline + 300% | Baseline + 200% |

---

## Redshift

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `HealthStatus` | Estado de salud del cluster | < 1 | N/A |
| `MaintenanceMode` | Modo de mantenimiento | > 0 | N/A |
| `DatabaseConnections` | Conexiones activas | > 80% del máximo | > 70% del máximo |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `CPUUtilization` | Utilización de CPU | > 90% | > 80% |
| `NetworkReceiveThroughput` | Throughput de red recibido | Baseline + 300% | Baseline + 200% |
| `NetworkTransmitThroughput` | Throughput de red transmitido | Baseline + 300% | Baseline + 200% |
| `ReadLatency` | Latencia de lectura | > 1000ms | > 500ms |
| `WriteLatency` | Latencia de escritura | > 1000ms | > 500ms |
| `ReadThroughput` | Throughput de lectura | Baseline + 300% | Baseline + 200% |
| `WriteThroughput` | Throughput de escritura | Baseline + 300% | Baseline + 200% |

### 📊 Métricas de Capacidad
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `PercentageDiskSpaceUsed` | Porcentaje de espacio en disco usado | > 90% | > 80% |
| `QueueLength` | Longitud de cola de queries | > 50 | > 25 |

---

## Glue

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `glue.driver.aggregate.numFailedTasks` | Tareas fallidas | > 5% del total | > 2% del total |
| `glue.driver.aggregate.numKilledTasks` | Tareas terminadas | > 0 | N/A |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `glue.driver.aggregate.elapsedTime` | Tiempo transcurrido del job | > 4 horas | > 2 horas |
| `glue.driver.aggregate.numCompletedTasks` | Tareas completadas | Baseline + 200% | Baseline + 100% |
| `glue.driver.jvm.heap.usage` | Uso de heap JVM | > 90% | > 80% |
| `glue.driver.jvm.heap.used` | Heap JVM usado | > 90% del máximo | > 80% del máximo |
| `glue.driver.s3.filesystem.read_bytes` | Bytes leídos de S3 | Baseline + 300% | Baseline + 200% |
| `glue.driver.s3.filesystem.write_bytes` | Bytes escritos a S3 | Baseline + 300% | Baseline + 200% |

### 📊 Métricas de Capacidad
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `glue.driver.aggregate.numActiveExecutors` | Ejecutores activos | < 50% del configurado | < 70% del configurado |
| `glue.driver.aggregate.numMaxNeededExecutors` | Máximo ejecutores necesarios | > 90% del límite | > 80% del límite |

---

## ElastiCache

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `CPUUtilization` | Utilización de CPU | > 90% | > 80% |
| `SwapUsage` | Uso de swap | > 50MB | > 25MB |
| `Evictions` | Elementos expulsados | > 100/min | > 50/min |
| `ReplicationLag` | Retraso de replicación | > 5s | > 2s |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `CacheHits` | Aciertos de caché | Baseline + 200% | Baseline + 100% |
| `CacheMisses` | Fallos de caché | Baseline + 300% | Baseline + 200% |
| `CacheHitRate` | Tasa de aciertos | < 80% | < 85% |
| `CurrConnections` | Conexiones actuales | > 80% del máximo | > 70% del máximo |
| `NetworkBytesIn` | Bytes de red entrantes | Baseline + 300% | Baseline + 200% |
| `NetworkBytesOut` | Bytes de red salientes | Baseline + 300% | Baseline + 200% |
| `GetTypeCmds` | Comandos GET | Baseline + 300% | Baseline + 200% |
| `SetTypeCmds` | Comandos SET | Baseline + 300% | Baseline + 200% |

### 📊 Métricas de Capacidad
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `DatabaseMemoryUsagePercentage` | Porcentaje de memoria usado | > 90% | > 80% |
| `CurrItems` | Ítems actuales en caché | > 80% del máximo | > 70% del máximo |
| `BytesUsedForCache` | Bytes usados para caché | > 90% del máximo | > 80% del máximo |
| `FreeableMemory` | Memoria libre | < 100MB | < 500MB |

---

## EKS - Elastic Kubernetes Service

> **⚠️ Nota Importante**: EKS no proporciona métricas nativas de CloudWatch. Las métricas listadas requieren configuración adicional de:
> - **Kubernetes Metrics Server** (métricas básicas)
> - **Prometheus** (métricas avanzadas del control plane)
> - **Container Insights** (métricas agregadas en CloudWatch)

### 🔴 Métricas Críticas del Cluster
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `cluster_failed_request_count` | Requests fallidos al API server | > 10/min | > 5/min |
| `apiserver_request_duration_seconds` | Latencia del API server | > 1s (p99) | > 500ms (p99) |

### 🟡 Métricas de Nodos
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `node_cpu_utilization` | Utilización CPU del nodo | > 90% | > 80% |
| `node_memory_utilization` | Utilización memoria del nodo | > 90% | > 80% |
| `node_filesystem_utilization` | Utilización filesystem del nodo | > 90% | > 80% |
| `node_network_total_bytes` | Tráfico de red total | Baseline + 300% | Baseline + 200% |

### 📊 Métricas de Pods
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `pod_cpu_utilization` | Utilización CPU del pod | > 90% del request | > 80% del request |
| `pod_memory_utilization` | Utilización memoria del pod | > 90% del request | > 80% del request |
| `pod_restart_count` | Reinicio de pods | > 5 en 1h | > 3 en 1h |

---

## ECS - Elastic Container Service

### 🔴 Métricas Críticas del Cluster
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `CPUUtilization` | Utilización CPU del cluster | > 90% | > 80% |
| `MemoryUtilization` | Utilización memoria del cluster | > 90% | > 80% |
| `ActiveServicesCount` | Servicios activos | Monitoreo | Monitoreo |

### 🟡 Métricas de Servicios
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `CPUUtilization` | Utilización CPU del servicio | > 90% | > 80% |
| `MemoryUtilization` | Utilización memoria del servicio | > 90% | > 80% |
| `RunningTaskCount` | Tasks en ejecución | < Desired count | Monitoreo |
| `PendingTaskCount` | Tasks pendientes | > 0 por > 5min | > 0 por > 2min |

### 📊 Métricas de Tasks
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `TaskCount` | Número total de tasks | Monitoreo | Monitoreo |
| `ServiceCount` | Número de servicios | Monitoreo | Monitoreo |

---

## Fargate

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `CPUUtilization` | Utilización CPU | > 90% | > 80% |
| `MemoryUtilization` | Utilización memoria | > 90% | > 80% |
| `RunningTaskCount` | Tasks ejecutándose | < Desired count | Monitoreo |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `PendingTaskCount` | Tasks pendientes | > 0 por > 5min | > 0 por > 2min |
| `ActiveServiceCount` | Servicios activos | Monitoreo | Monitoreo |
| `TaskSetCount` | Task sets | Monitoreo | Monitoreo |

---

## API Gateway

### 🔴 Métricas Críticas
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `4XXError` | Errores 4xx | > 5% de requests | > 2% de requests |
| `5XXError` | Errores 5xx | > 1% de requests | > 0.5% de requests |
| `IntegrationLatency` | Latencia de integración | > 29000ms | > 10000ms |
| `Latency` | Latencia total | > 29000ms | > 10000ms |

### 🟡 Métricas de Performance
| Métrica | Descripción | Umbral Crítico | Umbral Warning |
|---------|-------------|----------------|----------------|
| `Count` | Número total de requests | Baseline + 500% | Baseline + 300% |
| `CacheHitCount` | Aciertos de caché | Monitoreo | Monitoreo |
| `CacheMissCount` | Fallos de caché | Monitoreo | Monitoreo |

---

## Umbrales Recomendados

> **⚠️ Importante**: Los umbrales definidos en este documento son **línea base de referencia general**. Deben ser validados y ajustados según las particularidades de cada proyecto y carga de trabajo:
> - **Métricas de Cantidad** (requests, conexiones, objetos): Requieren validación específica basada en patrones de uso del proyecto
> - **Métricas de Porcentaje** (CPU, memoria, utilización): Pueden ajustarse según tolerancia al riesgo y SLAs específicos
> - **Baseline + X%**: Debe calcularse durante períodos de operación normal de cada ambiente

### 🎯 Niveles de Severidad

#### 🔴 **CRÍTICO**
- Impacto inmediato en la disponibilidad del servicio
- Requiere intervención inmediata (24/7)
- Escalamiento automático a on-call

#### 🟡 **WARNING**
- Degradación de performance
- Requiere investigación en horario laboral
- Notificación a equipo de operaciones

#### 🔵 **INFO**
- Métricas de tendencia y capacidad
- Revisión en reportes semanales
- Planificación de capacidad

### ⏱️ Períodos de Evaluación

| Tipo de Métrica | Período de Evaluación | Puntos de Datos |
|------------------|----------------------|-----------------|
| CPU/Memoria | 5 minutos | 2 de 3 |
| Latencia | 1 minuto | 3 de 5 |
| Errores | 1 minuto | 1 de 1 |
| Capacidad | 15 minutos | 1 de 1 |

---

## Alertas Críticas

### 🚨 Configuración de Alertas Prioritarias

1. **Disponibilidad del Servicio**
   - Status checks fallidos
   - Health checks fallidos
   - Errores 5xx > 1%

2. **Performance Crítica**
   - CPU > 90% por 5 minutos
   - Memoria > 90% por 5 minutos
   - Latencia > umbrales críticos

3. **Capacidad**
   - Espacio en disco < 2GB
   - Conexiones DB > 80% del máximo
   - Lambda throttling > 0

### 📧 Canales de Notificación

- **Crítico**: Sistema de alertas inmediatas + Chat + Email
- **Warning**: Chat + Email
- **Info**: Reportes periódicos

### 🔄 Escalamiento

1. **Nivel 1**: Equipo de operaciones (0-15 min)
2. **Nivel 2**: Lead técnico (15-30 min)
3. **Nivel 3**: Arquitecto de soluciones (30+ min)

---

## 📝 Notas de Implementación

### 🔧 Configuración Inicial
- Configurar todas las métricas en la plataforma de monitoreo elegida
- Crear dashboards para visualización de métricas
- Implementar Infrastructure as Code para alertas

### 📊 Personalización por Proyecto
- **Establecer baseline específico**: Medir métricas durante 2-4 semanas de operación normal
- **Validar umbrales de cantidad**: Ajustar según volumen esperado y patrones de crecimiento
- **Calibrar umbrales de porcentaje**: Considerar SLAs, tolerancia al riesgo y recursos disponibles
- **Documentar justificaciones**: Registrar razones para desviaciones de esta línea base de referencia

### 🔄 Mantenimiento Continuo
- Revisar y ajustar umbrales basado en patrones observados
- Documentar falsos positivos y ajustar umbrales accordingly
- Actualizar baseline tras cambios significativos en la arquitectura
- Validar umbrales después de escalamientos o migraciones

---

## 🔗 Recursos Relacionados

### Implementaciones
- 🏗️ **[Monitores Datadog-Terraform](./datadog-monitors/)**: Implementación completa de todos los monitores
- 📖 **[Guía de Implementación](./datadog-monitors/IMPLEMENTATION_GUIDE.md)**: Instrucciones detalladas paso a paso

### Documentación Técnica
- 📊 **[Métricas por Servicio](#índice)**: Definiciones completas en este documento
- ⚙️ **[Variables de Configuración](./datadog-monitors/variables.tf)**: Variables globales personalizables
- 🎯 **[Umbrales Recomendados](#umbrales-recomendados)**: Guía de configuración de alertas

---

## **Notas Especiales**:
- **EKS**: Requiere configuración adicional de herramientas de monitoreo
- **EBS**: Métricas disponibles solo cuando el volumen está adjunto a una instancia
- **FSx**: Métricas varían según el tipo de sistema de archivos (Lustre, Windows File Server, etc.)
- **Glue**: Métricas de jobs ETL requieren habilitación de CloudWatch metrics en la configuración del job
- **ElastiCache**: Métricas difieren entre Redis y Memcached
- **Redshift**: Algunas métricas requieren habilitar enhanced VPC routing