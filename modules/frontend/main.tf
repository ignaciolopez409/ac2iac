resource "aws_instance" "ac2iac_ec2_front_instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  security_groups = var.security_groups
  key_name = var.key_name
  tags = {
    Name = "AC2IAC EC2 frontend instance"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y polkit",
      "sudo amazon-linux-extras enable httpd_modules",
      "sudo yum install -y httpd",
      "sudo systemctl enable httpd",
      "sudo chmod 777 /var/www/html",
      "sudo echo \"<h1>EC2 Frontend Instance</h1>\" | tee -a /var/www/html/index.html",
      "sudo systemctl restart httpd",
      "sudo yum install -y telnet"
    ]
    connection {
      type = "ssh"
      user = "ec2-user"
      host = aws_instance.ac2iac_ec2_front_instance.public_ip
      private_key = file("~/.ssh/id_rsa")
    }
  }
}