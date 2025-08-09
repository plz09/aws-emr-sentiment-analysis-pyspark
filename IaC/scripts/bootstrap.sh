# Deploy do Stack de Treinamento Distribuído de Machine Learning com PySpark no Amazon EMR
# Script de Preparação do Ambiente Python

# Deploy do Stack de Treinamento Distribuído de Machine Learning com PySpark no Amazon EMR
# Script de Preparação do Ambiente Python

# Instala os pacotes necessários globalmente
sudo pip3 install --upgrade pip
sudo pip3 install findspark pendulum boto3 numpy python-dotenv scikit-learn

# Cria as pastas
mkdir $HOME/pipeline
mkdir $HOME/logs

