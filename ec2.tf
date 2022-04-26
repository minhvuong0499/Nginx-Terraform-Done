resource "aws_instance" "nginx_server" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"
  key_name      = "Access-EC2"
  tags = {
    Name = "nginx_server"
  }
  # VPC
  subnet_id = data.aws_subnet.nginx_server.id
  # Security Group
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  # the Public SSH key
  #key_name = aws_key_pair.aws-key.id
  # nginx installation
  # storing the nginx.sh file in the EC2 instnace
  provisioner "file" {
    source      = "/home/ubut/terraform/task3/nginx.sh"
    destination = "/tmp/nginx.sh"
  }
  # Exicuting the nginx.sh file
  # Terraform does not reccomend this method becuase Terraform state file cannot track what the scrip is provissioning
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
    ]
  }
  # Setting up the ssh connection to install the nginx server
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/home/ubut/terraform/keys/Access-EC2.pem")
  }
}