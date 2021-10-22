resource "aws_security_group" "jypark_allow_http" {
	name        = "allow_http"
	description = "Allow http inbound traffic"
	vpc_id      = aws_vpc.jypark_vpc.id

	ingress = [
		{
		description      = "HTTP from VPC"
		from_port        = var.port_num.http
		to_port          = var.port_num.http
		protocol         = var.protocol.tcp
		cidr_blocks      = [var.all_cidr4]        # this is source for AWS SG
		ipv6_cidr_blocks = [var.all_cidr6]
		prefix_list_ids  = null
		security_groups  = null
		self             = null
		},
		{
		description      = "SSH from VPC"
		from_port        = var.port_num.ssh
		to_port          = var.port_num.ssh
		protocol         = var.protocol.tcp
		cidr_blocks      = [aws_vpc.jypark_vpc.cidr_block]        # this is source for AWS SG
		ipv6_cidr_blocks = [var.all_cidr6]
		prefix_list_ids  = null
		security_groups  = null
		self             = null  
		}
	]

	egress = [
		{
		description      = "ALL Traffic form Outbound"
		from_port        = var.port_num.all
		to_port          = var.port_num.all
		protocol         = "-1"
		cidr_blocks      = [var.all_cidr4]
		ipv6_cidr_blocks = [var.all_cidr6]
		prefix_list_ids  = null
		security_groups  = null
		self             = null
		}
	]

	tags = {
		Name = "${var.name}-allow-web"
	}
}


resource "aws_security_group" "jypark_allow_db" {
	name        = "allow_db"
	description = "Allow DB inbound traffic"
	vpc_id      = aws_vpc.jypark_vpc.id

	ingress = [
		{
		description      = "MySQL from VPC"
		from_port        = var.port_num.sql
		to_port          = var.port_num.sql
		protocol         = var.protocol.tcp
		cidr_blocks      = null
		ipv6_cidr_blocks = null
		prefix_list_ids  = null
		security_groups  = [aws_security_group.jypark_allow_http.id]
		self             = null
		}
	]

	egress = [
		{
		description      = "ALL Traffic form Outbound"
		from_port        = var.port_num.all
		to_port          = var.port_num.all
		protocol         = "-1"
		cidr_blocks      = [var.all_cidr4]
		ipv6_cidr_blocks = [var.all_cidr6]
		prefix_list_ids  = null
		security_groups  = null
		self             = null
		}
	]

	tags = {
		Name = "${var.name}-allow-db"
	}
}