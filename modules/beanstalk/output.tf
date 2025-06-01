output "URL_beanstalk" {
  description = "URL de la aplicación Elastic Beanstalk"
  value       = aws_elastic_beanstalk_environment.beanstalk_env.endpoint_url
}
