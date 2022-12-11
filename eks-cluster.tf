# EKS Cluster Resources

provider "aws" {
      region     = "us-east-1"
      access_key = ""
      secret_key = ""
}

resource "aws_security_group" "" {
  name        = ""
  description = ""
  vpc_id      = ""

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
    Name = ""
  }
}

resource "aws_instance" "" {
  vpc_security_group_ids = [aws_security_group.(update your security_group name)]
  subnet_id             = ""
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
      private_key = file("update your pem key file path with file name")
    }   

  }

provisioner "remote-exec" {
  connection {   
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("update your pem key file path with file name")
    }   


    inline = [
    "chmod +x  ~/Downloads/eks-terraform/eks/install_terraform.sh",
    "/bin/bash  ~/Downloads/eks-terraform/eks/install_terraform.sh",
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

resource "aws_eks_cluster" "update_name_of _the_cluster" {
  name = var.cluster-name

  version = var.k8s-version

  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    security_group_ids = [var.security_group]
    subnet_ids         = ["", ""]
    endpoint_private_access = true
    endpoint_public_access = false
  }

 
  depends_on = [
    aws_instance.(update your instance name),
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = var.cluster-name
  node_group_name = "${var.cluster-name}-default-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = ["", ""]
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
  value = aws_eks_cluster.(cluster_name).endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.(cluster_name).certificate_authority[0]
}
