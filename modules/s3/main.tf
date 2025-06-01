# S3
resource "aws_s3_bucket" "app_source_bucket" {
  bucket = "nexacloud-source-bundle-bucket-123156157187458"
}
# Puedes usar un "null_resource" o un script local para subir el ZIP
# O, si tienes un pipeline CI/CD, este paso se encargaría de subir el archivo
resource "aws_s3_object" "app_source_bundle" {
  bucket = aws_s3_bucket.app_source_bucket.id
  key    = "files.zip"   # Reemplaza con el nombre de tu archivo ZIP
  source = var.objects_path # Asegúrate de que este archivo exista localmente
  etag   = filemd5(var.objects_path)
}