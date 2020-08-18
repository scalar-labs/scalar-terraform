locals {
  scalar_image          = "${var.scalardl_image_name}:${var.scalardl_image_tag}"
  image_filename        = "${basename(var.scalardl_image_name)}-${var.scalardl_image_tag}.tar.gz"
  scalar_cassandra_host = "cassandra-lb.${var.internal_domain}"

  schema_loader_cassandra_image          = "${var.schema_loader_cassandra_image_name}:${var.schema_loader_cassandra_image_tag}"
  schema_loader_cassandra_image_filename = "${basename(var.schema_loader_cassandra_image_name)}-${var.schema_loader_cassandra_image_tag}.tar.gz"
}

module "ansible" {
  source = "../../../provision/ansible"
}

resource "null_resource" "scalardl_image" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    scalar_tag = var.scalardl_image_tag
    triggers   = join(",", var.triggers)
  }

  provisioner "local-exec" {
    command = "docker pull ${local.scalar_image} && docker save ${local.scalar_image} | gzip -1 > ${local.image_filename}"
    working_dir = path.module
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "scalardl_image_push" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    docker_image = null_resource.scalardl_image[0].id
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = true
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/${local.image_filename}"
    destination = "${module.ansible.remote_playbook_path}/${local.image_filename}"
  }
}

resource "null_resource" "schema_loader_cassandra_image" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    triggers = join(",", var.triggers)
  }

  provisioner "local-exec" {
    command     = "docker pull ${local.schema_loader_cassandra_image} && docker save ${local.schema_loader_cassandra_image} | gzip -1 > ${local.schema_loader_cassandra_image_filename}"
    working_dir = path.module
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "scalardl_waitfor" {
  count = var.provision_count

  triggers = {
    triggers = join(",", var.triggers)
    vm_id    = var.vm_ids[count.index]
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
      "cd ${module.ansible.remote_playbook_path}/playbooks",
      "ansible-playbook -u ${var.user_name} -i ${var.host_list[count.index]}, docker-server.yml -e enable_tdagent=${var.enable_tdagent ? 1 : 0} -e monitor_host=monitor.${var.internal_domain}",
    ]
  }
}

resource "null_resource" "scalardl_push" {
  count = var.provision_count

  triggers = {
    triggers     = null_resource.docker_install[count.index].id,
    scalar_image = null_resource.scalardl_image_push[0].id
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = true
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["rsync -e 'ssh -o StrictHostKeyChecking=no' -cvv ${module.ansible.remote_playbook_path}/${local.image_filename} ${var.user_name}@${var.host_list[count.index]}:/tmp/"]
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

resource "null_resource" "schema_loader_cassandra_load" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    triggers     = null_resource.docker_install[0].id,
    scalar_image = null_resource.schema_loader_cassandra_image[0].id
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/${local.schema_loader_cassandra_image_filename}"
    destination = "/tmp/${local.schema_loader_cassandra_image_filename}"
  }

  provisioner "remote-exec" {
    inline = ["gzip -cd /tmp/${local.schema_loader_cassandra_image_filename} | docker load"]
  }
}

resource "null_resource" "scalardl_schema" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    triggers = null_resource.schema_loader_cassandra_load[0].id
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
      "docker run -e CASSANDRA_HOST='${local.scalar_cassandra_host}' -e CASSANDRA_USERNAME='${var.cassandra_username}' -e CASSANDRA_PASSWORD='${var.cassandra_password}' -e CASSANDRA_REPLICATION_FACTOR=${var.replication_factor} --rm ${local.schema_loader_cassandra_image}"
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
      "echo export SCALAR_IMAGE=${local.scalar_image} > env",
      "echo export SCALAR_CASSANDRA_HOST=${local.scalar_cassandra_host} >> env",
      "echo export SCALAR_CASSANDRA_USERNAME=${var.cassandra_username} >> env",
      "echo export SCALAR_CASSANDRA_PASSWORD=${var.cassandra_password} >> env",
      "source ./env",
      "docker-compose up -d",
    ]
  }
}
