# Pangeo (HiMAT)

## Getting Started
1. Install [terraform](https://www.terraform.io/downloads.html), [jq](https://stedolan.github.io/jq/), [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/configure-kubectl.html), [aws-cli](https://aws.amazon.com/cli/), and [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
2. Configure the AWS CLI if you have not already. Instructions can be found [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
3. Modify `terraform.tfvars` as necessary.  
4. Run `terraform init`
5. Run `terraform apply --target=module.eks`
6. Run `terraform apply --target=module.kubernetes`

At this point, your cluster should be up and running. Verify this by running `kubectl get services --kubeconfig ./kubeconfig.yml`. You should see a list of a few services, including `dask-scheduler` and `jupyter-server`.
## Scaling
To scale the number of nodes in the cluster, change, `spot_pool_size` in `terraform.tfvars`, and run `terraform apply --target=module.eks` again.
## Deletion
To delete your cluster, run `terraform destroy --target=module.kubernetes` followed by `terraform destroy --target=module.eks`.
