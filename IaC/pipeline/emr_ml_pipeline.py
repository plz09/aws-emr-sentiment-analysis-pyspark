# Deploy do Stack de Treinamento Distribuído de Machine Learning com PySpark no Amazon EMR
# Script Principal

# Imports
import os
import boto3
import traceback
import pyspark 
from pyspark.sql import SparkSession
from IaC.pipeline.st_log import plz_grava_log
from IaC.pipeline.st_processamento import plz_limpa_transforma_dados
from IaC.pipeline.st_ml import plz_cria_modelos_ml


# Nome do Bucket
NOME_BUCKET = "plz-st-914156456046"

print("\nLog plz - Inicializando o Processamento.")

# Cria um recurso de acesso ao S3 via código Python
s3_resource = boto3.resource('s3')

# Define o objeto de acesso ao bucket via Python
bucket = s3_resource.Bucket(NOME_BUCKET)

# Grava o log
plz_grava_log("Log plz - Bucket Encontrado.", bucket)

# Grava o log
plz_grava_log("Log plz - Inicializando o Apache Spark.", bucket)

# Cria a Spark Session e grava o log no caso de erro
try:
	spark = SparkSession.builder.appName("PLZ_ST").getOrCreate()
	spark.sparkContext.setLogLevel("ERROR")
except:
	plz_grava_log("Log plz - Ocorreu uma falha na Inicialização do Spark", bucket)
	plz_grava_log(traceback.format_exc(), bucket)
	raise Exception(traceback.format_exc())

# Grava o log
plz_grava_log("Log plz - Spark Inicializado.", bucket)

# Define o ambiente de execução do Amazon EMR
ambiente_execucao_EMR = False if os.path.isdir('dados/') else True

# Bloco de limpeza e transformação
try:
	DadosHTFfeaturized, DadosTFIDFfeaturized, DadosW2Vfeaturized = plz_limpa_transforma_dados(spark, 
																							  bucket, 
																							  NOME_BUCKET, 
																							  ambiente_execucao_EMR)
except:
	plz_grava_log("Log plz - Ocorreu uma falha na limpeza e transformação dos dados", bucket)
	plz_grava_log(traceback.format_exc(), bucket)
	spark.stop()
	raise Exception(traceback.format_exc())

# Bloco de criação dos modelos de Machine Learning
try:
	plz_cria_modelos_ml (spark, 
					     DadosHTFfeaturized, 
					     DadosTFIDFfeaturized, 
					     DadosW2Vfeaturized, 
					     bucket, 
					     NOME_BUCKET, 
					     ambiente_execucao_EMR)
except:
	plz_grava_log("Log plz - Ocorreu Alguma Falha ao Criar os Modelos de Machine Learning", bucket)
	plz_grava_log(traceback.format_exc(), bucket)
	spark.stop()
	raise Exception(traceback.format_exc())

# Grava o log
plz_grava_log("Log plz - Modelos Criados e Salvos no S3.", bucket)

# Grava o log
plz_grava_log("Log plz - Processamento Finalizado com Sucesso.", bucket)

# Finaliza o Spark (encerra o cluster EMR)
spark.stop()



