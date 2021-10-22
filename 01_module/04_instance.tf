resource "aws_instance" "jypark_web" {
	ami                         = var.ami_type
	instance_type               = var.ins_type
	key_name                    = "tf key"        
	private_ip                  = var.pri_ip
	vpc_security_group_ids      = [aws_security_group.jypark_allow_http.id]
	availability_zone           = "${var.region}${var.zones[0]}"
	subnet_id                   = aws_subnet.jypark_pub[0].id
	associate_public_ip_address = true
	user_data = var.usrdata

	tags = {
		Name = "${var.name}-web-${var.zones[0]}"
	}
}

# Create a key for accessing an instance

resource "aws_key_pair" "tf_key" {
    key_name = var.keyname
    public_key = var.keypath
}