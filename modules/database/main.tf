resource "aws_instance" "ac2iac_ec2_db_instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  security_groups = var.security_groups
  key_name = var.key_name
  tags = {
    Name = "AC2IAC EC2 database instance"
  }
  provisioner "file" {
    source = "files/mongo/mongodb-org-4.2.repo"
    destination = "/tmp/mongodb-org-4.2.repo"
  }
  provisioner "file" {
    source = "files/mongo/mongod.conf"
    destination = "/tmp/mongod.conf"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    host = aws_instance.ac2iac_ec2_db_instance.public_ip
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y polkit",
      "sudo amazon-linux-extras enable httpd_modules",
      "sudo yum install -y httpd",
      "sudo systemctl enable httpd",
      "sudo chmod 777 /var/www/html",
      "sudo echo \"<h1>EC2 Database Instance</h1>\" | tee -a /var/www/html/index.html",
      "sudo systemctl restart httpd",
      "sudo chmod 777 /etc/yum.repos.d",
      "sudo cp /tmp/mongodb-org-4.2.repo /etc/yum.repos.d/",
      "sudo yum install -y mongodb-org",
      "sudo cp -rf /tmp/mongod.conf /etc/mongod.conf",
      "sudo systemctl restart mongod",
      "sudo systemctl enable mongod",
      "sudo yum install -y telnet",
      "sudo rm -rf /tmp/mongod.conf /tmp/mongodb-org-4.2.repo"
    ]
    connection {
      type = "ssh"
      user = "ec2-user"
      host = aws_instance.ac2iac_ec2_db_instance.public_ip
      private_key = file("~/.ssh/id_rsa")
    }
  }
}