module "ansible" {
  source = "../../../../provision/ansible"
}

resource "null_resource" "broker_waitfor" {
  count = var.provision_count

  triggers = {
    triggers = join(",", var.triggers)
    vm_id    = var.vm_ids[count.index]
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = var.use_agent
    private_key  = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["echo broker host up"]
  }
}

resource "null_resource" "broker" {
  count      = var.provision_count
  depends_on = [null_resource.broker_waitfor]

  triggers = {
    triggers = var.vm_ids[count.index]
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = var.use_agent
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${module.ansible.remote_playbook_path}/playbooks",
      "ansible-playbook -u ${var.user_name} -i ${var.host_list[count.index]}, pulsar-server.yml -e pulsar_component=${var.pulsar_component} -e enable_tdagent=${var.enable_tdagent ? 1 : 0} -e monitor_host=monitor.${var.internal_domain} -e zookeeper_servers=${join(",", var.zookeeper_servers)}",
    ]
  }
}
