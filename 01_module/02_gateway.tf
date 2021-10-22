# Intetnet Gateway

resource "aws_internet_gateway" "jypark_igw" {
	vpc_id                = aws_vpc.jypark_vpc.id

	tags = {
    	Name              = "${var.name}-igw"
  }
}

# Internet Route Table

resource "aws_route_table" "jypark_pubrt" {
	vpc_id                = aws_vpc.jypark_vpc.id

	route {
		cidr_block        = var.all_cidr4
		gateway_id        = aws_internet_gateway.jypark_igw.id 
	}

	tags = {
		Name              = "${var.name}-pubrt"
	}
}

resource "aws_route_table_association" "jypark_pub_ass" {
	count                 = "${length(var.zones)}"       # count 2
	subnet_id             = aws_subnet.jypark_pub[count.index].id
	route_table_id        = aws_route_table.jypark_pubrt.id
}

# NAT Gateway

resource "aws_eip" "jypark_eip_pri" {
	count                 = "${length(var.pri_sub)}"       # count 2
	vpc                   = true

	tags = {
		Name              = "${var.name}-eip-pri${var.zones[count.index]}"
  	}
}

resource "aws_nat_gateway" "jypark_nat" {
	count                 = "${length(var.pri_sub)}"
	allocation_id = aws_eip.jypark_eip_pri[count.index].id
	subnet_id     = aws_subnet.jypark_pub[count.index].id

	tags = {
		Name = "${var.name}-nat-pri${var.zones[count.index]}"
	}
}

# NAT Route Table

resource "aws_route_table" "jypark_natrt" {
	count                 = "${length(var.pri_sub)}"
	vpc_id                = aws_vpc.jypark_vpc.id

	route {
		cidr_block        = var.all_cidr4
		gateway_id        = aws_nat_gateway.jypark_nat[count.index].id 
	}

	tags = {
		Name              = "${var.name}-natrt"
	}
}

resource "aws_route_table_association" "jypark_pri_ass" {
	count                 = "${length(var.zones)}"
	subnet_id             = aws_subnet.jypark_pri[count.index].id
	route_table_id        = aws_route_table.jypark_natrt[count.index].id
}