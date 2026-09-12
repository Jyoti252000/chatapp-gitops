variable "aws_region" {
    description = "AWS region to deploy into"
    type = string
    default = "eu-west-1"
}

variable "cluster_name" {
    description = "Name of the EKS Cluster"
    type = string
    default = "chatapp-cluster"
}

variable "vpc_cidr" {
    description = "CIDR block for VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "environment" {
    description = "Environment tag applied to all resource"
    type = string
    default = "portfolio"
} 