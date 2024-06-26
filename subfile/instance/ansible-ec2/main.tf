

resource "aws_instance" "ansible_instance" {
  count                  = length(var.subnets_id)
  ami                    = var.image_id                # 사용할 AMI ID를 지정합니다.
  instance_type          = var.instance_type           # 인스턴스 유형을 지정합니다. 필요에 따라 변경하세요.
  subnet_id              = var.subnets_id[count.index] # 위에서 생성한 서브넷의 ID를 사용합니다.
  vpc_security_group_ids = toset([var.pri_sub_sg[count.index]])
  key_name               = "moonkey"
  user_data              = <<-EOF
  #!/bin/bash
  sudo amazon-linux-extras install epel -y 
  sudo amazon-linux-extras enable ansible2
  sudo yum install -y ansible
  EOF

}

# resource "aws_instance" "node_instance" {
#   for {

#   }
#   ami           = var.image_id      # 사용할 AMI ID를 지정합니다.
#   instance_type = var.instance_type # 인스턴스 유형을 지정합니다. 필요에 따라 변경하세요.
#   subnet_id     = var.subnet_id     # 위에서 생성한 서브넷의 ID를 사용합니다.
# }

resource "aws_instance" "node_instance" {
  count         = length(var.subnets_id) * 3 # 총 인스턴스 수를 계산합니다.
  ami           = var.image_id               # 사용할 AMI ID를 지정합니다.
  instance_type = var.instance_type          # 인스턴스 유형을 지정합니다. 필요에 따라 변경하세요.
  subnet_id     = element(var.subnets_id, floor(count.index / 3))
  key_name      = "moonkey"
}
