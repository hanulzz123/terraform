# Provider AWS

provider "aws" {
  region = var.region
}

# Declare VPC

resource "aws_vpc" "jypark_vpc" {
    cidr_block    = var.vpc_cidr
    instance_tenancy = "default"
    tags = {
        Name = "${var.name}-VPC"
    }
}

# Subnet in VPC

resource "aws_subnet" "jypark_pub" {
    vpc_id              = aws_vpc.jypark_vpc.id
    count               = "${length(var.pub_sub)}"       # count 2
    cidr_block          = "${var.pub_sub[count.index]}"
    availability_zone   = "${var.region}${var.zones[count.index]}"

    tags = {
        Name            = "public-${var.zones[count.index]}"
    }
}

resource "aws_subnet" "jypark_pri" {
    vpc_id              = aws_vpc.jypark_vpc.id
    count               = "${length(var.pri_sub)}"       # count 2
    cidr_block          = "${var.pri_sub[count.index]}"
    availability_zone   = "${var.region}${var.zones[count.index]}"

    tags = {
        Name            = "private-${var.zones[count.index]}"
    }
}