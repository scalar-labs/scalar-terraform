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
    schema_loader_image = var.schema_loader_image
  }

  provisioner "local-exec" {
    command     = "docker pull ${var.schema_loader_image} && docker save ${var.schema_loader_image} | gzip -1 > ${local.schema_loader_image_filename}"
    working_dir = path.module
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "schema_loader_image_push" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    docker_image = null_resource.schema_loader_image[0].id
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = true
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/${local.schema_loader_image_filename}"
    destination = "${module.ansible.remote_playbook_path}/${local.schema_loader_image_filename}"
  }
}

resource "null_resource" "scalardl_waitfor" {
  count = var.provision_count

  triggers = {
    vm_id = var.vm_ids[count.index]
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

resource "null_resource" "schema_loader_push" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    triggers     = null_resource.docker_install[count.index].id,
    scalar_image = null_resource.schema_loader_image_push[0].id
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = true
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["rsync -e 'ssh -o StrictHostKeyChecking=no' -cvv ${module.ansible.remote_playbook_path}/${local.schema_loader_image_filename} ${var.user_name}@${var.host_list[count.index]}:/tmp/"]
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

  provisioner "remote-exec" {
    inline = ["gzip -cd /tmp/${local.schema_loader_image_filename} | docker load"]
  }
}

resource "null_resource" "scalardl_container_env_file_push" {
  count = var.provision_count

  triggers = {
    scalardl_load = null_resource.scalardl_load[count.index].id,
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "file" {
    source      = var.container_env_file
    destination = "$HOME/provision/container.env"
  }
}

resource "null_resource" "scalardl_schema" {
  count = var.provision_count > 0 ? 1 : 0

  triggers = {
    schema_loader_image_load         = null_resource.schema_loader_image_load[0].id
    scalardl_container_env_file_push = null_resource.scalardl_container_env_file_push[0].id
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
      "set -x",
      # Get the SCALAR_DB_* variables from the env file for docker-compose
      "eval `grep '^SCALAR_DB_' $HOME/provision/container.env`",
      "cmd=\"docker run --rm ${var.schema_loader_image} -p $SCALAR_DB_PASSWORD\"",
      "if [ $SCALAR_DB_STORAGE = 'cassandra' ]; then $cmd --cassandra -u $SCALAR_DB_USERNAME -h $SCALAR_DB_CONTACT_POINTS -P $SCALAR_DB_CONTACT_PORT -n NetworkTopologyStrategy -R ${var.cassandra_replication_factor};",
      "elif [ $SCALAR_DB_STORAGE = 'dynamo' ]; then $cmd --dynamo -u $SCALAR_DB_USERNAME --region $SCALAR_DB_CONTACT_POINTS;",
      "elif [ $SCALAR_DB_STORAGE = 'cosmos' ]; then $cmd --cosmos -h $SCALAR_DB_CONTACT_POINTS;",
      "else /bin/false;",
      "fi"
    ]
  }
}

resource "null_resource" "scalardl_container" {
  count = var.provision_count

  triggers = {
    scalardl_load                    = null_resource.scalardl_load[count.index].id
    scalardl_schema                  = null_resource.scalardl_schema[0].id
    scalardl_container_env_file_push = null_resource.scalardl_container_env_file_push[count.index].id
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
      "source ./env",
      "docker-compose up -d",
    ]
  }
}
