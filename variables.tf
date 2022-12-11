# Variables Configuration

variable "cluster-name" {
  default     = "update-cluster-name"
  type        = string
  description = "The name of your EKS Cluster"
}

variable "aws-region" {
  default     = "update-region"
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "availability-zones" {
  default     = ["update-availability-zone"]
  type        = list
  description = "The AWS AZ to deploy EKS"
}

variable "k8s-version" {
  default     = "1.23"
  type        = string
  description = "Required K8s version"
}

variable "node-instance-type" {
  default     = "update-instance-type-for-worker-node"
  type        = string
  description = "Worker Node EC2 instance type"
}

variable "root-block-size" {
  default     = "20"
  type        = string
  description = "Size of the root EBS block device"

}

variable "subnet_id_pub1" {
  default     = "update-subnet-it"
  type        = string
  description = "Size of the root EBS block device"

}
variable "subnet_id_pub2" {
  default     = ["update-subnet-it"]
  type        = list(string)
  description = "Size of the root EBS block device"

}


variable "security_group" {
  default     = "update-security-group"
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
  default  = "update-instance-type"
  type      = string
}
variable "VM_NAME" {
  default  = "update-instance-name"
  type  = string
}

variable "AMI" {
  default  = "update-ami-id"
  type      = string
}

variable "VOLUME_SIZE" {
  default  = "8"
  type      = string
}
