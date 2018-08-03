resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "rg-tf-wow-vanilla-server"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "rg-tf-wow-vanilla-server"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }

  tags {
    Name = "rg-tf-wow-vanilla-server"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}

resource "aws_subnet" "subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "rg-tf-wow-vanilla-server"
  }

  depends_on = ["aws_internet_gateway.gateway"]
}

resource "aws_eip" "elastic_ip" {
  vpc = true

  instance                  = "${module.server.id}"
  associate_with_private_ip = "${var.private_ip}"

  tags {
    Name = "rg-tf-wow-vanilla-server"
  }

  depends_on = ["aws_internet_gateway.gateway"]
}
