locals {
  provision_image_name  = "${basename(var.scalardl_image_name)}-provision"
  provision_image       = "${local.provision_image_name}:${var.scalardl_image_tag}"
  image_filename        = "${local.provision_image_name}-${var.scalardl_image_tag}.tar.gz"
  from_scalar_image     = "${var.scalardl_image_name}:${var.scalardl_image_tag}"
  scalar_cassandra_host = "cassandra-lb.${var.internal_root_dns}"
}

module "ansible" {
  source = "../../../provision/ansible"
}

resource "null_resource" "scalardl_image" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    scalar_tag = var.scalardl_image_tag
  }

  provisioner "local-exec" {
    command = "docker-compose build && docker save ${local.provision_image} | gzip -1 > ../${local.image_filename}'"

    working_dir = "${path.module}/provision"
    interpreter = ["/bin/bash", "-c"]

    environment = {
      SCALAR_IMAGE                 = local.provision_image
      FROM_SCALAR_IMAGE            = local.from_scalar_image
      SCALAR_CASSANDRA_HOST        = local.scalar_cassandra_host
      CASSANDRA_REPLICATION_FACTOR = var.replication_factor
    }
  }
}

resource "null_resource" "scalardl_image_push" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    docker_image = null_resource.scalardl_image[0].id
    triggers     = join(",", var.triggers)
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = true
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/${local.image_filename}"
    destination = "/tmp/${local.image_filename}"
  }
}

resource "null_resource" "scalardl_waitfor" {
  count = var.provision_count

  triggers = {
    triggers     = join(",", var.triggers)
    scalar_image = null_resource.scalardl_image_push[0].id
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["echo scalar server running"]
  }
}

resource "null_resource" "docker_install" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.scalardl_waitfor[count.index].id
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = true
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${module.ansible.remote_playbook_path}",
      "ansible-playbook -u ${var.user_name} -i ${var.host_list[count.index]}, docker-server.yml --extra-vars='enable_tdagent=${var.enable_tdagent ? 1 : 0}'",
    ]
  }
}

resource "null_resource" "scalardl_push" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.docker_install[count.index].id
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = true
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["rsync -e 'ssh -o StrictHostKeyChecking=no' -cvv /tmp/${local.image_filename} ${var.user_name}@${var.host_list[count.index]}:/tmp/"]
  }
}

resource "null_resource" "scalardl_load" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.scalardl_push[count.index].id
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/provision"
    destination = "$HOME"
  }

  provisioner "remote-exec" {
    inline = ["gzip -cd /tmp/${local.image_filename} | docker load"]
  }
}

resource "null_resource" "scalardl_schema" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    triggers = null_resource.scalardl_load[0].id
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cd $HOME/provision",
      "SCALAR_IMAGE=${local.provision_image} SCALAR_CASSANDRA_HOST=${local.scalar_cassandra_host} CASSANDRA_REPLICATION_FACTOR=${var.replication_factor} docker-compose run --rm scalar dockerize -template create_schema.cql.tmpl:create_schema.cql -wait tcp://${local.scalar_cassandra_host}:9042 -timeout 30s ./create_schema.sh",
    ]
  }
}

resource "null_resource" "scalardl_container" {
  count = var.provision_count

  triggers = {
    triggers = "${null_resource.scalardl_load[count.index].id}${null_resource.scalardl_schema[0].id}"
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cd $HOME/provision",
      "echo export SCALAR_IMAGE=${local.provision_image} > env",
      "echo export FROM_SCALAR_IMAGE=${local.from_scalar_image} >> env",
      "echo export SCALAR_CASSANDRA_HOST=${local.scalar_cassandra_host} >> env",
      "echo export CASSANDRA_REPLICATION_FACTOR=${var.replication_factor} >> env",
      "source ./env",
      "docker-compose up -d",
    ]
  }
}
