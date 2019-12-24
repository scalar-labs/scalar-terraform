module "ansible" {
  source = "../../../provision/ansible"
}

resource "null_resource" "reaper_waitfor" {
  count = var.provision_count

  triggers = {
    triggers = join(",", var.triggers)
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["echo reaper host up"]
  }
}

resource "null_resource" "docker_install" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.reaper_waitfor[count.index].id
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
      "ansible-playbook -u ${var.user_name} -i ${var.host_list[count.index]}, docker-server.yml --extra-vars='enable_tdagent=${var.enable_tdagent ? 1 : 0}'",
    ]
  }
}

resource "null_resource" "reaper_container" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.docker_install[0].id
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
    inline = [
      "cd $HOME/provision",
      "export REAPER_JMX_AUTH_USERNAME=",
      "export REAPER_JMX_AUTH_PASSWORD=",
      "export REAPER_STORAGE_TYPE=cassandra",
      "export CASSANDRA_REPLICATION_FACTOR=${var.replication_factor}",
      "export REAPER_CASS_CONTACT_POINTS=cassandra-lb.internal.scalar-labs.com",
      "j2 ./docker-compose.yml.j2 > ./docker-compose.yml",
      "docker-compose up -d",
    ]
  }
}
