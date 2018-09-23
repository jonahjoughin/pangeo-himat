# output "cluster_id" {
#   description = "The name/id of the EKS cluster."
#   value       = "${aws_eks_cluster.this.id}"
# }
#
# # output "cluster_certificate_authority_data" {
# #   description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
# #   value       = "${aws_eks_cluster.this.certificate_authority.0.data}"
# # }
#
# output "cluster_endpoint" {
#   description = "The endpoint for your EKS Kubernetes API."
#   value       = "${aws_eks_cluster.this.endpoint}"
# }
#
# output "cluster_version" {
#   description = "The Kubernetes server version for the EKS cluster."
#   value       = "${aws_eks_cluster.this.version}"
# }
#
# # output "config_map" {
# #   description = "A kubernetes configuration to authenticate to this EKS cluster."
# #   value       = "${data.template_file.config_map.rendered}"
# # }
# #
# # output "kubeconfig" {
# #   description = "kubectl config file contents for this EKS cluster."
# #   value       = "${data.template_file.kubeconfig.rendered}"
# # }
# #
# # output "token" {
# #   value = "${data.external.authenticator.result.token}"
# # }
#
output "dask_url" {
  value = "${module.kubernetes.dask_url}"
}

output "jupyter_url" {
    value = "${module.kubernetes.jupyter_url}"
}
