resource "aws_instance" "example" {
  ami           = "ami-0adfdaea54d40922b"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}