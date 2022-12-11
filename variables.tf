# Variables Configuration

variable "cluster-name" {
  default     = "eks-test"
  type        = string
  description = "The name of your EKS Cluster"
}

variable "aws-region" {
  default     = "us-west-2"
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "availability-zones" {
  default     = ["us-west-2d"]
  type        = list
  description = "The AWS AZ to deploy EKS"
}

variable "k8s-version" {
  default     = "1.23"
  type        = string
  description = "Required K8s version"
}

variable "node-instance-type" {
  default     = "t2.small"
  type        = string
  description = "Worker Node EC2 instance type"
}

variable "root-block-size" {
  default     = "20"
  type        = string
  description = "Size of the root EBS block device"

}

variable "subnet_id_pub1" {
  default     = "subnet-0b4ed529243043855"
  type        = string
  description = "Size of the root EBS block device"

}
variable "subnet_id_pub2" {
  default     = ["subnet-054b60432a87f1a72"]
  type        = list(string)
  description = "Size of the root EBS block device"

}


variable "security_group" {
  default     = "sg-0da0c32ba9a456eca"
  type        = string
  description = "Size of the root EBS block device"

}

variable "desired-capacity" {
  default     = 1
  type        = string
  description = "Autoscaling Desired node capacity"
}

variable "max-size" {
  default     = 2
  type        = string
  description = "Autoscaling maximum node capacity"
}

variable "min-size" {
  default     = 1
  type        = string
  description = "Autoscaling Minimum node capacity"
}

variable "INSTANCE_TYPE" {
  default  = "t2.small"
  type      = string
}
variable "VM_NAME" {
  default  = "rds-bastion-server-stage"
  type  = string
}

variable "AMI" {
  default  = "ami-094125af156557ca2"
  type      = string
}

variable "VOLUME_SIZE" {
  default  = "8"
  type      = string
}
