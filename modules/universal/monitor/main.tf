module "ansible" {
  source = "../../../provision/ansible"
}

resource "null_resource" "monitor_waitfor" {
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
    inline = [
      "echo -e 'Host github.com\n	StrictHostKeyChecking no\n' > ~/.ssh/config",
      "chmod 600 ~/.ssh/config",
    ]
  }
}

resource "null_resource" "docker_install" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.monitor_waitfor[count.index].id
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
      "ansible-playbook -u ${var.user_name} -i ${var.host_list[count.index]}, monitor-server.yml --extra-vars='enable_tdagent=${var.enable_tdagent ? 1 : 0}'",
    ]
  }
}

resource "null_resource" "monitor_container" {
  count = var.provision_count

  triggers = {
    triggers                      = null_resource.docker_install[0].id
    scalardl_blue_resource_count  = var.scalardl_blue_resource_count
    scalardl_green_resource_count = var.scalardl_green_resource_count
    cassandra_resource_count      = var.cassandra_resource_count
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
      "export slack_webhook_url=${var.slack_webhook_url}",
      "export alertmanager_url=monitor.${var.internal_domain}:9093",
      "export environment_name=${var.network_name}",
      "export scalardl_blue_resource_count=${var.scalardl_blue_resource_count}",
      "export scalardl_green_resource_count=${var.scalardl_green_resource_count}",
      "export cassandra_resource_count=${var.cassandra_resource_count}",
      "export cassandra_replication_factor=${var.replication_factor}",
      "export dashboard_local_forwarding_port=8000",
      "export grafana_datasource_url=monitor.${var.internal_domain}:9090",
      "export internal_domain=${var.internal_domain}",
      "j2 ./prometheus/prometheus.yml.j2 > ./prometheus/prometheus.yml",
      "j2 ./prometheus/scalardl_alert.rules.yml.j2 > ./prometheus/scalardl_alert.rules.yml",
      "j2 ./prometheus/cassandra_alert.rules.yml.j2 > ./prometheus/cassandra_alert.rules.yml",
      "j2 ./alertmanager/config.yml.j2 > ./alertmanager/config.yml",
      "j2 ./nginx/html_templates/index.html.j2 > ./nginx/html/index.html",
      "j2 ./grafana/provisioning/datasources/datasource.yml.j2 > ./grafana/provisioning/datasources/datasource.yml",
      "docker-compose down",
      "docker-compose up -d",
    ]
  }
}
