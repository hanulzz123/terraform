# Create RDS by MySQL

resource "aws_db_instance" "jypark_mydb" {
    allocated_storage    = var.database.storage
    engine               = var.database.eng
    engine_version       = var.database.eng_ver
    instance_class       = var.database.ins_class
    name                 = var.database.name
    identifier           = var.database.idtf
    username             = var.database.dbusr
    password             = var.database.dbpswd
    parameter_group_name = var.database.para
    vpc_security_group_ids = [aws_security_group.jypark_allow_db.id]
    # availability_zone    = aws_subnet.jypark_pri[0].id
    db_subnet_group_name = aws_db_subnet_group.jypark_dbgroup.id
    skip_final_snapshot  = true
    tags = {
        name = "${var.name}-mydb"
    }
  depends_on = [
        aws_db_subnet_group.jypark_dbgroup
    ]
}

# Create Subnet Group for RDS

resource "aws_db_subnet_group" "jypark_dbgroup"{
  name = "${var.name}_dbgroup"
  subnet_ids = [aws_subnet.jypark_pri[0].id,aws_subnet.jypark_pri[1].id]
  tags = {
    Name = "${var.name}-dbgroup"
  }
}