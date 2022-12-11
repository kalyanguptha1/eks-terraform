# EKS Cluster Resources

provider "aws" {
      region     = "us-east-1"
      access_key = ""
      secret_key = ""
}

resource "aws_security_group" "bastion_stage" {
  name        = "bastion_stage"
  description = "Bastion for EKS"
  vpc_id      = "vpc-0ec7c267c437b4596"

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastion_stage"
  }
}

resource "aws_instance" "bastion-server-stage" {
  vpc_security_group_ids = [aws_security_group.bastion_stage.id]
  subnet_id             = "subnet-0b4ed529243043855"
  ami                   = var.AMI
  instance_type = var.INSTANCE_TYPE
  key_name = "dev_user_new"
  root_block_device {
  volume_type = "gp2"
  volume_size = var.VOLUME_SIZE
  delete_on_termination = "true"
  
}

provisioner "file" {

    source      = "../eks"
    destination = "/home/ubuntu/eks"

    connection {   
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/mnt/c/Users/nrish/Downloads/ec2-test.pem")
    }   

  }

provisioner "remote-exec" {
  connection {   
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/mnt/c/Users/nrish/Downloads/ec2-test.pem")
    }   


    inline = [
    "chmod +x  ~/Downloads/terraform-kalyan/eks/install_terraform.sh",
    "/bin/bash  ~/Downloads/terraform-kalyan/eks/install_terraform.sh",
    ]
  }

tags = {
           Name = var.VM_NAME
          
        }
}

resource "aws_eip" "stage-ip" {
  instance = aws_instance.bastion-server-stage.id
  vpc      = "true"
}

resource "aws_eks_cluster" "eks-test" {
  name = var.cluster-name

  version = var.k8s-version

  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    security_group_ids = [var.security_group]
    subnet_ids         = ["subnet-054b60432a87f1a72", "subnet-0b4ed529243043855"]
    endpoint_private_access = true
    endpoint_public_access = false
  }

 
  depends_on = [
    aws_instance.bastion-server-stage,
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = var.cluster-name
  node_group_name = "${var.cluster-name}-default-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = ["subnet-054b60432a87f1a72", "subnet-0b4ed529243043855"]
  scaling_config {
    desired_size = var.desired-capacity
    max_size     = var.max-size
    min_size     = var.min-size
  }
  instance_types = [
    var.node-instance-type
  ]
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_eks_cluster.eks-test,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy
  ]
  tags = {
    Name = "${var.cluster-name}-default-node-group"
  }
}

output "endpoint" {
  value = aws_eks_cluster.eks-test.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks-test.certificate_authority[0]
}
