# Deploy do Stack de Treinamento Distribuído de Machine Learning com PySpark no Amazon EMR
# Configuração dos recursos IAM

# IAM role para EMR Service
resource "aws_iam_role" "iam_emr_service_role" {

  name = "iam_emr_service_role"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
  ]

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticmapreduce.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM Role para EC2 Instance Profile
resource "aws_iam_role" "iam_emr_profile_role" {
  
  name = "iam_emr_profile_role"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
  ]

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM Role Policy para acesso ao S3
resource "aws_iam_role_policy" "emr_s3_access" {
  name = "emr_s3_access"
  role = aws_iam_role.iam_emr_profile_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::plz-st-914156456046",
          "arn:aws:s3:::plz-st-914156456046/*"
        ]
      }
    ]
  })
}

# Profile
resource "aws_iam_instance_profile" "emr_profile" {
  name = "emr_profile"
  role = aws_iam_role.iam_emr_profile_role.name
}
