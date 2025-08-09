# Deploy do Stack de Treinamento Distribuído de Machine Learning com PySpark no Amazon EMR
# Script de Preparação do Ambiente Python

#!/bin/bash
set -euxo pipefail

# Instala pacotes sem atualizar o pip do sistema
sudo python3 -m pip install findspark pendulum boto3 numpy python-dotenv scikit-learn

# Cria diretórios
mkdir -p /home/hadoop/pipeline
mkdir -p /home/hadoop/logs

# Adiciona pipeline ao PYTHONPATH
echo 'export PYTHONPATH=$PYTHONPATH:/home/hadoop/pipeline' >> /home/hadoop/.bashrc


