##################
# Security groups
##################
resource "aws_security_group" "ssh" {
  name        = "${var.ssh_security_group_name}"
  description = "Default security group with ssh access for any ip-address"
  vpc_id      = "${aws_vpc.default.id}"

  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "outbound" {
  name        = "${var.outbound_security_group_name}"
  description = "Default security group for outbound tcp traffic"
  vpc_id      = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wow_vanilla" {
  name        = "${var.wow_vanilla_security_group_name}"
  description = "Allow incoming traffic to realmd and mangosd"
  vpc_id      = "${aws_vpc.default.id}"

  # Allow inbound for mangosd
  ingress {
    from_port   = 8085
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound for realmd
  ingress {
    from_port   = 3724
    to_port     = 3724
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
