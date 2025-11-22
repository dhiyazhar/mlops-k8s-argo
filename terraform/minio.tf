resource "helm_release" "minio" {
  depends_on = [
    null_resource.fetch_kubeconfig,
  ]

  name             = "minio"
  chart            = "minio"
  repository       = "https://charts.min.io/"
  create_namespace = "true"
  namespace        = "minio"
  version          = "5.4.0"

  values = [
    templatefile("${path.module}/helm-values/minio-values.yaml", {
      minio_root_user     = var.minio_root_user
      minio_root_password = var.minio_root_password
        
    })
  ]

}