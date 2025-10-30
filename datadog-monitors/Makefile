.PHONY: help init plan apply destroy validate fmt check clean

# Variables
TF_VAR_FILE ?= terraform.tfvars

help: ## Mostrar ayuda
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Inicializar Terraform
	terraform init

validate: ## Validar configuración de Terraform
	terraform validate

fmt: ## Formatear archivos de Terraform
	terraform fmt -recursive

plan: ## Crear plan de ejecución
	terraform plan -var-file=$(TF_VAR_FILE)

apply: ## Aplicar cambios
	terraform apply -var-file=$(TF_VAR_FILE)

destroy: ## Destruir infraestructura
	terraform destroy -var-file=$(TF_VAR_FILE)

check: validate fmt ## Ejecutar validaciones y formato

clean: ## Limpiar archivos temporales
	rm -rf .terraform/
	rm -f .terraform.lock.hcl
	rm -f *.tfplan
	rm -f *.tfstate.backup

setup: ## Configuración inicial del proyecto
	@echo "🚀 Configurando proyecto de monitores Datadog..."
	@if [ ! -f terraform.tfvars ]; then \
		echo "📝 Copiando terraform.tfvars.example a terraform.tfvars"; \
		cp terraform.tfvars.example terraform.tfvars; \
		echo "⚠️  IMPORTANTE: Edita terraform.tfvars con tus valores específicos"; \
	fi
	@echo "✅ Configuración inicial completada"

deploy: check plan apply ## Pipeline completo: validar, planificar y aplicar

status: ## Mostrar estado actual de los recursos
	terraform show

output: ## Mostrar outputs de Terraform
	terraform output

refresh: ## Refrescar estado de Terraform
	terraform refresh -var-file=$(TF_VAR_FILE)

import: ## Importar recurso existente (uso: make import RESOURCE=datadog_monitor.example ID=12345)
	terraform import $(RESOURCE) $(ID)

workspace-list: ## Listar workspaces de Terraform
	terraform workspace list

workspace-new: ## Crear nuevo workspace (uso: make workspace-new NAME=staging)
	terraform workspace new $(NAME)

workspace-select: ## Seleccionar workspace (uso: make workspace-select NAME=staging)
	terraform workspace select $(NAME)