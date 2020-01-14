output "image_id" {
  value       = data.aws_ami.image.image_id
  description = "An AMI id for the given region."
}
