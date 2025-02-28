locals {
    #
    ssh_privkey = file("/home/xxx")
    calico_template = file("/home/xxx")

    #worker loops
    worker_name = "${var.env}-${var.app}-worker-"
    worker_name_list = [for i in range(var.worker_count) : "${local.worker_name}${i+1}"]
    ipworker_list = (var.worker_count == 1) ? ["${var.worker_address}1"] : [for i in range(var.worker_count) : "${var.worker_address}${i+1}"]
    ipworker_NAT_list = (var.worker_count == 1) ? ["${var.worker_NAT_address}1"] : [for i in range(var.worker_count) : "${var.worker_NAT_address}${i+1}"]
    
}