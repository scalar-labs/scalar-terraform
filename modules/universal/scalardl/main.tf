locals {
  scalar_image   = "${var.scalardl_image_name}:${var.scalardl_image_tag}"
  image_filename = "${basename(var.scalardl_image_name)}-${var.scalardl_image_tag}.tar.gz"

  schema_loader_image_filename = format("%s%s", replace(basename(var.schema_loader_image), ":", "-"), ".tar.gz")
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
    command     = "docker pull ${local.scalar_image} && docker save ${local.scalar_image} | gzip -1 > ${local.image_filename}"
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

resource "null_resource" "schema_loader_image" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    triggers            = join(",", var.triggers)
    schema_loader_image = var.schema_loader_image
  }

  provisioner "local-exec" {
    command     = "docker pull ${var.schema_loader_image} && docker save ${var.schema_loader_image} | gzip -1 > ${local.schema_loader_image_filename}"
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

resource "null_resource" "schema_loader_image_load" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    triggers     = null_resource.docker_install[0].id,
    scalar_image = null_resource.schema_loader_image[0].id
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/${local.schema_loader_image_filename}"
    destination = "/tmp/${local.schema_loader_image_filename}"
  }

  provisioner "remote-exec" {
    inline = ["gzip -cd /tmp/${local.schema_loader_image_filename} | docker load"]
  }
}

resource "null_resource" "scalardl_schema" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    schema_loader_image_load = null_resource.schema_loader_image_load[0].id
    database                 = var.database
    database_contact_points  = var.database_contact_points
    database_contact_port    = var.database_contact_port
    database_username        = var.database_username
    database_password        = var.database_password
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
      format(
        "%s %s",
        "docker run --rm ${var.schema_loader_image} -h ${var.database_contact_points} -u ${var.database_username} -p ${var.database_password}",
        var.database == "cassandra" ? "--cassandra -P ${var.database_contact_port} -n NetworkTopologyStrategy -R ${var.cassandra_replication_factor}" :
        var.database == "dynamo" ? "--dynamo --region ${var.database_contact_points}" :
        var.database == "cosmos" ? "--cosmos -h ${var.database_contact_points} -p ${var.database_password}" :
        ""
      )
    ]
  }
}

resource "null_resource" "scalardl_container" {
  count = var.provision_count

  triggers = {
    scalardl_load   = null_resource.scalardl_load[count.index].id
    scalardl_schema = null_resource.scalardl_schema[0].id
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
      "echo export SCALAR_PORT=${var.scalardl_port} >> env",
      "echo export SCALAR_PRIVILEGED_PORT=${var.scalardl_privileged_port} >> env",
      "echo export SCALAR_DB_STORAGE=${var.database} >> env",
      "echo export SCALAR_DB_CONTACT_POINTS=${var.database_contact_points} >> env",
      "echo export SCALAR_DB_CONTACT_PORT=${var.database_contact_port} >> env",
      "echo export SCALAR_DB_USERNAME=${var.database_username} >> env",
      "echo export SCALAR_DB_PASSWORD=${var.database_password} >> env",
      "source ./env",
      "docker-compose up -d",
    ]
  }
}
