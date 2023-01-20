output "vpc_ids" {
  value       = aws_vpc.this.*.id
  description = "IDs of VPCs"
}
