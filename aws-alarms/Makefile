.PHONY: help setup deploy delete test list validate clean

# Variables
CONFIG_FILE ?= config/config.env

help: ## Mostrar ayuda
	@echo "AWS CloudWatch Alarms - Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Configuración inicial del proyecto
	@echo "🚀 Configurando proyecto AWS CloudWatch Alarms..."
	@if [ ! -f $(CONFIG_FILE) ]; then \
		echo "📝 Copiando config.env.example a config.env"; \
		cp config/config.env.example $(CONFIG_FILE); \
		echo "⚠️  IMPORTANTE: Edita $(CONFIG_FILE) con tus valores específicos"; \
	fi
	@echo "✅ Configuración inicial completada"
	@echo ""
	@echo "Próximos pasos:"
	@echo "  1. Editar $(CONFIG_FILE) con tus configuraciones"
	@echo "  2. Crear SNS topics si no existen"
	@echo "  3. Ejecutar 'make deploy' para desplegar alarmas"

validate: ## Validar configuración y AWS CLI
	@echo "🔍 Validando configuración..."
	@./utils/common-functions.sh check_aws_cli || echo "Ejecutando validación..."
	@if [ ! -f $(CONFIG_FILE) ]; then \
		echo "❌ Archivo de configuración no encontrado: $(CONFIG_FILE)"; \
		echo "   Ejecuta 'make setup' primero"; \
		exit 1; \
	fi
	@echo "✅ Validación completada"

validate-alarms: ## Validar estado de las alarmas desplegadas
	@echo "🔍 Validando estado de alarmas..."
	@./utils/validate-alarms.sh

deploy: validate ## Desplegar todas las alarmas CloudWatch
	@echo "🚀 Desplegando todas las alarmas CloudWatch..."
	@./deploy-all.sh

delete: validate ## Eliminar todas las alarmas CloudWatch
	@echo "🗑️  Eliminando todas las alarmas CloudWatch..."
	@./delete-all-alarms.sh

test: validate ## Probar notificaciones SNS
	@echo "🧪 Probando notificaciones SNS..."
	@./utils/test-notifications.sh

list: validate ## Listar alarmas existentes
	@echo "📋 Listando alarmas existentes..."
	@source $(CONFIG_FILE) && aws cloudwatch describe-alarms --alarm-name-prefix "$$ALARM_PREFIX" --query 'MetricAlarms[*].[AlarmName,StateValue,StateReason]' --output table

status: validate ## Mostrar estado de las alarmas
	@echo "📊 Estado de las alarmas:"
	@source $(CONFIG_FILE) && aws cloudwatch describe-alarms --alarm-name-prefix "$$ALARM_PREFIX" --state-value ALARM --query 'MetricAlarms[*].[AlarmName,StateValue,StateReason]' --output table

clean: ## Limpiar archivos temporales
	@echo "🧹 Limpiando archivos temporales..."
	@find . -name "*.log" -delete
	@find . -name "*.tmp" -delete
	@echo "✅ Limpieza completada"

# Servicios individuales
deploy-ec2: validate ## Desplegar solo alarmas EC2
	@./scripts/ec2/deploy-ec2-alarms.sh

deploy-rds: validate ## Desplegar solo alarmas RDS
	@./scripts/rds/deploy-rds-alarms.sh

deploy-lambda: validate ## Desplegar solo alarmas Lambda
	@./scripts/lambda/deploy-lambda-alarms.sh

deploy-s3: validate ## Desplegar solo alarmas S3
	@./scripts/s3/deploy-s3-alarms.sh

deploy-dynamodb: validate ## Desplegar solo alarmas DynamoDB
	@./scripts/dynamodb/deploy-dynamodb-alarms.sh

# Utilidades
create-sns-topics: validate ## Crear SNS topics básicos
	@echo "📢 Creando SNS topics..."
	@source $(CONFIG_FILE) && \
	aws sns create-topic --name "$${PROJECT_NAME}-$${ENVIRONMENT}-critical-alerts" && \
	aws sns create-topic --name "$${PROJECT_NAME}-$${ENVIRONMENT}-warning-alerts" && \
	aws sns create-topic --name "$${PROJECT_NAME}-$${ENVIRONMENT}-info-alerts"
	@echo "✅ SNS topics creados"
	@echo "⚠️  Actualiza las ARNs en $(CONFIG_FILE)"

subscribe-email: validate ## Suscribir email a SNS topics (uso: make subscribe-email EMAIL=admin@company.com)
	@if [ -z "$(EMAIL)" ]; then \
		echo "❌ Especifica EMAIL: make subscribe-email EMAIL=admin@company.com"; \
		exit 1; \
	fi
	@echo "📧 Suscribiendo $(EMAIL) a SNS topics..."
	@source $(CONFIG_FILE) && \
	aws sns subscribe --topic-arn "$$SNS_TOPIC_CRITICAL" --protocol email --notification-endpoint "$(EMAIL)" && \
	aws sns subscribe --topic-arn "$$SNS_TOPIC_WARNING" --protocol email --notification-endpoint "$(EMAIL)"
	@echo "✅ Suscripción completada"
	@echo "📬 Revisa tu email y confirma las suscripciones"

# Información
info: ## Mostrar información del proyecto
	@echo "📋 Información del Proyecto AWS CloudWatch Alarms"
	@echo "=================================================="
	@if [ -f $(CONFIG_FILE) ]; then \
		source $(CONFIG_FILE) && \
		echo "Proyecto: $$PROJECT_NAME"; \
		echo "Ambiente: $$ENVIRONMENT"; \
		echo "Región: $$AWS_REGION"; \
		echo "Prefijo de alarmas: $$ALARM_PREFIX"; \
		echo "SNS Crítico: $$SNS_TOPIC_CRITICAL"; \
		echo "SNS Warning: $$SNS_TOPIC_WARNING"; \
	else \
		echo "⚠️  Configuración no encontrada. Ejecuta 'make setup'"; \
	fi

# Monitoreo
monitor: validate ## Monitorear alarmas en tiempo real
	@echo "👀 Monitoreando alarmas en tiempo real (Ctrl+C para salir)..."
	@source $(CONFIG_FILE) && \
	watch -n 30 "aws cloudwatch describe-alarms --alarm-name-prefix \"$$ALARM_PREFIX\" --query 'MetricAlarms[*].[AlarmName,StateValue,StateUpdatedTimestamp]' --output table"